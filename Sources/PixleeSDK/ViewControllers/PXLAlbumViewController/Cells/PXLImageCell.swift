//
//  PXLImageCell.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import Gifu
import UIKit

protocol PXLImageCellDelegate {
    func pxlImageCellPlayTapped(viewModel: PXLPhoto)
}

class PXLImageCell: UICollectionViewCell {
    static let defaultIdentifier = "ImageCell"

    var gifView = Gifu.GIFImageView()
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playButton: UIButton!

    @IBOutlet weak var imageContent: UIView!
    var delegate: PXLImageCellDelegate?

    var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            self.imageContent.insertSubview(gifView, at: 0)
            gifView.translatesAutoresizingMaskIntoConstraints = false
            
            let gifConstraints = [
                gifView.leadingAnchor.constraint(equalTo: self.imageContent.leadingAnchor, constant: 8),
                gifView.trailingAnchor.constraint(equalTo: self.imageContent.trailingAnchor, constant: -8),
                gifView.bottomAnchor.constraint(equalTo: self.imageContent.bottomAnchor, constant: -8),
                gifView.topAnchor.constraint(equalTo: self.imageContent.topAnchor, constant: 8),
                gifView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
            ]

            NSLayoutConstraint.activate(gifConstraints)
            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: gifView)
            }else{
                gifView.image = nil
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
