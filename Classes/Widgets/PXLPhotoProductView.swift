//
//  PXLPhotoProductView.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import AVKit
import Gifu
import Nuke
import UIKit

public struct PXLProductCellConfiguration {
    public let bookmarkOnImage: UIImage?
    public let bookmarkOffImage: UIImage?
    public let shopImage: UIImage?
    public let shopBackgroundColor: UIColor
    public let shopBackgroundHidden: Bool

    public init(bookmarkOnImage: UIImage? = UIImage(named: "bookmarkOn", in: Bundle(for: PXLPhotoProductView.self), compatibleWith: nil),
                bookmarkOffImage: UIImage? = UIImage(named: "bookmarkOff", in: Bundle(for: PXLPhotoProductView.self), compatibleWith: nil),
                shopImage: UIImage? = UIImage(named: "shoppingBag", in: Bundle(for: PXLPhotoProductView.self), compatibleWith: nil),
                shopBackgroundColor: UIColor = UIColor.systemYellow,
                shopBackgroundHidden: Bool = false) {
        self.bookmarkOnImage = bookmarkOnImage
        self.bookmarkOffImage = bookmarkOffImage
        self.shopImage = shopImage
        self.shopBackgroundColor = shopBackgroundColor
        self.shopBackgroundHidden = shopBackgroundHidden
    }
}

public protocol PXLPhotoProductDelegate {
    func onProductsLoaded(products: [PXLProduct]) -> [Int: Bool]
    func onBookmarkClicked(product: PXLProduct, isSelected: Bool)
    func onProductClicked(product: PXLProduct)
    func shouldOpenURL(url: URL) -> Bool
}

public class PXLPhotoProductView: UIViewController {
    public static func widgetForPhoto(photo: PXLPhoto, delegate: PXLPhotoProductDelegate?, cellConfiguration: PXLProductCellConfiguration? = PXLProductCellConfiguration()) -> PXLPhotoProductView {
        let bundle = Bundle(for: PXLPhotoProductView.self)
        let widget = PXLPhotoProductView(nibName: "PXLPhotoProductView", bundle: bundle)
        widget.delegate = delegate
        widget.viewModel = photo
        widget.cellConfiguration = cellConfiguration ?? PXLProductCellConfiguration()

        return widget
    }

    public var cropMode: PXLPhotoCropMode = .centerFill {
        didSet {
            gifView.contentMode = cropMode.asImageContentMode
            playerLayer?.videoGravity = cropMode.asVideoContentMode
        }
    }

    public var closeButtonImage: UIImage? = UIImage(named: "closeIcon", in: PXLPhotoProductView.ownBundle, compatibleWith: nil) {
        didSet {
            backButton.setImage(closeButtonImage, for: .normal)
        }
    }

    public var closeButtonBackgroundColor: UIColor = .clear {
        didSet {
            backButton.backgroundColor = closeButtonBackgroundColor
        }
    }

    public var closeButtonTintColor: UIColor = .white {
        didSet {
            backButton.tintColor = closeButtonTintColor
        }
    }

    public var closeButtonCornerRadius: CGFloat = 22 {
        didSet {
            backButton.layer.cornerRadius = closeButtonCornerRadius
        }
    }

    public var hideCloseButton: Bool = false {
        didSet {
            backButton.isHidden = hideCloseButton
        }
    }

    static var ownBundle: Bundle {
        Bundle(for: PXLPhotoProductView.self)
    }

    public var muteButtonOnImage: UIImage? = UIImage(named: "outline_volume_off_black_24pt", in: PXLPhotoProductView.ownBundle, compatibleWith: nil) {
        didSet {
            adjustMuteImages()
        }
    }

    public var muteButtonOffImage: UIImage? = UIImage(named: "outline_volume_up_black_24pt", in: PXLPhotoProductView.ownBundle, compatibleWith: nil) {
        didSet {
            adjustMuteImages()
        }
    }

    public var muteButtonBackgroundColor: UIColor = .clear {
        didSet {
            muteButton.backgroundColor = muteButtonBackgroundColor
        }
    }

    public var muteButtonTintColor: UIColor = .white {
        didSet {
            muteButton.tintColor = muteButtonTintColor
        }
    }

    public var muteButtonCornerRadius: CGFloat = 22 {
        didSet {
            muteButton.layer.cornerRadius = muteButtonCornerRadius
        }
    }

    public var hideMuteButton: Bool = false {
        didSet {
            muteButton.isHidden = hideMuteButton
        }
    }

    func setupButtons() {
        muteButton.isHidden = hideMuteButton
        muteButton.layer.cornerRadius = muteButtonCornerRadius
        muteButton.tintColor = muteButtonTintColor
        muteButton.backgroundColor = muteButtonBackgroundColor
        adjustMuteImages()

        backButton.isHidden = hideCloseButton
        backButton.layer.cornerRadius = closeButtonCornerRadius
        backButton.setImage(closeButtonImage, for: .normal)
        backButton.backgroundColor = closeButtonBackgroundColor
        backButton.tintColor = closeButtonTintColor
    }

    public var cellConfiguration = PXLProductCellConfiguration()

    public var onBookmarkClicked: ((_ product: PXLProduct, _ isSelected: Bool) -> Void)?

    public var delegate: PXLPhotoProductDelegate? {
        didSet {
            if let viewModel = viewModel {
                bookmarks = delegate?.onProductsLoaded(products: viewModel.products ?? [])
            }
        }
    }

    public func showOn(viewController: UIViewController) {
        isModal = false
        let navController = UINavigationController(rootViewController: self)
        viewController.present(navController, animated: true, completion: nil)
    }

    private var isModal: Bool = true

    private var needsAnim: Bool = true

    public func showModally(hostView: UIView, animated: Bool) {
        isModal = true
        hostView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view!, attribute: .leading, relatedBy: .equal, toItem: hostView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: hostView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: view!, attribute: .top, relatedBy: .equal, toItem: hostView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: hostView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true

        view.transform = CGAffineTransform(translationX: 0, y: hostView.frame.size.height)
        let duration = animated ? 0.3 : 0
        needsAnim = animated

        UIView.animate(withDuration: duration, animations: {
            self.view.transform = .identity
        }) { _ in
        }
    }

    public func dismiss() {
        if isModal {
            dismissModal()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    private func dismissModal() {
        let duration = needsAnim ? 0.3 : 0
        UIView.animate(withDuration: duration, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        }) { _ in
            self.view.removeFromSuperview()
        }
    }

    @IBOutlet var muteButton: UIButton!
    @IBOutlet var backButton: UIButton!

    @IBAction func muteButtonPressed(_ sender: Any) {
        print("mute pressed")
        queuePlayer?.isMuted.toggle()
        adjustMuteImages()
    }

    func setupConfiguration() {
        gifView.frame = view.bounds

        gifView.contentMode = cropMode.asImageContentMode
        playerLayer?.videoGravity = cropMode.asVideoContentMode
        setupButtons()
    }

    func adjustMuteImages() {
        guard let queuePlayer = queuePlayer else { return }
        let image = queuePlayer.isMuted ? muteButtonOnImage : muteButtonOffImage
        muteButton.setImage(image, for: .normal)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        print("back pressed")
        if isModal {
            dismissModal()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func doneButtonPressed() {
        if isModal {
            dismissModal()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBOutlet var backgroundImageView: UIImageView!
    var gifView = Gifu.GIFImageView()

    @IBOutlet var productCollectionView: UICollectionView!

    var playerLooper: NSObject?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var durationLabelUpdateTimer: Timer?

    public var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else { return }
            _ = view

            setupConfiguration()
            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: gifView)
                Nuke.loadImage(with: imageUrl, into: backgroundImageView)
            }else{
                gifView.image = nil
                backgroundImageView.image = nil
            }
            
            if let imageUrl = viewModel.photoUrl(for: .thumbnail) {
                Nuke.loadImage(with: imageUrl, into: backgroundImageView)
            }else{
                backgroundImageView.image = nil
            }

            gifView.alpha = 1

            if viewModel.isVideo, let videoURL = viewModel.videoUrl() {
                muteButton.isHidden = false
                playVideo(url: videoURL)
            } else {
                durationLabelUpdateTimer?.invalidate()
                durationLabelUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    let _: Double = self.queuePlayer?.currentItem?.duration.seconds ?? 0
                }

                muteButton.isHidden = true
                queuePlayer?.pause()
                if let playerLayer = self.playerLayer {
                    playerLayer.removeFromSuperlayer()
                }
            }

            view.bringSubviewToFront(productCollectionView)
            view.bringSubviewToFront(backButton)
            view.bringSubviewToFront(muteButton)

            bookmarks = delegate?.onProductsLoaded(products: viewModel.products ?? [])
        }
    }

    var bookmarks: [Int: Bool]?

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.clipsToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        setupCollectionView()

        view.addSubview(gifView)
        gifView.frame = view.bounds
        gifView.translatesAutoresizingMaskIntoConstraints = false
        let gifConstraints = [
            gifView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gifView.topAnchor.constraint(equalTo: view.topAnchor),
        ]

        NSLayoutConstraint.activate(gifConstraints)

        if let viewModel = viewModel {
            bookmarks = delegate?.onProductsLoaded(products: viewModel.products ?? [])
        }

        setupButtons()
    }

    func playVideo(url: URL) {
        let playerItem = AVPlayerItem(url: url as URL)
        queuePlayer = AVQueuePlayer(items: [playerItem])

        if let queuePlayer = self.queuePlayer {
            playerLayer = AVPlayerLayer(player: queuePlayer)

            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            view.layer.addSublayer(playerLayer!)

            playerLayer?.frame = gifView.frame

            playerLayer?.videoGravity = cropMode.asVideoContentMode
            queuePlayer.addObserver(self, forKeyPath: observeKey, options: NSKeyValueObservingOptions.new, context: nil)
            isObserving = true
            queuePlayer.play()
            queuePlayer.isMuted = true
            adjustMuteImages()

            view.bringSubviewToFront(productCollectionView)
            view.bringSubviewToFront(backButton)
            view.bringSubviewToFront(muteButton)
            durationLabelUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                let _: Double = self.queuePlayer?.currentItem?.duration.seconds ?? 0
            }
        }
    }

    var observeKey = "timeControlStatus"
    var isObserving = false

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let queuePlayer = queuePlayer else { return }
        if keyPath == observeKey {
            if queuePlayer.timeControlStatus == .playing {
                UIView.animate(withDuration: 0.3) {
                    self.gifView.alpha = 0
                }
            }
        }
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gifView.frame = view.bounds
        playerLayer?.frame = gifView.frame
    }

    override public func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        durationLabelUpdateTimer?.invalidate()
        stopVideo()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 350, height: 150)

        productCollectionView.setCollectionViewLayout(layout, animated: false)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        let bundle = Bundle(for: PXLAdvancedProductCell.self)
        productCollectionView.register(UINib(nibName: "PXLAdvancedProductCell", bundle: bundle), forCellWithReuseIdentifier: PXLAdvancedProductCell.defaultIdentifier)

        productCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        productCollectionView.isPagingEnabled = false
    }

    func handleProductPressed(product: PXLProduct) {
        delegate?.onProductClicked(product: product)

        if let url = product.link?.absoluteString.removingPercentEncoding, let productURL = URL(string: url), let delegate = delegate, delegate.shouldOpenURL(url: productURL) {
            UIApplication.shared.open(productURL, options: [:], completionHandler: nil)
        }
    }

    public func playVideo() {
        queuePlayer?.play()
    }

    public func stopVideo() {
        queuePlayer?.pause()
        queuePlayer?.cancelPendingPrerolls()
        if isObserving {
            queuePlayer?.removeObserver(self, forKeyPath: observeKey)
            isObserving = false
        }
    }

    public func mutePlayer(muted: Bool) {
        queuePlayer?.isMuted = muted
        adjustMuteImages()
    }
}

extension PXLPhotoProductView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.products?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLAdvancedProductCell.defaultIdentifier, for: indexPath) as! PXLAdvancedProductCell

        cell.configuration = cellConfiguration
        cell.onBookmarkClicked = { product, isSelected in
            self.delegate?.onBookmarkClicked(product: product, isSelected: isSelected)
        }
        let product = viewModel?.products?[indexPath.row]
        cell.viewModel = product
        if let bookmarks = bookmarks, let product = product {
            cell.isBookmarked = bookmarks[product.identifier] ?? false
        }
        cell.actionButtonPressed = { product in
            self.handleProductPressed(product: product)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = viewModel?.products?[indexPath.item] {
            handleProductPressed(product: product)
        }
    }
}
