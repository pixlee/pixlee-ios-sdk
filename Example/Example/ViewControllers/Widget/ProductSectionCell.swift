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

public class ProductSectionCell: UICollectionViewCell {
    public static let defaultIdentifier = "ProductSectionCell"

    @IBOutlet weak var cellContainer: UIView!
    
    @IBOutlet weak var title: UILabel!
    
    public var titleText:String? = nil{
        didSet {
            title.text = titleText
        }
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //cellContainer.layer.cornerRadius = 4
    }
}
