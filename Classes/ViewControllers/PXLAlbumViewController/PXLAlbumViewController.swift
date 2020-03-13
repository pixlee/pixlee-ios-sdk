//
//  PXLAlbumViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 15..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit
enum PXLAlbumViewControllerDisplayDisplayMode {
    case grid
    case list
}

public class PXLAlbumViewController: UIViewController {
    public static func viewControllerForAlbum(album: PXLAlbum) -> PXLAlbumViewController {
        let bundle = Bundle(for: PXLAlbumViewController.self)
        let albumVC = PXLAlbumViewController(nibName: "PXLAlbumViewController", bundle: bundle)
        albumVC.viewModel = PXLAlbumViewModel(album: album)
        return albumVC
    }

    let defaultMargin: CGFloat = 15

    @IBOutlet var loadingIndicatorWidth: NSLayoutConstraint!
    @IBOutlet var loadingIndicator: UIView!
    @IBOutlet var addPhotoButton: UIButton!
    @IBOutlet var layoutSwitcher: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!

    let gridLayout = UICollectionViewFlowLayout()
    let listLayout = UICollectionViewFlowLayout()

    var layoutToUse: UICollectionViewLayout {
        albumDisplayMode == .grid ? gridLayout : listLayout
    }

    var albumDisplayMode = PXLAlbumViewControllerDisplayDisplayMode.list {
        didSet {
            collectionView.setCollectionViewLayout(layoutToUse, animated: true)
        }
    }

    @IBAction func addPhotoTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "What source do you want to use?", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }))

        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .savedPhotosAlbum
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))

        present(alertController, animated: true)
    }

    @IBAction func layoutSwitchChanged(_ sender: Any) {
        albumDisplayMode = layoutSwitcher.selectedSegmentIndex == 0 ? .list : .grid
    }

    public var viewModel: PXLAlbumViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            _ = view
            _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: viewModel.album) { _, error in
                guard error == nil else {
                    print("There was an error during the loading \(String(describing: error))")
                    return
                }
                self.collectionView.reloadData()

                _ = viewModel.album.triggerEventOpenedWidget(widget: .horizontal) { _ in
                    print("Logged")
                }
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        loadingIndicator.layer.cornerRadius = 2
        loadingIndicator.isHidden = true
    }

    func setupCollectionView() {
        let viewWidth = UIScreen.main.bounds.width
        let cellWidth = Int((viewWidth - (3 * defaultMargin)) / 2)

        gridLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        gridLayout.sectionInset = UIEdgeInsets(top: defaultMargin,
                                               left: defaultMargin,
                                               bottom: defaultMargin,
                                               right: defaultMargin)

        listLayout.itemSize = CGSize(width: viewWidth, height: viewWidth)

        collectionView.setCollectionViewLayout(layoutToUse, animated: false)

        let bundle = Bundle(for: PXLImageCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PXLImageCell", bundle: bundle), forCellWithReuseIdentifier: PXLImageCell.defaultIdentifier)
    }

    func applyUploadPercentage(_ percentage: Double) {
        loadingIndicator.isHidden = percentage < 0.05
        loadingIndicatorWidth.constant = CGFloat(percentage * 72)
        view.layoutIfNeeded()
        if percentage >= 0.99 {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.loadingIndicator.isHidden = true
                }
            }
        }
    }
}

extension PXLAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.album.photos.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLImageCell.defaultIdentifier, for: indexPath) as! PXLImageCell

        cell.viewModel = viewModel?.album.photos[indexPath.row]

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photo = viewModel?.album.photos[indexPath.row] {
            let photoDetailVC = PXLPhotoDetailViewController.viewControllerForPhoto(photo: photo)
            let navController = UINavigationController(rootViewController: photoDetailVC)
            present(navController, animated: true, completion: nil)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let offset = scrollView.contentOffset.y + scrollView.frame.height
            if offset > scrollView.contentSize.height * 0.7 {
                if let viewModel = viewModel {
                    _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: viewModel.album) { photos, error in
                        guard error == nil else {
                            print("Error while loading images:\(String(describing: error))")
                            return
                        }
                        guard let photos = photos else { return }

                        var indexPaths = [IndexPath]()
                        let firstIndex = viewModel.photos.firstIndex { (photo) -> Bool in
                            if let newPhoto = photos.first {
                                return photo.id == newPhoto.id
                            }
                            return false
                        } ?? 0

                        for (index, _) in photos.enumerated() {
                            let itemNumber = firstIndex + index
                            indexPaths.append(IndexPath(item: itemNumber, section: 0))
                        }

                        self.collectionView.insertItems(at: indexPaths)
                    }
                }
            }
        }
    }
}

extension PXLAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        if let albumIdentifier = viewModel?.album.identifier, let albumID = Int(albumIdentifier) {
            PXLClient.sharedClient.uploadPhoto(photo:
                PXLNewImage(image: image, albumId: albumID, title: "Sample image name", email: "csaba@bitraptors.com", username: "csacsi", approved: true, connectedUserId: nil, productSKUs: nil, connectedUser: nil),
                progress: { percentage in
                    self.applyUploadPercentage(percentage)
                },
                uploadRequest: { uploadReqest in

                    let doYouWantToCancelTheRequest = false
                    if doYouWantToCancelTheRequest {
                        uploadReqest?.cancel()
                    }
                },
                completion: { photoId, userId, error in
                    guard error == nil else {
                        print("🛑 Error while uploading image :\(error?.localizedDescription)")
                        return
                    }

                    guard let photoId = photoId, let userId = userId else {
                        print("🛑 Don't have photo or userid")
                        return
                    }
                    print("⭐️ Upload completed: photoID:\(photoId), userId:\(userId)")
                }
            )
        }
    }
}
