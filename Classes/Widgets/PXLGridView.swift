//
//  PXLGridView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 10. 11..
//

import UIKit
public protocol PXLGridViewDelegate {
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto)
    func onPhotoClicked(photo: PXLPhoto)
    func onPhotoButtonClicked(photo: PXLPhoto)
    func cellHeight() -> CGFloat
    func cellPadding() -> CGFloat
    func isMultipleColumnEnabled() -> Bool
    func isHighlightingEnabled() -> Bool
    func isInfiniteScrollEnabled() -> Bool
}

public class PXLGridView: UIView {
    var collectionView: UICollectionView?
    let flowLayout = UICollectionViewFlowLayout()

    public var items: [PXLPhoto] = [] {
        didSet {
            infiniteItems = items
        }
    }

    private var infiniteItems: [PXLPhoto] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    public var delegate: PXLGridViewDelegate? {
        didSet {
            setupCellSize()
            if isMultipleColumnsEnabled {
                topRightCellIndex = IndexPath(item: 1, section: 0)
            } else {
                topRightCellIndex = nil
            }
        }
    }

    func setupCellSize() {
        let width = ((collectionView?.frame.size.width ?? frame.width) - cellPadding) / 2
        let height = cellHeight

        guard width > 0, height > 0 else {
            return
        }
        if isMultipleColumnsEnabled {
            flowLayout.itemSize = CGSize(width: width, height: height)
            flowLayout.minimumInteritemSpacing = cellPadding
            flowLayout.minimumLineSpacing = cellPadding
        } else {
            flowLayout.itemSize = CGSize(width: collectionView?.frame.size.width ?? frame.width, height: height)
            flowLayout.minimumLineSpacing = cellPadding
        }

        print("Size: \(flowLayout.itemSize)")
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }

    private var cellHeight: CGFloat {
        return delegate?.cellHeight() ?? 200
    }

    private var cellPadding: CGFloat {
        return delegate?.cellPadding() ?? 4
    }

    private var isHighlightingEnabled: Bool {
        return delegate?.isHighlightingEnabled() ?? false
    }

    private var isMultipleColumnsEnabled: Bool {
        return delegate?.isMultipleColumnEnabled() ?? true
    }
    
    private var isInifiteScrollEnabled:Bool{
        return delegate?.isInfiniteScrollEnabled() ?? true
    }

    override public init(frame: CGRect) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .vertical

        super.init(frame: frame)

        if isMultipleColumnsEnabled {
            topRightCellIndex = IndexPath(item: 1, section: 0)
        } else {
            topRightCellIndex = nil
        }

        if let collectionView = collectionView {
            collectionView.dataSource = self
            collectionView.prefetchDataSource = self
            collectionView.isPrefetchingEnabled = true
            collectionView.delegate = self

            collectionView.register(UINib(nibName: PXLGridViewCell.identifier, bundle: Bundle(for: PXLGridViewCell.self)), forCellWithReuseIdentifier: PXLGridViewCell.identifier)

            addSubview(collectionView)
            backgroundColor = .clear
            collectionView.backgroundColor = .clear

            collectionView.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            ]
            NSLayoutConstraint.activate(constraints)

            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.adjustHighlight()
            }
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        setupCellSize()
        adjustHighlight()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var topLeftCellIndex: IndexPath = IndexPath(item: 0, section: 0)
    var topRightCellIndex: IndexPath?
}

extension PXLGridView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLGridViewCell.identifier, for: indexPath) as? PXLGridViewCell {
            delegate?.setupPhotoCell(cell: cell, photo: items[indexPath.row])
            cell.isHighlihtingEnabled = isHighlightingEnabled
            cell.cellWidth.constant = flowLayout.itemSize.width
            cell.cellHeight.constant = flowLayout.itemSize.height

            if indexPath == topLeftCellIndex || indexPath == topRightCellIndex {
                cell.highlightView()
            } else {
                cell.disableHighlightView()
            }
            return cell
        }
        fatalError()
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infiniteItems.count
    }
}

extension PXLGridView: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard isInifiteScrollEnabled, let lastIndexPath = indexPaths.last, lastIndexPath.row == infiniteItems.count - 1 else { return }

        var items = infiniteItems
        items.append(contentsOf: self.items)
        self.items = items
    }
}

extension PXLGridView: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustHighlight()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustHighlight()
    }

    func adjustHighlight() {
        guard let collectionView = collectionView else { return }

        let rightX = collectionView.bounds.width - flowLayout.itemSize.width / 2
        let leftX = flowLayout.itemSize.width / 2
        let topLeft = convert(CGPoint(x: leftX, y: flowLayout.itemSize.height / 2), to: collectionView)
        let topRight = convert(CGPoint(x: rightX, y: flowLayout.itemSize.height / 2), to: collectionView)
        guard let topLeftIndex = collectionView.indexPathForItem(at: topLeft), let topRightIndex = collectionView.indexPathForItem(at: topRight) else { return }
        guard topLeftIndex != topLeftCellIndex, topRightIndex != topRightCellIndex else { return }

        // reset the previous hight light cell
        if let cell = collectionView.cellForItem(at: topLeftCellIndex) as? PXLGridViewCell {
            cell.disableHighlightView()
        }
        if let cellIndex = topRightCellIndex, let cell = collectionView.cellForItem(at: cellIndex) as? PXLGridViewCell {
            cell.disableHighlightView()
        }

        // set hight light to a new center cell

        if let cell = collectionView.cellForItem(at: topLeftIndex) as? PXLGridViewCell {
            cell.highlightView()
            topLeftCellIndex = topLeftIndex
        }

        if let cell = collectionView.cellForItem(at: topRightIndex) as? PXLGridViewCell {
            cell.highlightView()
            topRightCellIndex = topRightIndex
        }
    }
}
