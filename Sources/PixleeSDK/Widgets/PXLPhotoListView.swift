//
//  PXLPhotoListView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import UIKit

public protocol PXLPhotoListViewDelegate: class {
    func setupPhotoCell(cell: PXLPhotoListViewCell, photo: PXLPhoto)
    func onPhotoClicked(photo: PXLPhoto)
    func onPhotoButtonClicked(photo: PXLPhoto)
    func cellHeight() -> CGFloat
}

public class PXLPhotoListView: UIView {
    let tableView = UITableView()

    public var items: [PXLPhoto] = [] {
        didSet {
            infiniteItems = items
        }
    }

    private var infiniteItems: [PXLPhoto] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    public weak var delegate: PXLPhotoListViewDelegate? {
        didSet {
            guard let delegate = delegate else { return }
            let height = delegate.cellHeight()
            tableView.rowHeight = height
            tableView.estimatedRowHeight = height
        }
    }

    private var cellHeight: CGFloat {
        return delegate?.cellHeight() ?? 200
    }

    public init() {
        super.init(frame: .zero)
        tableView.dataSource = self
        tableView.register(UINib(nibName: PXLPhotoListViewCell.identifier, bundle: Bundle(for: PXLPhotoListViewCell.self)), forCellReuseIdentifier: PXLPhotoListViewCell.identifier)
        tableView.rowHeight = cellHeight
        tableView.estimatedRowHeight = cellHeight
        tableView.prefetchDataSource = self
        tableView.delegate = self

        addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var topIndexPath: IndexPath = IndexPath(row: 0, section: 0)

}

extension PXLPhotoListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PXLPhotoListViewCell.identifier) as? PXLPhotoListViewCell {
            delegate?.setupPhotoCell(cell: cell, photo: items[indexPath.row])

            if indexPath.row == topIndexPath.row {
                print("\t Enable Highlighting :\(indexPath)")
                cell.highlightView()
            } else {
                print("\t Disable Highlighting :\(indexPath)")
                cell.disableHighlightView()
            }
            return cell
        }
        fatalError()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infiniteItems.count
    }
}

extension PXLPhotoListView: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndexPath = indexPaths.last, lastIndexPath.row == infiniteItems.count - 1 else { return }

        var items = infiniteItems
        items.append(contentsOf: self.items)
        self.items = items
    }
}

extension PXLPhotoListView: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustHighlight()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustHighlight()
    }

    func adjustHighlight() {
        // set hight light to a new center cell
        let centerX = tableView.bounds.width / 2

        let topItemCoords = convert(CGPoint(x: centerX, y: cellHeight / 2), to: tableView)

        guard let currentIndex = tableView.indexPathForRow(at: topItemCoords) else { return }

        guard currentIndex != topIndexPath else { return }

        // reset the previous hight light cell
        if let cell = tableView.cellForRow(at: topIndexPath) as? PXLPhotoListViewCell {
            print("Disable Highlighting :\(topIndexPath)")
            cell.disableHighlightView()
        }

        if let cell = tableView.cellForRow(at: currentIndex) as? PXLPhotoListViewCell {
            print("Highlighting :\(currentIndex)")
            cell.highlightView()
            topIndexPath = currentIndex
        }
    }
}
