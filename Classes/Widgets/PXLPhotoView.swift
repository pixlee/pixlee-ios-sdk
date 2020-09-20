//
//  PXLPhotoView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import Nuke
import UIKit

public protocol PXLPhotoViewDelegate {
    func onPhotoActionClicked(photo: PXLPhoto)
}

public class PXLPhotoView: UIView {
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var actionButton: UIButton?

    public var photo: PXLPhoto? {
        didSet {
            if let imageUrl = photo?.photoUrl(for: .medium), let imageView = imageView {
                Nuke.loadImage(with: imageUrl, into: imageView)
            }
        }
    }

    public var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }

    public var subtitle: String? {
        didSet {
            subtitleLabel?.text = subtitle
        }
    }

    public var textColor: UIColor = UIColor.white {
        didSet {
            titleLabel?.textColor = textColor
            subtitleLabel?.textColor = textColor
            actionButton?.tintColor = textColor
            actionButton?.layer.borderColor = textColor.cgColor
        }
    }

    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold) {
        didSet {
            titleLabel?.font = titleFont
        }
    }

    public var subtitleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular) {
        didSet {
            subtitleLabel?.font = subtitleFont
        }
    }

    override public var contentMode: UIView.ContentMode {
        didSet {
            imageView?.contentMode = contentMode
        }
    }

    public var buttonBorderWidth: CGFloat = 1 {
        didSet {
            actionButton?.layer.borderWidth = buttonBorderWidth
        }
    }

    public var buttonTitle: String? {
        didSet {
            actionButton?.setTitle(buttonTitle, for: .normal)
        }
    }

    public var buttonImage: UIImage? {
        didSet {
            actionButton?.setImage(buttonImage, for: .normal)
        }
    }

    public var delegate: PXLPhotoViewDelegate?

    func prepareViews() {
        imageView = UIImageView(frame: frame)

        titleLabel = UILabel()
        titleLabel?.font = titleFont
        titleLabel?.text = title
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = textColor

        subtitleLabel = UILabel()
        subtitleLabel?.font = subtitleFont
        subtitleLabel?.text = subtitle
        subtitleLabel?.textAlignment = .center
        subtitleLabel?.textColor = textColor

        actionButton = UIButton(type: .system)

        actionButton?.tintColor = textColor
        actionButton?.layer.borderColor = textColor.cgColor
        actionButton?.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        actionButton?.layer.cornerRadius = 12
        actionButton?.layer.borderWidth = buttonBorderWidth

        translatesAutoresizingMaskIntoConstraints = false

        if let imageView = imageView {
            imageView.contentMode = contentMode

            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }

        if let titleLabel = titleLabel {
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        }

        if let subtitleLabel = subtitleLabel {
            addSubview(subtitleLabel)
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: subtitleLabel, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1.0, constant: -4).isActive = true
            NSLayoutConstraint(item: subtitleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: subtitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        }

        if let actionButton = actionButton {
            addSubview(actionButton)
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: actionButton, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 4).isActive = true
            NSLayoutConstraint(item: actionButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
            actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        }
    }

    init(frame: CGRect, photo: PXLPhoto, title: String? = nil, subtitle: String? = nil, buttonTitle: String? = nil, buttonImage: UIImage? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonImage = buttonImage
        self.photo = photo
        super.init(frame: frame)

        prepareViews()
    }

    @objc func actionTapped() {
        guard let photo = photo else { return }
        delegate?.onPhotoActionClicked(photo: photo)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareViews()
    }
}
