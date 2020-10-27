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
    let loadingIndicator = UIActivityIndicatorView(style: .gray)
    var titleLabel = UILabel()

    private var cachedGif: UIImage?

    override func prepareForReuse() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let viewModel = viewModel {
            titleGifImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - viewModel.padding)
            loadingIndicator.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            loadingIndicator.center = center
        }
        print("titleGIf: \(titleGifImage)")
    }

    func customInit() {
        guard let viewModel = viewModel else { return }

        titleGifImage.contentMode = viewModel.gifContentMode
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        if let titleGifName = viewModel.titleGifName {
            titleGifImage.backgroundColor = .green
            titleGifImage.image = UIImage.gif(name: titleGifName)

            addSubview(titleGifImage)

        } else if let titleGifURL = viewModel.titleGifUrl, self.cachedGif == nil {
            loadingIndicator.startAnimating()

            self.addSubview(loadingIndicator)

            DispatchQueue.global(qos: .userInitiated).async {
                let gif = UIImage.gif(url: titleGifURL)
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.cachedGif = gif
                    self.loadingIndicator.removeFromSuperview()
                    self.addSubview(self.titleGifImage)

                    self.titleGifImage.image = gif
                }
            }
        } else if let downloadedGif = cachedGif {
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
