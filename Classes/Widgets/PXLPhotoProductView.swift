//
//  PXLPhotoProductView.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import AVKit
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
            imageView.contentMode = cropMode.asImageContentMode
            playerLayer?.videoGravity = cropMode.asVideoContentMode
        }
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

    @IBOutlet var backButton: UIButton!

    @IBAction func backButtonPressed(_ sender: Any) {
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
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var productCollectionView: UICollectionView!

    @IBOutlet var durationView: UIView!
    var playerLooper: NSObject?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var durationLabelUpdateTimer: Timer?
    @IBOutlet var durationLabel: UILabel!

    public var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else { return }
            _ = view

            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: imageView)
                Nuke.loadImage(with: imageUrl, into: backgroundImageView)
            }

            durationLabel.text = nil

            if viewModel.isVideo, let videoURL = viewModel.videoUrl() {
                imageView.isHidden = true
                durationView.isHidden = false
                playVideo(url: videoURL)
            } else {
                durationLabelUpdateTimer?.invalidate()
                imageView.isHidden = false
                durationView.isHidden = true
                queuePlayer?.pause()
                if let playerLayer = self.playerLayer {
                    playerLayer.removeFromSuperlayer()
                }
            }

            bookmarks = delegate?.onProductsLoaded(products: viewModel.products ?? [])
        }
    }

    var bookmarks: [Int: Bool]?

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        durationView.layer.cornerRadius = 10
        durationView.isHidden = true
        if #available(iOS 11.0, *) {
            durationView.layer.maskedCorners = [.layerMinXMaxYCorner]
        } else {
        }

        if let viewModel = viewModel {
            bookmarks = delegate?.onProductsLoaded(products: viewModel.products ?? [])
        }
    }

    func playVideo(url: URL) {
        let playerItem = AVPlayerItem(url: url as URL)
        queuePlayer = AVQueuePlayer(items: [playerItem])

        if let queuePlayer = self.queuePlayer {
            playerLayer = AVPlayerLayer(player: queuePlayer)

            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            view.layer.addSublayer(playerLayer!)
            playerLayer?.frame = imageView.frame

            playerLayer?.videoGravity = cropMode.asVideoContentMode
            queuePlayer.play()

            view.bringSubviewToFront(durationView)
            view.bringSubviewToFront(productCollectionView)

            durationLabelUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                let totalTime: Double = self.queuePlayer?.currentItem?.duration.seconds ?? 0
                let currentTime: Double = self.queuePlayer?.currentItem?.currentTime().seconds ?? 0
                if totalTime > 0 {
                    let remainingTime: Double = totalTime - currentTime

                    let formattedTime = self.getHoursMinutesSecondsFrom(seconds: remainingTime)
                    self.durationLabel.text = String(format: "%02d:%02d", formattedTime.minutes, formattedTime.seconds)
                }
            }
        }
    }

    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: UInt64, minutes: UInt64, seconds: UInt64) {
        guard !(seconds.isNaN || seconds.isInfinite) else {
            return (0, 0, 0)
        }

        let secs = UInt64(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = imageView.frame
    }

    override public func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        queuePlayer?.pause()
        durationLabelUpdateTimer?.invalidate()
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
    }
    
    public func mutePlayer(muted: Bool) {
        queuePlayer?.isMuted = muted
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
