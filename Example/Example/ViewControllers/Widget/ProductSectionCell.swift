//
//  ProductSectionCell.swift
//  Example
//
//  Created by Sungjun Hong on 5/4/21.
//  Copyright © 2021 Pixlee. All rights reserved.
//

import Foundation
import Nuke
import UIKit

public class ProductSectionCell: UICollectionReusableView {
    public static let defaultIdentifier = "ProductSectionCell"
    var titleText:String?
    public override func prepareForReuse() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    var titleLabel = UILabel()
    public override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(titleLabel)
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(titleConstraints)
    }
}
