//
//  PXLGridHeaderView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 10. 23..
//

import UIKit

public struct PXLGridHeaderSettings {
    public let height: CGFloat
    public let width: CGFloat
    public let padding: CGFloat
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let gifContentMode: UIView.ContentMode

    public let title: String?
    public let titleGifName: String?
    public let titleGifUrl: String?

    public init(title: String? = nil, titleGifName: String? = nil, titleGifUrl: String? = nil, height: CGFloat = 200, width: CGFloat = 200, padding: CGFloat = 10, titleFont: UIFont = UIFont.boldSystemFont(ofSize: 24), titleColor: UIColor = .black, gifContentMode: UIView.ContentMode = .scaleAspectFill) {
        self.title = title
        self.titleGifName = titleGifName
        self.titleGifUrl = titleGifUrl
        self.height = height
        self.width = width
        self.gifContentMode = gifContentMode

        self.padding = padding
        self.titleFont = titleFont
        self.titleColor = titleColor
    }
}

class PXLGridHeaderView: UICollectionReusableView {
    var viewModel: PXLGridHeaderSettings? {
        didSet {
            customInit()
        }
    }

    var titleGifImage = UIImageView()
    var titleLabel = UILabel()

    private var cachedGif: UIImage?

    override func prepareForReuse() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }

    func customInit() {
        guard let viewModel = viewModel else { return }
        titleGifImage.contentMode = viewModel.gifContentMode
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        if let titleGifName = viewModel.titleGifName {
            titleGifImage.translatesAutoresizingMaskIntoConstraints = false
            titleGifImage.image = UIImage.gifImageWithName(titleGifName)
            addSubview(titleGifImage)
            let gifContstraints = [
                titleGifImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleGifImage.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleGifImage.topAnchor.constraint(equalTo: topAnchor),
                titleGifImage.bottomAnchor.constraint(equalTo: bottomAnchor),
                heightAnchor.constraint(equalToConstant: viewModel.height),
            ]
            NSLayoutConstraint.activate(gifContstraints)
        } else if let titleGifURL = viewModel.titleGifUrl, self.cachedGif == nil {
            let gifContainer = UIView()
            gifContainer.clipsToBounds = true
            gifContainer.translatesAutoresizingMaskIntoConstraints = false
            let loadingIndicator = UIActivityIndicatorView(style: .gray)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.startAnimating()
            let loadingConstraints = [
                loadingIndicator.centerYAnchor.constraint(equalTo: gifContainer.centerYAnchor, constant: 0),
                loadingIndicator.centerXAnchor.constraint(equalTo: gifContainer.centerXAnchor, constant: 0),
                loadingIndicator.heightAnchor.constraint(equalToConstant: 30),
                loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
                gifContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                gifContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                gifContainer.topAnchor.constraint(equalTo: topAnchor),
                gifContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
                heightAnchor.constraint(equalToConstant: viewModel.height),
            ]
            gifContainer.addSubview(loadingIndicator)
            addSubview(gifContainer)

            NSLayoutConstraint.activate(loadingConstraints)

            DispatchQueue.global(qos: .userInitiated).async {
                let gif = UIImage.gifImageWithURL(titleGifURL)
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.cachedGif = gif
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
                    self.titleGifImage.image = gif
                }
            }

        } else if let downloadedGif = cachedGif {
            let gifContainer = UIView()
            gifContainer.addSubview(titleGifImage)
            addSubview(gifContainer)

            gifContainer.translatesAutoresizingMaskIntoConstraints = false
            translatesAutoresizingMaskIntoConstraints = false
            titleGifImage.translatesAutoresizingMaskIntoConstraints = false
            let gifContstraints = [
                titleGifImage.leadingAnchor.constraint(equalTo: gifContainer.leadingAnchor),
                titleGifImage.trailingAnchor.constraint(equalTo: gifContainer.trailingAnchor),
                titleGifImage.bottomAnchor.constraint(equalTo: gifContainer.bottomAnchor),
                titleGifImage.topAnchor.constraint(equalTo: gifContainer.topAnchor),
                gifContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                gifContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                gifContainer.topAnchor.constraint(equalTo: topAnchor, constant: viewModel.padding),
                gifContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -viewModel.padding),
                heightAnchor.constraint(equalToConstant: viewModel.height),
            ]
            NSLayoutConstraint.activate(gifContstraints)
            titleGifImage.image = downloadedGif
        } else if viewModel.title != nil {
            titleLabel.font = viewModel.titleFont
            titleLabel.textColor = viewModel.titleColor
            titleLabel.text = viewModel.title
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)

            let titleConstraints = [
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                heightAnchor.constraint(equalToConstant: viewModel.height),
                widthAnchor.constraint(equalToConstant: viewModel.width),
            ]

            NSLayoutConstraint.activate(titleConstraints)
        }
    }
}
