//
//  ImageDetailsViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import AVKit
import Nuke
import UIKit

public class PXLPhotoDetailViewController: UIViewController {
    public static func viewControllerForPhoto(photo: PXLPhoto) -> PXLPhotoDetailViewController {
        let bundle = Bundle(for: PXLPhotoDetailViewController.self)
        let imageDetailsVC = PXLPhotoDetailViewController(nibName: "PXLPhotoDetailViewController", bundle: bundle)
        imageDetailsVC.viewModel = photo
        return imageDetailsVC
    }

    @IBOutlet var backButton: UIButton!

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

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
            titleLabel.text = (viewModel.title != nil) ? viewModel.title : ""

            self.durationLabel.text = nil

            if viewModel.isVideo, let videoURL = viewModel.videoUrl() {
                self.imageView.isHidden = true
                durationView.isHidden = false
                self.playVideo(url: videoURL)
            } else {
                durationLabelUpdateTimer?.invalidate()
                self.imageView.isHidden = false
                durationView.isHidden = true
                queuePlayer?.pause()
                if let playerLayer = self.playerLayer {
                    playerLayer.removeFromSuperlayer()
                }
            }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        durationView.layer.cornerRadius = 10
        durationView.isHidden = true
        if #available(iOS 11.0, *) {
            durationView.layer.maskedCorners = [.layerMinXMaxYCorner]
        } else {
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
            playerLayer?.videoGravity = .resizeAspectFill
            queuePlayer.play()

            view.bringSubviewToFront(durationView)

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

    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
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
            UIApplication.shared.open(productURL, options: [:], completionHandler: nil)
        }
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
