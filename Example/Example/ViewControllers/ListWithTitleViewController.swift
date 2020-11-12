//
//  ListWithTitleViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 10. 13..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class ListWithTitleViewController: UIViewController {
    public var photos = [PXLPhoto]()

    public var listTitle: String? {
        didSet {
            itemsView.listTitle = listTitle
        }
    }

    public var titleGifName: String? {
        didSet {
            itemsView.titleGifName = titleGifName
        }
    }

    public var titleGifURL: String? {
        didSet {
            itemsView.titleGifURL = titleGifURL
        }
    }

    var itemsView = PXLItemsView()
    override func viewDidLoad() {
        super.viewDidLoad()

        itemsView.delegate = self
        view.addSubview(itemsView)
        itemsView.translatesAutoresizingMaskIntoConstraints = false
        let itemsConstraints = [
            itemsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemsView.topAnchor.constraint(equalTo: view.topAnchor),
            itemsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(itemsConstraints)
        itemsView.items = photos
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ListWithTitleViewController: PXLItemsViewDelegate {
    func cellHeight() -> CGFloat {
        return 550
    }

    func cellPadding() -> CGFloat {
        return 10
    }

    func setupPhotoView(itemsView: PXLItemsView, photoView: PXLPhotoView, photo: PXLPhoto) {
        itemsView.setupView(photoView: photoView, title: "Title", subTitle: "Subtitle", buttonTitle: "buttonTitle")
        let playImage = UIImage(named: "material-play_arrow-36px", in: Bundle(for: PXLPhotoView.self), with: nil)
        photoView.configuration = PXLPhotoViewConfiguration(buttonImage: playImage, enableVideoPlayback: false)
    }
}
