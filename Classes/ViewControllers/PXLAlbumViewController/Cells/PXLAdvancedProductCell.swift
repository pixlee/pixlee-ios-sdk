//
//  PXLAdvancedProductCell.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import Nuke
import UIKit

class PXLAdvancedProductCell: UICollectionViewCell {
    static var defaultIdentifier = "PXLAdvancedProductCell"

    @IBOutlet var cellContainer: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    @IBOutlet var shopBackground: UIView!
    @IBOutlet var shopIcon: UIImageView!
    @IBOutlet var bookmarkButton: UIButton!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var itemImageView: UIImageView!

    var configuration: PXLProductCellConfiguration? {
        didSet {
            guard let config = configuration else { return }

            bookmarkButton.setImage(config.bookmarkOffImage, for: .normal)

            shopIcon.image = config.shopImage

            shopBackground.backgroundColor = config.shopBackgroundColor

            if config.shopBackgroundHidden {
                shopBackground.backgroundColor = .clear
            }
        }
    }

    var onBookmarkClicked: ((_ product: PXLProduct, _ isSelected: Bool) -> Void)?

    var isBookmarked: Bool = false {
        didSet {
            guard let config = configuration else { return }

            if isBookmarked {
                bookmarkButton.setImage(config.bookmarkOnImage, for: .normal)
            } else {
                bookmarkButton.setImage(config.bookmarkOffImage, for: .normal)
            }
        }
    }

    var viewModel: PXLProduct? {
        didSet {
            guard let viewModel = viewModel else { return }

            cellContainer.layer.cornerRadius = 4
            cellContainer.backgroundColor = .white
            itemImageView.layer.cornerRadius = 4
            shopBackground.layer.cornerRadius = 20

            if let imageUrl = viewModel.imageThumbUrl {
                Nuke.loadImage(with: imageUrl, into: itemImageView)
            }else{
                itemImageView.image = nil
            }

            actionButton.setAttributedTitle(viewModel.attributedPrice, for: .normal)
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.productDescription
        }
    }

    var actionButtonPressed: ((_ product: PXLProduct) -> Void)?

    @IBAction func actionButtonPressed(_ sender: Any) {
        if let actionPressed = actionButtonPressed, let viewModel = viewModel {
            actionPressed(viewModel)
        }
    }

    @IBAction func bookmarkPressed(_ sender: Any) {
        isBookmarked.toggle()
        if let bookmarkHandling = onBookmarkClicked, let viewModel = viewModel {
            bookmarkHandling(viewModel, isBookmarked)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContainer.layer.cornerRadius = 4
    }
}
