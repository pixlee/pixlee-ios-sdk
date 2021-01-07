//
//  PXLGridView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 10. 11..
//

import UIKit
import AVFoundation

public protocol PXLGridViewDelegate:class {
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto)
    func cellsHighlighted(cells: [PXLGridViewCell])
    func onPhotoClicked(photo: PXLPhoto)
    func onPhotoButtonClicked(photo: PXLPhoto)
    func cellHeight() -> CGFloat
    func cellPadding() -> CGFloat
    func isMultipleColumnEnabled() -> Bool
    func isHighlightingEnabled() -> Bool
    func isInfiniteScrollEnabled() -> Bool
    func isVideoMutted() -> Bool

    func headerTitle() -> String?
    func headerGifName() -> String?
    func headerGifUrl() -> String?
    func headerHeight() -> CGFloat
    func headerGifContentMode() -> UIView.ContentMode
    func headerTitleFont() -> UIFont
    func headerTitleColor() -> UIColor
}

extension PXLGridViewDelegate {
    public func cellsHighlighted(cells: [PXLGridViewCell]) {
    }

    public func headerTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 21)
    }

    public func headerTitleColor() -> UIColor {
        return .black
    }

    public func headerGifContentMode() -> UIView.ContentMode {
        return .scaleAspectFill
    }

    public func headerHeight() -> CGFloat {
        return 200
    }

    public func headerTitle() -> String? {
        return nil
    }

    public func headerGifName() -> String? {
        return nil
    }

    public func headerGifUrl() -> String? {
        return nil
    }
}

public class PXLGridView: UIView {    
    var collectionView: InfiniteCollectionView?
    let flowLayout = UICollectionViewFlowLayout()

    public var items: [PXLPhoto] = [] {
        didSet {
            infiniteItems = items
        }
    }

    private var infiniteItems: [PXLPhoto] = [] {
        didSet {
            collectionView?.reloadData()
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                self.logFirstHighlights()
            }
        }
    }

    public weak var delegate: PXLGridViewDelegate? {
        didSet {
            print("self.isInfiniteScrollEnabled: \(self.isInfiniteScrollEnabled)")
            collectionView?.infiniteLayout.isEnabled = self.isInfiniteScrollEnabled
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

        if delegate?.headerTitle() != nil || delegate?.headerGifUrl() != nil || delegate?.headerGifName() != nil {
            flowLayout.headerReferenceSize = CGSize(width: frame.size.width, height: headerHeight + cellPadding)
        }

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

        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }

    private var cellHeight: CGFloat {
        return delegate?.cellHeight() ?? 200
    }
    private var headerHeight: CGFloat {
        return delegate?.headerHeight() ?? 200
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

    private var isInfiniteScrollEnabled: Bool {
        return delegate?.isInfiniteScrollEnabled() ?? true
    }
    
    private var isVideoMutted: Bool {
        return delegate?.isVideoMutted() ?? true
    }

    var firstHighlightLogged = false
    var secondHighlightLogged = false
    
    private let category = AVAudioSession.sharedInstance().category
    
    
    public override func didMoveToSuperview() {
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback)
        }catch{
            
        }
    }
    
    public override func didMoveToWindow() {
        if (self.window == nil) {
            do{
                try AVAudioSession.sharedInstance().setCategory(category)
            }catch{
                
            }
        }
    }

    override public init(frame: CGRect) {
        collectionView = InfiniteCollectionView(frame: frame, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .vertical

        super.init(frame: frame)
        
        if isMultipleColumnsEnabled {
            topRightCellIndex = IndexPath(item: 1, section: 0)
        } else {
            topRightCellIndex = nil
        }
        
        if let collectionView = collectionView {
            collectionView.dataSource = self
            //collectionView.prefetchDataSource = self
            collectionView.isPrefetchingEnabled = true
            collectionView.delegate = self

            collectionView.register(UINib(nibName: PXLGridViewCell.identifier, bundle: Bundle(for: PXLGridViewCell.self)), forCellWithReuseIdentifier: PXLGridViewCell.identifier)
            collectionView.register(PXLGridHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")

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
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? PXLGridHeaderView {
            guard let delegate = delegate else { fatalError("Needs to add the delegate first") }

            let headerHeight = delegate.headerHeight()
            let contentMode = delegate.headerGifContentMode()
            if let title = delegate.headerTitle() {
                let titleFont = delegate.headerTitleFont()
                let titleColor = delegate.headerTitleColor()
                header.viewModel = PXLGridHeaderSettings(title: title,
                                                         height: headerHeight,
                                                         width: collectionView.frame.size.width,
                                                         padding: cellPadding,
                                                         titleFont: titleFont,
                                                         titleColor: titleColor,
                                                         gifContentMode: contentMode)
            } else if let url = delegate.headerGifUrl() {
                header.viewModel = PXLGridHeaderSettings(titleGifUrl: url,
                                                         height: headerHeight,
                                                         width: collectionView.frame.size.width,
                                                         padding: cellPadding,
                                                         gifContentMode: contentMode)
            } else if let name = delegate.headerGifName() {
                header.viewModel = PXLGridHeaderSettings(titleGifName: name,
                                                         height: headerHeight,
                                                         width: collectionView.frame.size.width,
                                                         padding: cellPadding,
                                                         gifContentMode: contentMode)
            }

            return header
        }
        fatalError()
    }

    func logFirstHighlights() {
        guard let collectionView = collectionView else { return }
        var highlightedCells = [PXLGridViewCell]()

        if let cell = collectionView.cellForItem(at: topLeftCellIndex) as? PXLGridViewCell {
            highlightedCells.append(cell)
        }

        if let topRightCellIndex = topRightCellIndex, let cell = collectionView.cellForItem(at: topRightCellIndex) as? PXLGridViewCell {
            highlightedCells.append(cell)
        }

        delegate?.cellsHighlighted(cells: highlightedCells)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PXLGridViewCell.identifier, for: indexPath) as? PXLGridViewCell {
            let index = self.collectionView!.indexPath(from: indexPath).row
            delegate?.setupPhotoCell(cell: cell, photo: items[index])
            cell.isHighlihtingEnabled = isHighlightingEnabled
            //cell.cellWidth.constant = flowLayout.itemSize.width
            //cell.cellHeight.constant = flowLayout.itemSize.height

            if indexPath == topLeftCellIndex || indexPath == topRightCellIndex {
                cell.highlightView(muted: isVideoMutted)
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

extension PXLGridView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width * 0.3, height: 100)
        return flowLayout.itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //return collectionView.frame.width * 0.1
        return cellPadding
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: cellPadding, right: 0)
    }
}


//extension PXLGridView: UICollectionViewDataSourcePrefetching {
//    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        guard isInfiniteScrollEnabled, let lastIndexPath = indexPaths.last, lastIndexPath.row == infiniteItems.count - 1 else { return }
//
//        var items = infiniteItems
//        items.append(contentsOf: self.items)
//        self.items = items
//    }
//}

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
        var highlightedCells = [PXLGridViewCell]()

        if let cell = collectionView.cellForItem(at: topLeftIndex) as? PXLGridViewCell {
            cell.highlightView(muted: isVideoMutted)
            highlightedCells.append(cell)
            topLeftCellIndex = topLeftIndex
        }

        if topLeftIndex != topRightIndex, let cell = collectionView.cellForItem(at: topRightIndex) as? PXLGridViewCell {
            cell.highlightView(muted: isVideoMutted)
            highlightedCells.append(cell)
            topRightCellIndex = topRightIndex
        }

        delegate?.cellsHighlighted(cells: highlightedCells)
    }
}
