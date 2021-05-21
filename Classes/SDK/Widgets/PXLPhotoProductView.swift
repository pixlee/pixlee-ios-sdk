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
    public let discountPrice: DiscountPrice?
    public let showHotspots: Bool

    public init(bookmarkOnImage: UIImage? = UIImage(named: "bookmarkOn", in: Bundle(for: PXLPhotoProductView.self), compatibleWith: nil),
                bookmarkOffImage: UIImage? = UIImage(named: "bookmarkOff", in: Bundle(for: PXLPhotoProductView.self), compatibleWith: nil),
                shopImage: UIImage? = UIImage(named: "shoppingBag", in: Bundle(for: PXLPhotoProductView.self), compatibleWith: nil),
                shopBackgroundColor: UIColor = UIColor.systemYellow,
                shopBackgroundHidden: Bool = false,
                discountPrice: DiscountPrice? = nil,
                showHotspots: Bool = true) {
        self.bookmarkOnImage = bookmarkOnImage
        self.bookmarkOffImage = bookmarkOffImage
        self.shopImage = shopImage
        self.shopBackgroundColor = shopBackgroundColor
        self.shopBackgroundHidden = shopBackgroundHidden
        self.discountPrice = discountPrice
        self.showHotspots = showHotspots
    }
}

public struct DiscountPrice {
    public let discountLayout: DiscountLayout
    public let isCurrencyLeading: Bool

    public init(discountLayout: DiscountLayout, isCurrencyLeading: Bool) {
        self.discountLayout = discountLayout
        self.isCurrencyLeading = isCurrencyLeading
    }
}

/**
     * Only show the sales price if its acceptable in case:
     *  - its a time based sale
     *  - the sales price is less than the standard price
     *  - theres actually a sales price > 0
     *  - we're also showing the price as well
     */
public enum DiscountLayout: String {
    case CROSS_THROUGH // screenshot: https://xd.adobe.com/view/af65a724-66c0-4d78-bf8c-7e860a2b7595-fa36/screen/c5fad7cd-a861-415f-8916-cabf8b50f32b/
    case WAS_OLD_PRICE // screenshot: https://xd.adobe.com/view/af65a724-66c0-4d78-bf8c-7e860a2b7595-fa36/screen/21486793-b111-47ab-8029-038ee1544818/
    case WITH_DISCOUNT_LABEL // screenshot: https://xd.adobe.com/view/af65a724-66c0-4d78-bf8c-7e860a2b7595-fa36/screen/ec1004e6-d7ad-4d7a-92e2-4fcbb26877eb/
}

public protocol PXLPhotoProductDelegate: class {
    func onProductsLoaded(products: [PXLProduct]) -> [Int: Bool]
    func onBookmarkClicked(product: PXLProduct, isSelected: Bool)
    func onProductClicked(product: PXLProduct)
    func shouldOpenURL(url: URL) -> Bool
}

public class PXLPhotoProductView: UIViewController {
    public static func widgetForPhoto(photo: PXLPhoto, cropMode: PXLPhotoCropMode, delegate: PXLPhotoProductDelegate?, cellConfiguration: PXLProductCellConfiguration? = PXLProductCellConfiguration()) -> PXLPhotoProductView {
        let bundle = Bundle(for: PXLPhotoProductView.self)
        let widget = PXLPhotoProductView(nibName: "PXLPhotoProductView", bundle: bundle)
        widget.cellConfiguration = cellConfiguration ?? PXLProductCellConfiguration()
        widget.delegate = delegate
        widget.cropMode = cropMode
        widget.viewModel = photo

        return widget
    }

    private var cropMode: PXLPhotoCropMode = .centerFill

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

    public weak var delegate: PXLPhotoProductDelegate? {
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
        guard let queuePlayer = queuePlayer else {
            return
        }
        let image = queuePlayer.isMuted ? muteButtonOnImage : muteButtonOffImage
        muteButton.setImage(image, for: .normal)
    }

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


    @IBOutlet weak var hotspotView: UIView!

    @IBOutlet var backgroundImageView: UIImageView!
    var gifView = Gifu.GIFImageView()

    @IBOutlet var productCollectionView: UICollectionView!

    var playerLooper: NSObject?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?

    public var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            _ = view

            setupConfiguration()
            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: gifView)
            } else {
                gifView.image = nil
            }

            if let imageUrl = viewModel.photoUrl(for: .thumbnail) {
                Nuke.loadImage(with: imageUrl, into: backgroundImageView)
            } else {
                backgroundImageView.image = nil
            }

            gifView.alpha = 1

            gifView.contentMode = cropMode.asImageContentMode
            playerLayer?.videoGravity = cropMode.asVideoContentMode

            if viewModel.isVideo, let videoURL = viewModel.videoUrl() {
                muteButton.isHidden = false
                playVideo(url: videoURL)
            } else {
                muteButton.isHidden = true
                queuePlayer?.pause()
                if let playerLayer = self.playerLayer {
                    playerLayer.removeFromSuperlayer()
                }
            }

            if cellConfiguration.showHotspots && !viewModel.isVideo {
                if let imageURL: URL = viewModel.photoUrl(for: .original) {
                    let fetcher = ImageSizeFetcher()
                    fetcher.sizeFor(atURL: imageURL) { (err, result) in
                        if let result = result {
                            DispatchQueue.main.sync {
                                let image = UIImage(named: "outline_local_offer_black_24pt", in: PXLPhotoProductView.ownBundle, compatibleWith: nil)
                                if let paddingImage = image?.addPadding(insets: UIEdgeInsets.init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)) {
                                    // declare x y position converter
                                    let reader = HotspotsReader(imageScaleType: self.cropMode,
                                            screenWidth: self.backgroundImageView.frame.width,
                                            screenHeight: self.backgroundImageView.frame.height,
                                            contentWidth: result.size.width,
                                            contentHeight: result.size.height)

                                    // add a click event listener if there isn't one
                                    if self.hotspotView.gestureRecognizers?.isEmpty ?? true {
                                        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnHotspotBox(_:)))
                                        self.hotspotView.addGestureRecognizer(tap)
                                    }

                                    // remove previously added child views
                                    self.hotspotView.subviews.forEach { view in
                                        view.removeFromSuperview()
                                    }

                                    // make a map for quick searching for products index in the UI
                                    var productMap = [Int: Int]() // productId: the index of the products array
                                    if let products = viewModel.products {
                                        for (index, product) in products.enumerated() {
                                            debugPrint("index: \(index)")
                                            productMap[product.identifier] = index
                                        }
                                    }

                                    // draw all hotspots
                                    viewModel.boundingBoxProducts?.forEach { boundingBoxProduct in
                                        // draw hotspots available in the region
                                        if let index = productMap[boundingBoxProduct.productID] {
                                            let position = reader.getHotspotsPosition(pxlBoundingBoxProduct: boundingBoxProduct)
                                            let imageView = UIImageView(image: paddingImage)
                                            imageView.frame = CGRect.init(x: CGFloat(position.x) - (imageView.frame.width / 2),
                                                    y: CGFloat(position.y) - (imageView.frame.height / 2),
                                                    width: imageView.frame.width,
                                                    height: imageView.frame.height)
                                            imageView.layer.cornerRadius = 22
                                            imageView.backgroundColor = .white
                                            imageView.tintColor = .black
                                            imageView.layer.shadowColor = UIColor.black.cgColor
                                            imageView.layer.shadowOpacity = 0.7
                                            imageView.layer.shadowOffset = .zero
                                            imageView.layer.shadowRadius = 5
                                            imageView.isHidden = true
                                            imageView.alpha = 0.0

                                            // assign the product's index to view.tag for searching
                                            imageView.tag = index
                                            imageView.isUserInteractionEnabled = true
                                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onHotspotClicked(_:)))
                                            imageView.addGestureRecognizer(tap)

                                            // add this view to the parent view
                                            self.hotspotView.addSubview(imageView)
                                        }


                                    }
                                    self.isHotspotVisible = false
                                    self.toggleHotspots()
                                }
                            }
                        }
                    }
                }
            }

            view.bringSubviewToFront(hotspotView)
            view.bringSubviewToFront(productCollectionView)
            view.bringSubviewToFront(backButton)
            view.bringSubviewToFront(muteButton)

            bookmarks = delegate?.onProductsLoaded(products: viewModel.products ?? [])

            fireAnalyticsOpenLightbox()
        }
    }

    // the click event listener of a hotspot
    @objc func onHotspotClicked(_ sender: UITapGestureRecognizer? = nil) {
        productCollectionView.scrollToItem(
                at: IndexPath(item: sender?.view?.tag ?? 0, section: 0),
                at: .centeredHorizontally,
                animated: true
        )
    }

    var isHotspotVisible = false

    // the click event listener of the background of hotspots
    @objc func handleTapOnHotspotBox(_ sender: UITapGestureRecognizer? = nil) {
        toggleHotspots()
    }

    // show or hide all hotspots with animation
    func toggleHotspots() {
        isHotspotVisible = !isHotspotVisible
        let alphaTo: CGFloat
        let isHiddenTo: Bool
        if isHotspotVisible {
            alphaTo = 1.0
            isHiddenTo = false
        } else {
            alphaTo = 0.0
            isHiddenTo = true
        }

        hotspotView.subviews.forEach { view in
            if isHotspotVisible {
                view.isHidden = false
            }
            UIView.animate(withDuration: 0.7, animations: {
                view.alpha = alphaTo
            }, completion: { b in
                view.isHidden = isHiddenTo
            })
        }
    }

    var bookmarks: [Int: Bool]?

    private let category = AVAudioSession.sharedInstance().category

    override public func viewDidLoad() {
        super.viewDidLoad()

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
        }

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
        fireAnalyticsOpenLightbox()
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

            view.bringSubviewToFront(hotspotView)
            view.bringSubviewToFront(productCollectionView)
            view.bringSubviewToFront(backButton)
            view.bringSubviewToFront(muteButton)
        }
    }

    var observeKey = "timeControlStatus"
    var isObserving = false

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let queuePlayer = queuePlayer else {
            return
        }
        if keyPath == observeKey {
            if queuePlayer.timeControlStatus == .playing {
                self.gifView.alpha = 0
            } else {
                self.gifView.alpha = 1
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
        playVideo()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopVideo()
        do {
            try AVAudioSession.sharedInstance().setCategory(category)
        } catch {
        }
    }

    override public func didReceiveMemoryWarning() {
        destroyPlayer()
        do {
            try AVAudioSession.sharedInstance().setCategory(category)
        } catch {
        }
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

    public func destroyPlayer() {
        if (queuePlayer != nil) {
            queuePlayer?.pause()
            queuePlayer?.removeAllItems()
            if isObserving {
                queuePlayer?.removeObserver(self, forKeyPath: observeKey)
                isObserving = false
            }
            playerLayer?.removeFromSuperlayer()
            queuePlayer = nil
        }
    }

    public func mutePlayer(muted: Bool) {
        queuePlayer?.isMuted = muted
        adjustMuteImages()
    }

    private var isAnalyticsOpenLightboxFired = false

    private func fireAnalyticsOpenLightbox() {
        if !PXLClient.sharedClient.autoAnalyticsEnabled {
            return
        }

        if (!isAnalyticsOpenLightboxFired) {
            guard let photo = viewModel else {
                print("can't fire OpenLightbox analytics event because photo:PXLPhoto is null")
                return
            }

            if isVisible(view) {
                isAnalyticsOpenLightboxFired = true
                _ = photo.triggerEventOpenedLightbox() { error in
                    guard error == nil else {
                        self.isAnalyticsOpenLightboxFired = false
                        print("🛑 There was an error \(error?.localizedDescription ?? "")")
                        return
                    }
                    print("Opened lightbox fired")
                }
            }
        }
    }

    func isVisible(_ view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else {
                return true
            }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }

        return isVisible(view: view, inView: view.superview)
    }

}

extension PXLPhotoProductView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.products?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLAdvancedProductCell.defaultIdentifier, for: indexPath) as! PXLAdvancedProductCell

        cell.configuration = cellConfiguration
        cell.onBookmarkClicked = { [weak self] product, isSelected in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.onBookmarkClicked(product: product, isSelected: isSelected)
        }
        let product = viewModel?.products?[indexPath.row]
        cell.pxlProduct = product
        if let bookmarks = bookmarks, let product = product {
            cell.isBookmarked = bookmarks[product.identifier] ?? false
        }
        cell.actionButtonPressed = { [weak self] product in
            guard let strongSelf = self else {
                return
            }
            strongSelf.handleProductPressed(product: product)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = viewModel?.products?[indexPath.item] {
            handleProductPressed(product: product)
        }
    }
}
