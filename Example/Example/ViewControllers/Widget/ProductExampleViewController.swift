//
//  ProductExampleViewController.swift
//  Example
//
//  Created by Sungjun Hong on 5/4/21.
//  Copyright © 2021 Pixlee. All rights reserved.
//

import Foundation
import PixleeSDK
import UIKit

class ProductExampleViewController: UIViewController {
    static func getInstance() -> ProductExampleViewController {
        let vc = ProductExampleViewController(nibName: "EmptyViewController", bundle: Bundle.main)
        return vc
    }

    let cellConfigurations: [PXLProductCellConfiguration] = [
        PXLProductCellConfiguration(),
        PXLProductCellConfiguration(discountPrice: DiscountPrice(discountLayout: DiscountLayout.CROSS_THROUGH, isCurrencyLeading: false)),
        PXLProductCellConfiguration(discountPrice: DiscountPrice(discountLayout: DiscountLayout.CROSS_THROUGH, isCurrencyLeading: true)),
        PXLProductCellConfiguration(discountPrice: DiscountPrice(discountLayout: DiscountLayout.WAS_OLD_PRICE, isCurrencyLeading: false)),
        PXLProductCellConfiguration(discountPrice: DiscountPrice(discountLayout: DiscountLayout.WAS_OLD_PRICE, isCurrencyLeading: true)),
        PXLProductCellConfiguration(discountPrice: DiscountPrice(discountLayout: DiscountLayout.WITH_DISCOUNT_LABEL, isCurrencyLeading: false)),
        PXLProductCellConfiguration(discountPrice: DiscountPrice(discountLayout: DiscountLayout.WITH_DISCOUNT_LABEL, isCurrencyLeading: true))
    ]

    var pixleeCredentials: PixleeCredentials = PixleeCredentials()
    var collectionView: UICollectionView? = nil
    var album = PXLAlbum()
    public var products: [PXLProduct]?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        initAlbum()
        loadPhotos()
    }

    var flowLayout: UICollectionViewFlowLayout? = nil

    func setupCollectionView() {
        flowLayout = UICollectionViewFlowLayout()
        if let flowLayout = flowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.itemSize = CGSize(width: 350, height: 150)
            flowLayout.headerReferenceSize = CGSize(width: 350, height: 50)
            collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        }


        if let collectionView = collectionView {
            //collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.delegate = self
            collectionView.isPrefetchingEnabled = true
            collectionView.dataSource = self
            collectionView.backgroundColor = .systemGray5
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            collectionView.isPagingEnabled = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false

            let bundle = PXLDefaults.getBundleForApp(for: PXLAdvancedProductCell.self)
            
            collectionView.register(UINib(nibName: "PXLAdvancedProductCell", bundle: bundle), forCellWithReuseIdentifier: PXLAdvancedProductCell.defaultIdentifier)
            collectionView.register(ProductSectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductSectionCell.defaultIdentifier)

            view.addSubview(collectionView)

            let margins = view.layoutMarginsGuide
            let constraints = [
                collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
                collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
                collectionView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
                collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0),
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }

    func initAlbum() {
        do {
            try pixleeCredentials = PixleeCredentials.create()
        } catch {
            self.showPopup(message: error.localizedDescription)
        }

        if let albumId = pixleeCredentials.albumId {
            album = PXLAlbum(identifier: albumId)
        }

        var filterOptions = PXLAlbumFilterOptions(contentType: ["video"])
        album.filterOptions = filterOptions
        album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
    }

    var sections: [Int] = [1]
    var isFreezingNetworking = false

    func loadPhotos() {
        if isFreezingNetworking {
            return
        }

        isFreezingNetworking = true
        _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, error in
            guard error == nil else {
                self.showPopup(message: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }

            self.isFreezingNetworking = false
            if let photos = photos {
                var newProducts = [PXLProduct]()
                photos.forEach { itemPhoto in
                    if !(itemPhoto.products?.isEmpty ?? true), let products = itemPhoto.products {
                        newProducts.append(contentsOf: products)
                    }
                }
                print("Locale.current.languageCode : \(Locale.current.languageCode )")
                print("Locale.preferredLanguages : \(Locale.preferredLanguages )")
                if let item = Locale.preferredLanguages.last {
                    print("Locale.preferredLanguages.first.prefix(2): \(item.prefix(2))")
                }
                
                self.products = newProducts.filter{product in product.salesStartDate != nil}
                self.collectionView?.reloadData()
            }
        }
    }
}

extension ProductExampleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if products?.isEmpty ?? true {
            return 0
        } else {
            return cellConfigurations.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return min(1, products?.count ?? 0)
        } else {
            return min(2, products?.count ?? 0)
        }

    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLAdvancedProductCell.defaultIdentifier, for: indexPath) as! PXLAdvancedProductCell
        cell.configuration = cellConfigurations[indexPath.section]
        cell.pxlProduct = products?[indexPath.row]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductSectionCell.defaultIdentifier, for: indexPath) as? ProductSectionCell
                    else {
                fatalError("Invalid view type")
            }

            if let discountPrice = cellConfigurations[indexPath.section].discountPrice {
                let isCurrencyLeading = discountPrice.isCurrencyLeading ? ", isCurrencyLeading: true" : ""
                headerView.titleText = "\(discountPrice.discountLayout.rawValue)\(isCurrencyLeading)"
            } else {
                headerView.titleText = "No option"
            }
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
}

extension ProductExampleViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return flowLayout?.itemSize ?? CGSize(width: 350, height: 50)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
