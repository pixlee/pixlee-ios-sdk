//
//  PXLImageCell.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Nuke
import UIKit

class PXLImageCell: UICollectionViewCell {
    static let defaultIdentifier = "ImageCell"

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
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
            }else{
                titleLabel.text = nil
            }
            
            playButton.isHidden = !viewModel.isVideo
            if (viewModel.contentType == "video"){
                print("It is a video with url: \(viewModel.sourceUrl)")
                let url = viewModel.videoUrl()
                print("url: \(url)")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
