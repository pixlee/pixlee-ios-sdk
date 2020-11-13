//
//  PXLItemsView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 10. 13..
//

import Gifu
import Nuke
import UIKit

public protocol PXLItemsViewDelegate {
    func cellHeight() -> CGFloat
    func cellPadding() -> CGFloat
    func setupPhotoView(itemsView: PXLItemsView, photoView: PXLPhotoView, photo: PXLPhoto)
    func gifHeight() -> CGFloat
    func gifContentMode() -> UIView.ContentMode
}

public extension PXLItemsViewDelegate {
    func gifHeight() -> CGFloat {
        return 200
    }

    func gifContentMode() -> UIView.ContentMode {
        return .scaleAspectFill
    }
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

    public var titleGifName: String?

    public var titleGifURL: String?

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
    var titleGifImage = Gifu.GIFImageView()
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

    private var gifHeight: CGFloat {
        return delegate?.gifHeight() ?? 200
    }

    private var gifContentMode: UIView.ContentMode {
        return delegate?.gifContentMode() ?? .scaleAspectFit
    }

    private func resetData() {
        itemsStack.arrangedSubviews.forEach { item in
            item.removeFromSuperview()
        }
        itemsStack.removeFromSuperview()
        scrollView.removeFromSuperview()

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

        titleGifImage.contentMode = gifContentMode
        titleGifImage.clipsToBounds = true

        if let titleGifName = titleGifName {
            titleGifImage.animate(withGIFNamed: titleGifName)
            itemsStack.addArrangedSubview(titleGifImage)
            let gifContstraints = [
                titleGifImage.leadingAnchor.constraint(equalTo: itemsStack.leadingAnchor),
                titleGifImage.trailingAnchor.constraint(equalTo: itemsStack.trailingAnchor),
                titleGifImage.heightAnchor.constraint(equalToConstant: gifHeight),
            ]
            NSLayoutConstraint.activate(gifContstraints)
        } else if let titleGifURL = titleGifURL {
            let gifContainer = UIView()
            gifContainer.clipsToBounds = true
            gifContainer.translatesAutoresizingMaskIntoConstraints = false
            let loadingIndicator = UIActivityIndicatorView(style: .gray)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.startAnimating()
            let loadingConstraints = [
                gifContainer.heightAnchor.constraint(equalToConstant: gifHeight),
                loadingIndicator.centerYAnchor.constraint(equalTo: gifContainer.centerYAnchor, constant: 0),
                loadingIndicator.centerXAnchor.constraint(equalTo: gifContainer.centerXAnchor, constant: 0),
                loadingIndicator.heightAnchor.constraint(equalToConstant: 30),
                loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
            ]
            gifContainer.addSubview(loadingIndicator)
            itemsStack.addArrangedSubview(gifContainer)

            NSLayoutConstraint.activate(loadingConstraints)

            Nuke.loadImage(with: URL(string: titleGifURL)!, into: titleGifImage, completion: {
                _ in
                loadingIndicator.removeFromSuperview()
                gifContainer.addSubview(self.titleGifImage)
                self.titleGifImage.translatesAutoresizingMaskIntoConstraints = false
                let gifContstraints = [
                    self.titleGifImage.leadingAnchor.constraint(equalTo: gifContainer.leadingAnchor),
                    self.titleGifImage.trailingAnchor.constraint(equalTo: gifContainer.trailingAnchor),
                    self.titleGifImage.bottomAnchor.constraint(equalTo: gifContainer.bottomAnchor),
                    self.titleGifImage.topAnchor.constraint(equalTo: gifContainer.topAnchor),
                ]
                NSLayoutConstraint.activate(gifContstraints)
            })

        } else if listTitle != nil {
            let titleContainer = UIView()
            titleLabel.font = titleFont
            titleLabel.numberOfLines = 0

            titleContainer.addSubview(titleLabel)
            titleContainer.translatesAutoresizingMaskIntoConstraints = false
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

        var itemIndex = 0
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

            if itemIndex % 2 == 1 || itemIndex == items.count - 1 {
                if itemIndex == items.count - 1 {
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
            itemIndex += 1
        }
    }
}
