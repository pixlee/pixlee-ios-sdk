//
//  PXLProductCell.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 15..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import UIKit

class PXLProductCell: UICollectionViewCell {
    static var defaultIdentifier = "PXLProductCell"

    @IBOutlet var productImageView: UIImageView!

    @IBOutlet var productActionButton: UIButton!

    var viewModel: PXLProduct? {
        didSet {
            guard let viewModel = viewModel else { return }

            if let imageUrl = viewModel.imageUrl {
                Nuke.loadImage(with: imageUrl, into: productImageView)
                productImageView.backgroundColor = .red
            }

            productActionButton.setTitle(viewModel.title, for: .normal)
        }
    }

    var actionButtonPressed: ((_ product: PXLProduct) -> Void)?

    @IBAction func actionButtonPressed(_ sender: Any) {
        if let actionPressed = actionButtonPressed, let viewModel = viewModel {
            actionPressed(viewModel)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
