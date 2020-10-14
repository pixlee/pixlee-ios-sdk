//
//  PXLItemsView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 10. 13..
//

import UIKit
public protocol PXLItemsViewDelegate {
    func cellHeight() -> CGFloat
    func cellPadding() -> CGFloat
    func setupPhotoView(itemsView: PXLItemsView, photoView: PXLPhotoView, photo: PXLPhoto)
}

public class PXLItemsView: UIView {
    let itemsStack = UIStackView()

    public var photoViewDelegate: PXLPhotoViewDelegate?
    public var photoViewConfig: PXLPhotoViewConfiguration?

    public var delegate: PXLItemsViewDelegate?

    public var items: [PXLPhoto] = [] {
        didSet {
            resetData()
        }
    }

    public var listTitle: String? {
        didSet {
            titleLabel.text = listTitle
        }
    }

    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    public func setupView(photoView: PXLPhotoView,
                          title: String?,
                          subTitle: String?,
                          buttonTitle: String?,
                          configuration: PXLPhotoViewConfiguration = PXLPhotoViewConfiguration(),
                          delegate: PXLPhotoViewDelegate? = nil) {
        photoView.title = title
        photoView.subtitle = subTitle
        photoView.buttonTitle = buttonTitle
        photoView.configuration = configuration
        photoView.delegate = delegate
    }

    let titleLabel = UILabel()
    let scrollView = UIScrollView()

    private var itemHeight: CGFloat {
        return delegate?.cellHeight() ?? 200
    }

    private var padding: CGFloat {
        return delegate?.cellPadding() ?? 0
    }

    private var itemWidth: CGFloat {
        return (frame.size.width - padding) / 2
    }

    private func resetData() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
        ]

        NSLayoutConstraint.activate(scrollViewConstraints)

        translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(itemsStack)

        itemsStack.spacing = padding
        itemsStack.translatesAutoresizingMaskIntoConstraints = false
        let stackConstraints = [
            itemsStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            itemsStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            itemsStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            itemsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            itemsStack.widthAnchor.constraint(equalTo: widthAnchor),
        ]
        NSLayoutConstraint.activate(stackConstraints)

        itemsStack.axis = .vertical

        itemsStack.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }

        if listTitle != nil {
            let titleContainer = UIView()
            titleLabel.font = titleFont
            titleLabel.numberOfLines = 0

            titleContainer.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            let titleConstraints = [
                titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 0),
                titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: 0),
                titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 16),
                titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -16),
            ]
            NSLayoutConstraint.activate(titleConstraints)
            itemsStack.addArrangedSubview(titleContainer)
        }

        var row = 0
        var currentRowStack = UIStackView()
        currentRowStack.spacing = padding
        items.forEach { photo in
            let photoView = PXLPhotoView(frame: .zero, photo: photo)
            photoView.photo = photo

            photoView.delegate = photoViewDelegate
            if let photoViewConfig = photoViewConfig {
                photoView.configuration = photoViewConfig
            }

            self.delegate?.setupPhotoView(itemsView: self, photoView: photoView, photo: photo)

            currentRowStack.addArrangedSubview(photoView)

            photoView.translatesAutoresizingMaskIntoConstraints = false
            photoView.clipsToBounds = true
            let constraints = [
                photoView.heightAnchor.constraint(equalToConstant: itemHeight),
                photoView.widthAnchor.constraint(lessThanOrEqualTo: currentRowStack.widthAnchor, multiplier: 0.5),
            ]
            NSLayoutConstraint.activate(constraints)

            if row % 2 == 1 || items.last == photo {
                if items.last == photo {
                    let spacer = UIView()
                    currentRowStack.addArrangedSubview(spacer)
                }
                itemsStack.addArrangedSubview(currentRowStack)

                currentRowStack.translatesAutoresizingMaskIntoConstraints = false
                let rowConstraints = [
                    currentRowStack.widthAnchor.constraint(equalTo: itemsStack.widthAnchor),
                ]
                NSLayoutConstraint.activate(rowConstraints)

                currentRowStack = UIStackView()
                currentRowStack.spacing = padding
            }
            row += 1
        }
    }
}
