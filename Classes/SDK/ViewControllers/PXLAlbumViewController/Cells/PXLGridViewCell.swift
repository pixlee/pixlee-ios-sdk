//
//  PXLGridViewCell.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 10. 11..
//

import UIKit

public class PXLGridViewCell: UICollectionViewCell {
    @IBOutlet var photoView: PXLPhotoView!
    private var photoModel: PXLPhoto?
    @IBOutlet var cellWidth: NSLayoutConstraint!
    @IBOutlet var cellHeight: NSLayoutConstraint!

    var isHighlihtingEnabled: Bool = false

    public func setupCell(photo: PXLPhoto, title: String?, subtitle: String?, buttonTitle: String?, configuration: PXLPhotoViewConfiguration = PXLPhotoViewConfiguration(), delegate: PXLPhotoViewDelegate? = nil) {
        photoModel = photo
        photoView.photo = photo
        photoView.title = title
        photoView.subtitle = subtitle
        photoView.buttonTitle = buttonTitle
        photoView.configuration = configuration
        photoView.delegate = delegate
        disableHighlightView()
    }

    func highlightView(muted: Bool) {
        if isHighlihtingEnabled {
            photoView.alpha = 1
            photoView.playVideo(muted: muted)
        }
    }

    func disableHighlightView() {
        if isHighlihtingEnabled {
            photoView.alpha = 1
            photoView.resetPlayer()
        }
    }

    public func playVideo(muted: Bool) {
        photoView.playVideo(muted: muted)
    }
    
    public func mutePlayer(_ muted: Bool){
        print("muted: \(muted)")
        photoView.mutePlayer(muted)
    }

    public func stopVideo() {
        photoView.resetPlayer()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        if isHighlihtingEnabled {
            photoView.alpha = 0.5
        }
        photoView.resetPlayer()
    }

    public static let identifier = "PXLGridViewCell"
}
