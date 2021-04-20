//
//  PXLWidgetView.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 4/16/21.
//

import UIKit
import AVFoundation

public protocol PXLWidgetViewDelegate:class {
    func setWidgetSpec() -> WidgetSpec
    func setWidgetType() -> String
    func setPXLAlbum() -> PXLAlbum

    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto)
    func cellsHighlighted(cells: [PXLGridViewCell])
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

extension PXLWidgetViewDelegate {
    public func cellsHighlighted(cells: [PXLGridViewCell]) {
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

public class PXLWidgetView: UIView {
    open var collectionView: InfiniteCollectionView?
    public var flowLayout: InfiniteLayout! {
        return collectionView?.collectionViewLayout as? InfiniteLayout
    }
    
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
            fireOpenAndVisible()
        }
    }
    
    public weak var delegate: PXLWidgetViewDelegate? {
        didSet {
            collectionView?.infiniteLayout.isEnabled = false
            setupCellSize()
            if isMultipleColumnsEnabled {
                topRightCellIndex = IndexPath(item: 1, section: 0)
            } else {
                topRightCellIndex = nil
            }
            loadPhotos()
        }
    }

    @objc func loadMoreClicked(_ sender: UITapGestureRecognizer){
        loadPhotos()
    }

    var searchingAlbum: PXLAlbum? = nil
    var loadMoreType: LoadMoreType? = nil
    func loadPhotos() {
        loadMoreType = .loading
        if let searchingAlbum = searchingAlbum {

        }
        if let oldAlbum = delegate?.setPXLAlbum(), let album = (searchingAlbum != nil) ? searchingAlbum : oldAlbum {
            _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, _ in
                self.searchingAlbum = album
                if let photos = photos {
                    for photo in photos {
                        self.items.append(photo)
                    }
                }

                if album.hasNextPage {
                    self.loadMoreType = .loadMore
                } else {
                    self.loadMoreType = nil
                }
            }
        } else {
            debugPrint("loadPhotos() no album")
            self.loadMoreType = nil
        }
    }
    
    func setupCellSize() {
        let width = ((collectionView?.frame.size.width ?? frame.width) - cellPadding) / 2
        let height = cellHeight

        if let widgetSpec = delegate?.setWidgetSpec() {
            switch widgetSpec {
            case .grid(let grid):
                if let header = grid.header {
                    let headerHeight: CGFloat
                    switch header {
                        case .text(let text):
                            headerHeight = text.headerHeight
                        case .image(let image):
                            switch image {
                                case .localPath(let localPath):
                                    headerHeight = localPath.headerHeight
                                case .remotePath(let remotePath):
                                    headerHeight = remotePath.headerHeight
                            }
                    }
                    flowLayout.headerReferenceSize = CGSize(width: frame.size.width, height: headerHeight + grid.cellPadding)
                }

                flowLayout.footerReferenceSize = CGSize(width: frame.size.width, height: grid.loadMore.cellHeight + grid.loadMore.cellPadding)
            case .list(_):
                debugPrint("")
            }
        }
        
        guard width > 0, height > 0 else {
            return
        }
        if isMultipleColumnsEnabled {
            flowLayout.itemSize = CGSize(width: width, height: height)
        } else {
            flowLayout.itemSize = CGSize(width: collectionView?.frame.size.width ?? frame.width, height: height)
        }
        
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }

    private var cellPadding: CGFloat {
        guard case let .grid(grid) = delegate?.setWidgetSpec() else { return 4}
        return grid.cellPadding
    }
    
    private var cellHeight: CGFloat {
        guard let widgetSpec = delegate?.setWidgetSpec() else { return 200.0 }
        switch widgetSpec {
            case .grid(let grid):
                return grid.cellHeight
            case .list(let list):
                return list.cellHeight
        }
    }

    private var autoVideoPlayEnabled: Bool {
        guard case let .list(list) = delegate?.setWidgetSpec() else { return false}
        return list.autoVideoPlayEnabled
    }
    
    private var isMultipleColumnsEnabled: Bool {
        guard case let .grid(grid) = delegate?.setWidgetSpec() else { return false}
        return true
    }
    
    private var isVideoMutted: Bool {
        guard case let .list(list) = delegate?.setWidgetSpec() else { return true}
        return list.isVideoMutted
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
        let screenSize: CGRect = UIScreen.main.bounds
        if self.window == nil {
            // on destroyed
            do{
                try AVAudioSession.sharedInstance().setCategory(category)
            }catch{
                
            }
        } else {
            // on started
            fireOpenAndVisible()
        }
    }
    
    override public init(frame: CGRect) {
        collectionView = InfiniteCollectionView(frame: frame)
        
        super.init(frame: frame)
        
        flowLayout.scrollDirection = .vertical
        
        if isMultipleColumnsEnabled {
            topRightCellIndex = IndexPath(item: 1, section: 0)
        } else {
            topRightCellIndex = nil
        }
        
        if let collectionView = collectionView {
            collectionView.dataSource = self
            collectionView.isPrefetchingEnabled = true
            collectionView.delegate = self
            
            collectionView.register(UINib(nibName: PXLGridViewCell.identifier, bundle: Bundle(for: PXLGridViewCell.self)), forCellWithReuseIdentifier: PXLGridViewCell.identifier)
            collectionView.register(PXLGridHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
            collectionView.register(PXLLoadMoreFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")

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
    
    private func isVisible(_ view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: view, inView: view.superview)
    }
    
    private func fireOpenAndVisible() {
        fireAnalyticsOpenedWidget()
        fireAnalyticsWidgetVisible()
    }
    
    private var isAnalyticsOpenedWidgetFired = false
    private func fireAnalyticsOpenedWidget() {
        guard let autoAnalytics = getAutoAnalytics() else {
            return
        }
        
        if !isAnalyticsOpenedWidgetFired {
            if !infiniteItems.isEmpty {
                isAnalyticsOpenedWidgetFired = true
                _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedWidget(album: autoAnalytics.album, widget: .other(customValue: autoAnalytics.widgetType))) { error in
                    guard error == nil else {
                        self.isAnalyticsOpenedWidgetFired = false
                        print("🛑 There was an error \(error?.localizedDescription ?? "")")
                        return
                    }
                }
            }
        }
    }
    
    private var isAnalyticsVisibleWidgetFired = false
    private func fireAnalyticsWidgetVisible() {
        guard let autoAnalytics = getAutoAnalytics() else {
            return
        }
        
        if !isAnalyticsVisibleWidgetFired, let customView = collectionView {
            if !infiniteItems.isEmpty && isVisible(customView) {
                isAnalyticsVisibleWidgetFired = true
                _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventWidgetVisible(album: autoAnalytics.album, widget: .other(customValue: autoAnalytics.widgetType))) { error in
                    guard error == nil else {
                        self.isAnalyticsVisibleWidgetFired = false
                        print( "🛑 There was an error \(error?.localizedDescription ?? "")")
                        return
                    }
                }
            }
        }
    }
    
    private func getAutoAnalytics() -> (album: PXLAlbum, widgetType: String)? {
        if !PXLClient.sharedClient.autoAnalyticsEnabled {
            return nil
        }
        
        guard let album = delegate?.setPXLAlbum(), let widgetType = delegate?.setWidgetType() else {
            print("PXLGridViewDelegate, PXLGridViewDelegate.setPXLAlbum(){..}, or PXLGridViewDelegate.setWidgetType(){..} is not specified")
            return nil
        }

        return (album, widgetType)
    }
    
}

extension PXLWidgetView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch (kind) {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! PXLGridHeaderView
                debugPrint("adding header")
                guard case let .grid(grid) = delegate?.setWidgetSpec(), let gridHeader = grid.header else { fatalError("Needs to add the delegate and add WidgetSpec.Grid.Header") }
                switch gridHeader {
                case .text(let text):
                    header.viewModel = PXLGridHeaderSettings(title: text.headerTitle,
                            height: text.headerHeight,
                            width: collectionView.frame.size.width,
                            padding: grid.cellPadding,
                            titleFont: text.headerTitleFont,
                            titleColor: text.headerTitleColor,
                            gifContentMode: text.headerContentMode)
                case .image(let image):
                    switch image {
                    case .remotePath(let remotePath):
                        header.viewModel = PXLGridHeaderSettings(titleGifUrl: remotePath.headerGifUrl,
                                height: remotePath.headerHeight,
                                width: collectionView.frame.size.width,
                                padding: grid.cellPadding,
                                gifContentMode: remotePath.headerContentMode)
                    case .localPath(let localPath):
                        header.viewModel = PXLGridHeaderSettings(titleGifName: localPath.headerGifName,
                                height: localPath.headerHeight,
                                width: collectionView.frame.size.width,
                                padding: grid.cellPadding,
                                gifContentMode: localPath.headerContentMode)
                    }
                }
                return header
            case UICollectionView.elementKindSectionFooter:
                guard let loadMoreType = loadMoreType else { return UICollectionReusableView() }
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! PXLLoadMoreFooterView
                debugPrint("adding footer")
                guard let widgetSpec = delegate?.setWidgetSpec() else { fatalError("Needs to add the delegate and add WidgetSpec.Grid.Header") }
                //guard case let .grid(grid) = delegate?.setWidgetSpec() else { fatalError("Needs to add the delegate and add WidgetSpec.Grid.Header") }
                let loadMore: WidgetSpec.LoadMore
                switch (widgetSpec) {
                    case .grid(let grid):
                        loadMore = grid.loadMore
                    case .list(let list):
                        loadMore = list.loadMore
                }
                footer.viewModel = .init(loadMoreType: loadMoreType,
                        width: collectionView.frame.size.width,
                        height: loadMore.cellHeight,
                        padding: loadMore.cellPadding,
                        title: loadMore.text,
                        titleFont: loadMore.textFont,
                        titleColor: loadMore.textColor,
                        loadingStyle: loadMore.loadingStyle)

                //add click listner
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(loadMoreClicked(_:)))
                footer.addGestureRecognizer(tapGestureRecognizer)

                return footer
            default:
                return UICollectionReusableView()
        }
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
            cell.isHighlihtingEnabled = autoVideoPlayEnabled
            cell.cellWidth.constant = flowLayout.itemSize.width
            cell.cellHeight.constant = flowLayout.itemSize.height
            
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

extension PXLWidgetView: UICollectionViewDelegateFlowLayout {
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        return CGSize(width: collectionView.bounds.width, height: 90)
//    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return flowLayout.itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: cellPadding, right: 0)
    }
}

extension PXLWidgetView: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustHighlight()
        delegate?.scrollViewDidScroll(scrollView)
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
