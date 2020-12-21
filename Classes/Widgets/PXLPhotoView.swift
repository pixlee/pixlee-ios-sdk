//
//  PXLPhotoView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import AVFoundation
import Gifu
import Nuke
import UIKit

public struct PXLPhotoViewConfiguration {
    public init(textColor: UIColor? = UIColor.white,
                titleFont: UIFont? = UIFont.systemFont(ofSize: 16, weight: .bold),
                subtitleFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .bold),
                buttonFont: UIFont? = UIFont.systemFont(ofSize: 24, weight: .bold),
                buttonImage: UIImage? = nil,
                buttonBorderWidth: CGFloat = 1.0,
                enableVideoPlayback: Bool = true,
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
        self.enableVideoPlayback = enableVideoPlayback
    }

    public let textColor: UIColor?
    public let titleFont: UIFont?
    public let subtitleFont: UIFont?
    public let buttonFont: UIFont?
    public let buttonImage: UIImage?
    public let buttonBorderWidth: CGFloat
    public let delegate: PXLPhotoViewDelegate?
    public let cropMode: PXLPhotoCropMode?
    public let enableVideoPlayback: Bool

    public func changeEnableVideoPlayback(_ newEnableVideos: Bool) -> PXLPhotoViewConfiguration {
        return PXLPhotoViewConfiguration(textColor: textColor,
                                         titleFont: titleFont,
                                         subtitleFont: subtitleFont,
                                         buttonFont: buttonFont,
                                         buttonImage: buttonImage,
                                         buttonBorderWidth: buttonBorderWidth,
                                         enableVideoPlayback: newEnableVideos,
                                         delegate: delegate,
                                         cropMode: cropMode)
    }
}

public protocol PXLPhotoViewDelegate:class {
    func onPhotoButtonClicked(photo: PXLPhoto)
    func onPhotoClicked(photo: PXLPhoto)
}

public class PXLPhotoView: UIView {
    var backgroundImageView: UIImageView!
    var gifView = Gifu.GIFImageView()
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var actionButton: UIButton?

    var playerLooper: NSObject?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?

    public var configuration: PXLPhotoViewConfiguration = PXLPhotoViewConfiguration() {
        didSet {
            if let textColor = configuration.textColor {
                self.textColor = textColor
            }
            if let titleFont = configuration.titleFont {
                self.titleFont = titleFont
            }
            if let subtitleFont = configuration.subtitleFont {
                self.subtitleFont = subtitleFont
            }
            if let buttonFont = configuration.buttonFont {
                actionButton?.titleLabel?.font = buttonFont
            }
            if let buttonImage = configuration.buttonImage {
                actionButton?.setImage(buttonImage, for: .normal)
            }

            actionButton?.layer.borderWidth = configuration.buttonBorderWidth

            delegate = configuration.delegate

            if let cropMode = configuration.cropMode {
                self.cropMode = cropMode
            }
            initPhoto()
        }
    }

    public var photo: PXLPhoto? {
        didSet {
            initPhoto()
        }
    }

    func initPhoto() {
        resetPlayer()
        guard let photo = photo else { return }

        gifView.alpha = 1
        
        loadMainImage()
        loadBackgroundImage()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    private func loadMainImage(){
        if let photo = photo, let imageUrl = photo.photoUrl(for: .medium) {
            Nuke.loadImage(with: imageUrl, into: gifView)
        } else {
            gifView.image = nil
        }
    }

    private func loadBackgroundImage(){
        if let photo = photo, let thumbnail = photo.photoUrl(for: .thumbnail) {
            Nuke.loadImage(with: thumbnail, into: backgroundImageView)
        } else {
            backgroundImageView.image = nil
        }
    }

    var observeKey = "timeControlStatus"
    var isObserving = false

    func playVideo(url: URL, muted:Bool = false) {
        print("playVideo==")
        stopVideo()
        let playerItem = AVPlayerItem(url: url as URL)
        queuePlayer = AVQueuePlayer(items: [playerItem])

        if let queuePlayer = self.queuePlayer {
            playerLayer?.removeFromSuperlayer()
            playerLayer = AVPlayerLayer(player: queuePlayer)
            queuePlayer.isMuted = muted

            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            layer.insertSublayer(playerLayer!, above: gifView.layer)

            playerLayer?.frame = gifView.frame

            playerLayer?.videoGravity = cropMode.asVideoContentMode
            queuePlayer.addObserver(self, forKeyPath: observeKey, options: NSKeyValueObservingOptions.new, context: nil)
            isObserving = true
            queuePlayer.play()
        }
    }

    override public func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            stopVideo()
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            stopVideo()
        }
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let queuePlayer = queuePlayer else { return }
        print("queuePlayer.timeControlStatus: \(queuePlayer.timeControlStatus.rawValue)")
        if keyPath == observeKey {
            
            if queuePlayer.timeControlStatus == .playing {
                self.gifView.alpha = 0
            }else{                
                self.gifView.alpha = 1
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

    public var buttonTitle: String? {
        didSet {
            actionButton?.setTitle(buttonTitle, for: .normal)
        }
    }

    var cropMode: PXLPhotoCropMode {
        didSet {
            gifView.contentMode = cropMode.asImageContentMode
            playerLayer?.videoGravity = cropMode.asVideoContentMode
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

    public func stopVideo() {
        print("stopVideo()")
        queuePlayer?.pause()
        queuePlayer?.cancelPendingPrerolls()
        if isObserving {
            queuePlayer?.removeObserver(self, forKeyPath: observeKey)
            isObserving = false
        }
    }

    public func resetPlayer() {
        if(queuePlayer != nil){
            queuePlayer?.pause()
            queuePlayer?.removeAllItems()
            if isObserving {
                queuePlayer?.removeObserver(self, forKeyPath: observeKey)
                isObserving = false
            }
            playerLayer?.removeFromSuperlayer()
            queuePlayer = nil
            
            self.gifView.alpha = 1
        }
    }

    public func playVideo(muted: Bool) {
        if(queuePlayer==nil){
            if let photo = photo {
                if configuration.enableVideoPlayback, photo.isVideo, let videoURL = photo.videoUrl() {
                    playVideo(url: videoURL, muted: muted)
                } else {
                    if let playerLayer = self.playerLayer {
                        playerLayer.removeFromSuperlayer()
                    }
                }
            }
        }else{
            queuePlayer?.play()
        }
    }

    public func mutePlayer(_ muted: Bool) {
        queuePlayer?.isMuted = muted
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        playerLayer?.frame = gifView.frame
    }

    public weak var delegate: PXLPhotoViewDelegate?
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    func prepareViews() {
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        gifView.frame = bounds

        titleLabel = UILabel()
        titleLabel?.font = titleFont
        titleLabel?.text = title
        titleLabel?.numberOfLines = 0
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

        addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        let bgConstraints = [
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(bgConstraints)

        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        let blurConstraints = [
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(blurConstraints)

        addSubview(gifView)
        gifView.translatesAutoresizingMaskIntoConstraints = false
        let gifConstraints = [
            gifView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gifView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gifView.topAnchor.constraint(equalTo: topAnchor),
            gifView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(gifConstraints)

        if let titleLabel = titleLabel {
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 16).isActive = true
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -16).isActive = true
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
