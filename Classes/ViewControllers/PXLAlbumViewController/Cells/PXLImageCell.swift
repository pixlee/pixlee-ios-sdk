//
//  PXLImageCell.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import UIKit

protocol PXLImageCellDelegate {
    func pxlImageCellPlayTapped(viewModel: PXLPhoto)
}

class PXLImageCell: UICollectionViewCell {
    static let defaultIdentifier = "ImageCell"

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playButton: UIButton!

    var delegate: PXLImageCellDelegate?

    var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: imageView)
            }
            if let userName = viewModel.username {
                authorLabel.text = "@\(userName)"
            }
            if let title = viewModel.title {
                titleLabel.text = title
            } else {
                titleLabel.text = nil
            }

            playButton.isHidden = !viewModel.isVideo
        }
    }

    @IBAction func playTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        delegate?.pxlImageCellPlayTapped(viewModel: viewModel)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
