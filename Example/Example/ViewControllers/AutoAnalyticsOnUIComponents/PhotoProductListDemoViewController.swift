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
    static func getInstance(_ photo: PXLPhoto) -> PhotoProductListDemoViewController {
        let vc = PhotoProductListDemoViewController(nibName: "PhotoProductListDemoViewController", bundle: Bundle.main)
        vc.photo = photo
        return vc
    }
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!

    var photo: PXLPhoto?
    var pxlPhotoProductView: PXLPhotoProductView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoProductView()
    }
    
    func setupPhotoProductView() {
        stackView.arrangedSubviews.forEach { view in
            self.stackView.removeArrangedSubview(view)
        }
        
        guard let photo = photo else {return}
        
        let widget = PXLPhotoProductView.widgetForPhoto(photo: photo, delegate: self)
        widget.cropMode = .centerFill
        widget.closeButtonBackgroundColor = .white
        widget.closeButtonCornerRadius = 22
        widget.closeButtonTintColor = UIColor.red.withAlphaComponent(0.6)
        
        widget.muteButtonBackgroundColor = .white
        widget.muteButtonTintColor = UIColor.red.withAlphaComponent(0.6)
        
        self.stackView.addArrangedSubview(widget.view)
        
        widget.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            widget.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1),
            widget.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0),
        ]
        pxlPhotoProductView = widget
        NSLayoutConstraint.activate(constraints)
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
        
        let alert = UIAlertController(title: "Select a Modal Presentation Style.", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "fullScreen", style: UIAlertAction.Style.default, handler: {_ in
            let vc = EmptyViewController.getInstance(url)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)

        }))

        alert.addAction(UIAlertAction(title: "popover", style: UIAlertAction.Style.default, handler: {_ in
            let vc = EmptyViewController.getInstance(url)
            self.present(vc, animated: true, completion: nil)

        }))
        self.present(alert, animated: true, completion: nil)

        
        return false
    }

    public func onProductClicked(product: PXLProduct) {
        print("Pruduct: \(product.identifier) clicked")
    }
}
