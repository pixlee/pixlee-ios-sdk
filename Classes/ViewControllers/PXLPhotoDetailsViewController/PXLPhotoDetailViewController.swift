//
//  ImageDetailsViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import UIKit

public class PXLPhotoDetailViewController: UIViewController {
    public static func viewControllerForPhoto(photo: PXLPhoto) -> PXLPhotoDetailViewController {
        let bundle = Bundle(for: PXLPhotoDetailViewController.self)
        let imageDetailsVC = PXLPhotoDetailViewController(nibName: "PXLPhotoDetailViewController", bundle: bundle)
        imageDetailsVC.viewModel = photo
        return imageDetailsVC
    }

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceImageView: UIImageView!

    @IBOutlet var productCollectionView: UICollectionView!

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    public var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else { return }
            _ = view

            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: imageView)
            }
            titleLabel.text = (viewModel.photoTitle != nil) ? viewModel.photoTitle : ""

            usernameLabel.text = viewModel.username

            if let updatedAt = viewModel.updatedAt {
                dateLabel.text = updatedAt.getElapsedInterval()
            } else {
                dateLabel.text = ""
            }

            sourceImageView.image = viewModel.sourceIconImage
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        setupCollectionView()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        productCollectionView.setCollectionViewLayout(layout, animated: false)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        let bundle = Bundle(for: PXLImageCell.self)
        productCollectionView.register(UINib(nibName: "PXLProductCell", bundle: bundle), forCellWithReuseIdentifier: PXLProductCell.defaultIdentifier)
    }

    @objc func doneButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    func handleProductPressed(product: PXLProduct) {
        if let url = product.link?.absoluteString.removingPercentEncoding, let productURL = URL(string: url) {
            UIApplication.shared.open(productURL, options: [:], completionHandler: nil)
        }
    }
}

extension PXLPhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.products?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLProductCell.defaultIdentifier, for: indexPath) as! PXLProductCell

        cell.viewModel = viewModel?.products?[indexPath.row]
        cell.actionButtonPressed = { product in
            self.handleProductPressed(product: product)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = viewModel?.products?[indexPath.item] {
            handleProductPressed(product: product)
        }
    }
}

extension PXLPhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
