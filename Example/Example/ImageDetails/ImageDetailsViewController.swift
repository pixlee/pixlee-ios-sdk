//
//  ImageDetailsViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import UIKit
import pixlee_api

class ImageDetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceImageView: UIImageView!

    @IBOutlet var productCollectionView: UICollectionView!

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else { return }
            _ = view

            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: imageView)
            }
            titleLabel.text = (viewModel.title != nil) ? viewModel.title : ""

            usernameLabel.text = viewModel.username

            if let updatedAt = viewModel.updatedAt {
                dateLabel.text = updatedAt.getElapsedInterval()
            } else {
                dateLabel.text = ""
            }

            self.sourceImageView.image = viewModel.sourceIconImage
        }
    }

    override func viewDidLoad() {
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
        productCollectionView.register(UINib(nibName: "PXLProductCell", bundle: nil), forCellWithReuseIdentifier: PXLProductCell.defaultIdentifier)
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

extension ImageDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.products?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLProductCell.defaultIdentifier, for: indexPath) as! PXLProductCell

        cell.viewModel = viewModel?.products?[indexPath.row]
        cell.actionButtonPressed = { product in
            self.handleProductPressed(product: product)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = viewModel?.products?[indexPath.item] {
            handleProductPressed(product: product)
        }
    }
}

extension ImageDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
