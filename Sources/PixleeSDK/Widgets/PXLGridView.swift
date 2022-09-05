//
//  PXLGridView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 10. 11..
//

import UIKit
import AVFoundation
import InfiniteLayout
public protocol PXLGridViewAutoAnalyticsDelegate:class {
    // pass an album if you want to delegate this view to fire 'openedWidget' and 'widgetVisible' analytics events automatically. Additionaly you must set [PXLClient.sharedClient.autoAnalyticsEnabled = true] to enable auto-analytics.
    // if you manually fire analytics, you can pass 'nil' to this function.
    func setupAlbumForAutoAnalytics() -> (album: PXLAlbum, widgetType:String)
}

public protocol PXLGridViewDelegate:class {
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto)
    func cellsHighlighted(cells: [PXLGridViewCell])
    func scrollViewDidScroll(_ scrollView: UIScrollView)
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    public var album: PXLAlbum?
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

    public weak var delegate: PXLGridViewDelegate? {
        didSet {
            collectionView?.infiniteLayout.isEnabled = self.isInfiniteScrollEnabled
            setupCellSize()
            if isMultipleColumnsEnabled {
                topRightCellIndex = IndexPath(item: 1, section: 0)
            } else {
                topRightCellIndex = nil
            }
        }
    }
    
    public weak var autoAnalyticsDelegate: PXLGridViewAutoAnalyticsDelegate?{
        didSet{
            fireOpenAndVisible()
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
        } else {
            flowLayout.itemSize = CGSize(width: collectionView?.frame.size.width ?? frame.width, height: height)
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
            
            #if SWIFT_PACKAGE
            let bundle = Bundle.module
            #else
            let bundle = Bundle(for: PXLGridViewCell.self)
            #endif
            collectionView.register(UINib(nibName: PXLGridViewCell.identifier, bundle: bundle), forCellWithReuseIdentifier: PXLGridViewCell.identifier)
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
                PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedWidget(album: autoAnalytics.album, widget: .other(customValue: autoAnalytics.widgetType))) { error in
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
                PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventWidgetVisible(album: autoAnalytics.album, widget: .other(customValue: autoAnalytics.widgetType))) { error in
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
        
        if autoAnalyticsDelegate == nil {
            print("autoAnalyticsDelegate or PXLGridViewDelegate.setupAlbumForAutoAnalytics(){..} is not specified")
        } else {
            print("You need to specify 'class YourViewController PXLGridViewDelegate.setupAlbumForAutoAnalytics(){return (yourAlbum, your widget type)}'")
        }
        
        return autoAnalyticsDelegate?.setupAlbumForAutoAnalytics()
    }

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

extension PXLGridView: UICollectionViewDelegateFlowLayout {
    
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

extension PXLGridView: UICollectionViewDelegate {
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
