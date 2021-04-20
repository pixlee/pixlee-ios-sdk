//
//  PXLLoadMoreFooterView.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 4/20/21.
//

import Gifu
import Nuke
import UIKit

public enum LoadMoreType {
    case loading
    case loadMore
}

public struct PXLLoadMoreFooterSettings {
    public let loadMoreType: LoadMoreType
    public let width: CGFloat
    public let height: CGFloat
    public let padding: CGFloat
    public let title: String
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let loadingStyle: UIActivityIndicatorView.Style

    public init(loadMoreType: LoadMoreType, width: CGFloat, height: CGFloat, padding: CGFloat, title: String, titleFont: UIFont, titleColor: UIColor, loadingStyle: UIActivityIndicatorView.Style) {
        self.loadMoreType = loadMoreType
        self.width = width
        self.height = height
        self.padding = padding
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.loadingStyle = loadingStyle
    }
}

class PXLLoadMoreFooterView: UICollectionReusableView {
    var viewModel: PXLLoadMoreFooterSettings? {
        didSet {
            customInit()
        }
    }
    
    let loadingIndicator = UIActivityIndicatorView(style: .gray)
    var titleLabel = UILabel()
    
    override func prepareForReuse() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let viewModel = viewModel {
            loadingIndicator.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            loadingIndicator.center = center
            titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
    }
    
    func customInit() {
        guard let viewModel = viewModel else { return }
        clipsToBounds = true

        switch (viewModel.loadMoreType) {
            case .loading:
                loadingIndicator.style = viewModel.loadingStyle
                loadingIndicator.startAnimating()
                addSubview(loadingIndicator)
            case .loadMore:
                titleLabel.text = viewModel.title
                titleLabel.font = viewModel.titleFont
                titleLabel.textColor = viewModel.titleColor
                titleLabel.numberOfLines = 0
                titleLabel.textAlignment = .center
                addSubview(titleLabel)
        }
    }
}
