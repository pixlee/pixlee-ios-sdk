//
//  PXLPhotoListView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import UIKit

public protocol PXLPhotoListViewDelegate {
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

    public var delegate: PXLPhotoListViewDelegate? {
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
}

extension PXLPhotoListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PXLPhotoListViewCell.identifier) as? PXLPhotoListViewCell {
            delegate?.setupPhotoCell(cell: cell, photo: items[indexPath.row])
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
