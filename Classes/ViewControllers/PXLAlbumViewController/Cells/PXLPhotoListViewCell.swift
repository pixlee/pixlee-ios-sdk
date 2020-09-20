//
//  PXLPhotoListViewCellv2.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 20..
//

import UIKit

class PXLPhotoListViewCell: UITableViewCell {
    @IBOutlet var photoView: PXLPhotoView!
    private var photoModel: PXLPhoto?

    public func setupCell(photo: PXLPhoto, title: String, subtitle: String, buttonTitle: String) {
        photoModel = photo
        photoView.contentMode = .scaleAspectFill
        photoView.photo = photo
        photoView.title = title
        photoView.subtitle = subtitle
        photoView.buttonTitle = buttonTitle
//        photoView.textColor = UIColor.b
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public static let identifier = "PXLPhotoListViewCell"
}
