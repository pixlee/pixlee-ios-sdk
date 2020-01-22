//
//  PXLAlbumViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 15..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit
import pixlee_api
enum PXLAlbumViewControllerDisplayDisplayMode {
    case grid
    case list
}

class PXLAlbumViewController: UIViewController {
    let defaultMargin: CGFloat = 15

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

    @IBAction func layoutSwitchChanged(_ sender: Any) {
        albumDisplayMode = layoutSwitcher.selectedSegmentIndex == 0 ? .list : .grid
    }

    var viewModel: PXLAlbumViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            _ = view
            _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: viewModel.album) { _, error in
                guard error == nil else {
                    print("There was an error during the loading \(String(describing: error))")
                    return
                }
                self.collectionView.reloadData()
            }

            viewModel.openedWidget("my new widget")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
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

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PXLImageCell", bundle: nil), forCellWithReuseIdentifier: PXLImageCell.defaultIdentifier)
    }
}

extension PXLAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.album.photos.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLImageCell.defaultIdentifier, for: indexPath) as! PXLImageCell

        cell.viewModel = viewModel?.album.photos[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageDetailsVC = ImageDetailsViewController(nibName: "ImageDetailsViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: imageDetailsVC)

        imageDetailsVC.viewModel = viewModel?.album.photos[indexPath.row]

        present(navController, animated: true) {
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let offset = scrollView.contentOffset.y + scrollView.frame.height
            if offset > scrollView.contentSize.height * 0.7 {
                if let viewModel = viewModel {
                    viewModel.loadMore()
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
