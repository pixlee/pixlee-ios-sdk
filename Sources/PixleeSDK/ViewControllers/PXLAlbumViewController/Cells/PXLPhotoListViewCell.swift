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

    public func setupCell(photo: PXLPhoto, title: String, subtitle: String, buttonTitle: String, configuration: PXLPhotoViewConfiguration = PXLPhotoViewConfiguration(), delegate: PXLPhotoViewDelegate? = nil) {
        photoModel = photo
        photoView.delegate = delegate
        photoView.configuration = configuration
        
        photoView.photo = photo
        photoView.title = title
        photoView.subtitle = subtitle
        photoView.buttonTitle = buttonTitle
        photoView.stopVideo()
    }
    
    public func playVideo(muted: Bool = false){
        photoView.playVideo(muted: muted)
    }
    
    public func stopVideo(){
        photoView.stopVideo()
    }

    func highlightView() {
        photoView.alpha = 1
        photoView.stopVideo()
    }

    func disableHighlightView() {
        photoView.alpha = 0.5
        photoView.stopVideo()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disableHighlightView()
    }

    public static let identifier = "PXLPhotoListViewCell"
}
