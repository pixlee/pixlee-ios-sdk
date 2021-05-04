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

    let cellConfiguration = PXLProductCellConfiguration(discountPrice: DiscountPrice(discountLayout: DiscountLayout.WITH_DISCOUNT_LABEL, isCurrencyLeading: true))
    var pixleeCredentials:PixleeCredentials = PixleeCredentials()
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
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 350, height: 150)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        if let collectionView = collectionView {
            //collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .systemGray5
            let bundle = Bundle(for: PXLAdvancedProductCell.self)
            collectionView.register(UINib(nibName: "PXLAdvancedProductCell", bundle: bundle), forCellWithReuseIdentifier: PXLAdvancedProductCell.defaultIdentifier)
            collectionView.register(ProductSectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductSectionCell.defaultIdentifier)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            collectionView.isPagingEnabled = false
            view.addSubview(collectionView)
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
            if let photos = photos , let newProducts = photos.first?.products{
                self.products = newProducts
                self.collectionView?.reloadData()

//                self.collectionView?.performBatchUpdates({
//                    self.collectionView?.insertSections(IndexSet(integer: 0))
//                }, completion: nil)
            }
        }
    }
}

extension ProductExampleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLAdvancedProductCell.defaultIdentifier, for: indexPath) as! PXLAdvancedProductCell

        cell.configuration = cellConfiguration
        cell.onBookmarkClicked = { [weak self] product, isSelected in
//            guard let strongSelf = self else { return }
//            strongSelf.delegate?.onBookmarkClicked(product: product, isSelected: isSelected)
        }
        let product = products?[indexPath.row]
        cell.pxlProduct = product
//        if let bookmarks = bookmarks, let product = product {
//            cell.isBookmarked = bookmarks[product.identifier] ?? false
//        }
        cell.actionButtonPressed = { [weak self] product in
//            guard let strongSelf = self else { return }
//            strongSelf.handleProductPressed(product: product)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = products?[indexPath.item] {
            //handleProductPressed(product: product)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        debugPrint("collectionView(viewForSupplementaryElementOfKind): \(indexPath)")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductSectionCell.defaultIdentifier, for: indexPath) as? ProductSectionCell
            else {
                fatalError("Invalid view type")
            }
            
            headerView.titleText = "layout option1"
            return headerView
        default:
            // 4
            assert(false, "Invalid element type")
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
//            return CGSize(width: 0, height: 0)
//        } else {
            return CGSize(width: 350, height: 150)
//        }
    }

}
