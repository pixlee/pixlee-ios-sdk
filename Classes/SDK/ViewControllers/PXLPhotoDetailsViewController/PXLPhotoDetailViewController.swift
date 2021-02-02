//
//  ImageDetailsViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import AVKit
import Gifu
import Nuke
import SafariServices
import UIKit

public class PXLPhotoDetailViewController: UIViewController {
    public static func viewControllerForPhoto(photo: PXLPhoto, title: String?) -> PXLPhotoDetailViewController {
        let bundle = Bundle(for: PXLPhotoDetailViewController.self)
        let imageDetailsVC = PXLPhotoDetailViewController(nibName: "PXLPhotoDetailViewController", bundle: bundle)
        imageDetailsVC.viewModel = photo
        imageDetailsVC.titleString = title
        return imageDetailsVC
    }

    @IBOutlet var backButton: UIButton!

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    public func playVideo() {
        queuePlayer?.play()
    }

    public func stopVideo() {
        queuePlayer?.pause()
    }

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var imageView: UIImageView!
    var gifView = Gifu.GIFImageView()
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var productCollectionView: UICollectionView!

    var cropMode: PXLPhotoCropMode? = .centerFill {
        didSet {
            setupCropMode()
        }
    }

    func setupCropMode() {
        guard let cropMode = cropMode else { return }
        gifView.contentMode = cropMode.asImageContentMode
        playerLayer?.videoGravity = cropMode.asVideoContentMode
    }

    var playerLooper: NSObject?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?

    public var viewModel: PXLPhoto? {
        didSet {
            guard let viewModel = viewModel else { return }
            _ = view

            setupCropMode()

            gifView.alpha = 1
            if let imageUrl = viewModel.photoUrl(for: .medium) {
                Nuke.loadImage(with: imageUrl, into: gifView)
                Nuke.loadImage(with: imageUrl, into: backgroundImageView)
            }else{
                gifView.image = nil
                backgroundImageView.image = nil
            }
            titleLabel.text = nil

            if viewModel.isVideo, let videoURL = viewModel.videoUrl() {
                playVideo(url: videoURL)
            } else {
                queuePlayer?.pause()
                if let playerLayer = self.playerLayer {
                    playerLayer.removeFromSuperlayer()
                }
            }
        }
    }

    public var titleString: String? {
        didSet {
            titleLabel.text = titleString
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.insertSubview(gifView, belowSubview: backButton)
        gifView.frame = imageView.frame
        imageView.isHidden = true
        backgroundImageView.contentMode = .scaleAspectFill
    }

    var observeKey = "timeControlStatus"
    var isObserving = false

    func playVideo(url: URL) {
        let playerItem = AVPlayerItem(url: url as URL)
        queuePlayer = AVQueuePlayer(items: [playerItem])

        if let queuePlayer = self.queuePlayer {
            playerLayer = AVPlayerLayer(player: queuePlayer)

            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            view.layer.addSublayer(playerLayer!)
            playerLayer?.frame = gifView.frame
            queuePlayer.addObserver(self, forKeyPath: observeKey, options: NSKeyValueObservingOptions.new, context: nil)
            isObserving = true
            setupCropMode()
            queuePlayer.play()
        }
    }

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
        gifView.frame = imageView.frame
        playerLayer?.frame = gifView.frame
    }

    override public func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        queuePlayer?.pause()
        queuePlayer?.cancelPendingPrerolls()

        if isObserving {
            queuePlayer?.removeObserver(self, forKeyPath: observeKey)
            isObserving = false
        }
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        productCollectionView.setCollectionViewLayout(layout, animated: false)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        let bundle = Bundle(for: PXLImageCell.self)
        productCollectionView.register(UINib(nibName: "PXLProductCell", bundle: bundle), forCellWithReuseIdentifier: PXLProductCell.defaultIdentifier)

        productCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }

    @objc func doneButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    func handleProductPressed(product: PXLProduct) {
        if let url = product.link?.absoluteString.removingPercentEncoding, let productURL = URL(string: url) {
            if #available(iOS 11.0, *) {
                let vc = SFSafariViewController(url: productURL, configuration: SFSafariViewController.Configuration())
                self.present(vc, animated: true)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.open(productURL, options: [:], completionHandler: nil)
            }
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        playVideo()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        stopVideo()
    }
}

extension PXLPhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.products?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLProductCell.defaultIdentifier, for: indexPath) as! PXLProductCell

        cell.viewModel = viewModel?.products?[indexPath.row]
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

extension PXLPhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 100)
    }
}
