//
//  PhotoProductListDemoViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 09. 21..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class PhotoProductListDemoViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!

    var photos = [PXLPhoto]() {
        didSet {
            guard let stackView = stackView else { return }
            setupStackView()
        }
    }

    func setupStackView() {
        stackView.arrangedSubviews.forEach { view in
            self.stackView.removeArrangedSubview(view)
        }
        photos.forEach { photo in
            let widget = PXLPhotoProductView.widgetForPhoto(photo: photo, delegate: self)
//            widget.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: UIScreen.main.bounds.height)

            self.stackView.addArrangedSubview(widget.view)
            
            widget.view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                widget.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
                widget.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0),
            ]
            NSLayoutConstraint.activate(constraints)

            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension PhotoProductListDemoViewController: PXLPhotoProductDelegate {
    public func onProductsLoaded(products: [PXLProduct]) -> [Int: Bool] {
        var bookmarks = [Int: Bool]()
        products.forEach { product in
            bookmarks[product.identifier] = true
        }
        return bookmarks
    }

    public func onBookmarkClicked(product: PXLProduct, isSelected: Bool) {
        print("Pruduct: \(product.identifier) is selected: \(isSelected)")
    }

    public func shouldOpenURL(url: URL) -> Bool {
        print("url: \(url)")
        return false
    }

    public func onProductClicked(product: PXLProduct) {
        print("Pruduct: \(product.identifier) clicked")
    }
}
