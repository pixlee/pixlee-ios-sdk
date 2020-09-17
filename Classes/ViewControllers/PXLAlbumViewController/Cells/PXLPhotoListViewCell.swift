//
//  PXLPhotoListViewCell.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import UIKit

public class PXLPhotoListViewCell: UITableViewCell {
    public var photoModel: PXLPhoto? {
        initPhotoView()
    }

    private var photoView: PXLPhotoView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let photoModel = photoModel {
            initPhotoView()
        }
    }

    func initPhotoView() {
        photoView?.removeFromSuperview()
        guard let photoModel = photoModel else { return }
        photoView = PXLPhotoView(frame: contentView.bounds, photo: photoModel, title: photoModel.title, subtitle: "Subtite", buttonTitle: "Open")
        if let photoView = photoView {
            contentView.addSubview(photoView)
            photoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: photoView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: photoView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: photoView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: photoView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
