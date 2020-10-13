//
//  PXLPhotoView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import AVFoundation
import Nuke
import UIKit

public struct PXLPhotoViewConfiguration {
    public init(textColor: UIColor? = UIColor.white,
                titleFont: UIFont? = UIFont.systemFont(ofSize: 16, weight: .bold),
                subtitleFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .bold),
                buttonFont: UIFont? = UIFont.systemFont(ofSize: 24, weight: .bold),
                buttonImage: UIImage? = nil,
                buttonBorderWidth: CGFloat = 1.0,
                delegate: PXLPhotoViewDelegate? = nil,
                cropMode: PXLPhotoCropMode? = .centerFill) {
        self.textColor = textColor
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.buttonFont = buttonFont
        self.buttonImage = buttonImage
        self.buttonBorderWidth = buttonBorderWidth
        self.delegate = delegate
        self.cropMode = cropMode
    }

    public let textColor: UIColor?
    public let titleFont: UIFont?
    public let subtitleFont: UIFont?
    public let buttonFont: UIFont?
    public let buttonImage: UIImage?
    public let buttonBorderWidth: CGFloat
    public let delegate: PXLPhotoViewDelegate?
    public let cropMode: PXLPhotoCropMode?
}

public protocol PXLPhotoViewDelegate {
    func onPhotoButtonClicked(photo: PXLPhoto)
    func onPhotoClicked(photo: PXLPhoto)
}

public class PXLPhotoView: UIView {
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var actionButton: UIButton?

    var playerLooper: NSObject?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?

    public var configuration: PXLPhotoViewConfiguration? = PXLPhotoViewConfiguration() {
        didSet {
            if let textColor = configuration?.textColor {
                self.textColor = textColor
            }
            if let titleFont = configuration?.titleFont {
                self.titleFont = titleFont
            }
            if let subtitleFont = configuration?.subtitleFont {
                self.subtitleFont = subtitleFont
            }
            if let buttonFont = configuration?.buttonFont {
                actionButton?.titleLabel?.font = buttonFont
            }
            if let buttonImage = configuration?.buttonImage {
                actionButton?.setImage(buttonImage, for: .normal)
            }
            if let borderWidth = configuration?.buttonBorderWidth {
                actionButton?.layer.borderWidth = borderWidth
            }

            delegate = configuration?.delegate

            if let cropMode = configuration?.cropMode {
                self.cropMode = cropMode
            }
        }
    }

    public var enableVideos: Bool = true
    public var photo: PXLPhoto? {
        didSet {
            guard let photo = photo else { return }
            if let imageUrl = photo.photoUrl(for: .medium), let imageView = imageView {
                Nuke.loadImage(with: imageUrl, into: imageView)
            }

            if enableVideos, photo.isVideo, let videoURL = photo.videoUrl() {
                imageView?.isHidden = true
                playVideo(url: videoURL)
            } else {
                imageView?.isHidden = false
                queuePlayer?.pause()
                if let playerLayer = self.playerLayer {
                    playerLayer.removeFromSuperlayer()
                }
            }
        }
    }

    func playVideo(url: URL) {
        let playerItem = AVPlayerItem(url: url as URL)
        queuePlayer = AVQueuePlayer(items: [playerItem])

        if let queuePlayer = self.queuePlayer {
            playerLayer = AVPlayerLayer(player: queuePlayer)
            queuePlayer.isMuted = true

            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            layer.insertSublayer(playerLayer!, above: imageView?.layer)
            if let imageFrame = imageView?.frame {
                playerLayer?.frame = imageFrame
            }
            playerLayer?.videoGravity = .resizeAspectFill
            queuePlayer.play()
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

    public var buttonTitle: String? {
        didSet {
            actionButton?.setTitle(buttonTitle, for: .normal)
        }
    }

    var cropMode: PXLPhotoCropMode {
        didSet {
            imageView?.contentMode = cropMode.asImageContentMode
        }
    }

    var textColor: UIColor = UIColor.white {
        didSet {
            titleLabel?.textColor = textColor
            subtitleLabel?.textColor = textColor
            actionButton?.tintColor = textColor
            actionButton?.layer.borderColor = textColor.cgColor
        }
    }

    var titleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold) {
        didSet {
            titleLabel?.font = titleFont
        }
    }

    var subtitleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular) {
        didSet {
            subtitleLabel?.font = subtitleFont
        }
    }

    var buttonBorderWidth: CGFloat = 1 {
        didSet {
            actionButton?.layer.borderWidth = buttonBorderWidth
        }
    }

    var buttonImage: UIImage? {
        didSet {
            actionButton?.setImage(buttonImage, for: .normal)
        }
    }

    public func stopPlaying() {
        queuePlayer?.pause()
    }

    public func continuePlaying() {
        queuePlayer?.play()
    }

    public func mutePlayer(muted: Bool) {
        queuePlayer?.isMuted = muted
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let imageFrame = imageView?.frame {
            playerLayer?.frame = imageFrame
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

        gestureRecognizers?.forEach({ gestureRec in
            self.removeGestureRecognizer(gestureRec)
        })
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        addGestureRecognizer(tapRecognizer)

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
        cropMode = .centerFill
        super.init(frame: frame)

        prepareViews()
    }

    @objc func imageTapped() {
        guard let photo = photo else { return }
        delegate?.onPhotoClicked(photo: photo)
    }

    @objc func actionTapped() {
        guard let photo = photo else { return }
        delegate?.onPhotoButtonClicked(photo: photo)
    }

    required init?(coder: NSCoder) {
        cropMode = .centerFill
        super.init(coder: coder)
        prepareViews()
    }
}
