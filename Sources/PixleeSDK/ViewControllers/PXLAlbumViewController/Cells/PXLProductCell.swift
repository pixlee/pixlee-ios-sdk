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

    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var productActionButton: UIButton!

    var viewModel: PXLProduct? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.contentView.layer.cornerRadius = 4
            self.contentView.backgroundColor = .white
            productImageView.layer.cornerRadius = 4
            
            if let imageUrl = viewModel.imageThumbUrl {
                Nuke.loadImage(with: imageUrl, into: productImageView)
            }else{
                productImageView.image = nil
            }

            productActionButton.setTitle(viewModel.formattedPrice, for: .normal)
            productTitleLabel.text = viewModel.title
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
