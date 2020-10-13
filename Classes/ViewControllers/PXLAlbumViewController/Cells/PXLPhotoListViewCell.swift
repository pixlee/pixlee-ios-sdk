//
//  PXLPhotoListViewCellv2.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 20..
//

import UIKit

public class PXLPhotoListViewCell: UITableViewCell {
    @IBOutlet var photoView: PXLPhotoView!
    private var photoModel: PXLPhoto?

    public func setupCell(photo: PXLPhoto, title: String, subtitle: String, buttonTitle: String, configuration: PXLPhotoViewConfiguration? = PXLPhotoViewConfiguration(), delegate: PXLPhotoViewDelegate? = nil) {
        photoModel = photo
        photoView.photo = photo
        photoView.title = title
        photoView.subtitle = subtitle
        photoView.buttonTitle = buttonTitle
        photoView.configuration = configuration
        photoView.delegate = delegate
    }

    func highlightView() {
        photoView.alpha = 1
        photoView.continuePlaying()
    }

    func disableHighlightView() {
        photoView.alpha = 0.5
        photoView.stopPlaying()
    }

//    override public func prepareForReuse() {
//        super.prepareForReuse()
//        disableHighlightView()
//    }

    public static let identifier = "PXLPhotoListViewCell"
}
