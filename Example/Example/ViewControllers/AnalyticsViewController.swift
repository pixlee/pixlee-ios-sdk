//
//  AnalyticsViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 03. 18..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class AnalyticsViewController: UIViewController {
    
    var photo: PXLPhoto?
    @IBOutlet var consoleLabel: UILabel!
    let album = PXLAlbum(identifier: ProcessInfo.processInfo.environment["PIXLEE_ALBUM_ID"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var photoAlbumId = ProcessInfo.processInfo.environment["PIXLEE_PHOTO_ALBUM_ID"]
        if let photoAlbumId = photoAlbumId {
            _ = PXLClient.sharedClient.getPhotoWithPhotoAlbumId(photoAlbumId: photoAlbumId) { newPhoto, error in
                guard error == nil else {
                    print("Error during load of image with Id \(String(describing: error))")
                    return
                }
                guard let photo = newPhoto else {
                    print("cannot find photo")
                    return
                }
                self.photo = photo
            }
        }
    }

    

    // Album events
    @IBAction func openedWidget(_ sender: Any) {
        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedWidget(album: album, widget: .other(customValue: "customWidgetName"))) { error in
            guard error == nil else {
                self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }
            self.printToConsole(log: "Opened widget fired")
        }
    }

    @IBAction func widgetVisible(_ sender: Any) {
        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventWidgetVisible(album: album, widget: .other(customValue: "customWidgetName"))) { error in
            guard error == nil else {
                self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }
            self.printToConsole(log: "Widget visible fired")
        }
    }

    @IBAction func widgetsExample(_ sender: Any) {
        let exampleVC = WidgetsExampleViewController(nibName: "WidgetsExampleViewController", bundle: Bundle.main)
        present(exampleVC, animated: true, completion: nil)
    }

    @IBAction func loadMore(_ sender: Any) {
        _ = album.triggerEventLoadMoreTapped { error in
            guard error == nil else {
                self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }
            self.printToConsole(log: "Load more fired")
        }
    }

    @IBAction func openedLightbox(_ sender: Any) {
        if let photo = photo {
            _ = photo.triggerEventOpenedLightbox { error in
                guard error == nil else {
                    self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                    return
                }
                self.printToConsole(log: "Opened lightbox fired")
            }
        }
    }

    @IBAction func actionClicked(_ sender: Any) {
        if let photo = photo {
            _ = photo.triggerEventActionClicked(actionLink: "actionLink", completionHandler: { error in
                guard error == nil else {
                    self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                    return
                }
                self.printToConsole(log: "Action clicked fired")
            })
        }
    }

    @IBAction func addToCart(_ sender: Any) {
        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventAddCart(sku: "SL-BENJ", quantity: 1, price: "13.0", currency: "USD")) { error in
            guard error == nil else {
                self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }
            self.printToConsole(log: "Add to Cart fired")
        }
    }

    @IBAction func conversion(_ sender: Any) {
        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event:
            PXLAnalyticsEventConvertedPhoto(cartContents: [PXLAnalyticsCartContents(price: "13.0", productSKU: "SL-BENJ", quantity: 1),
                                                           PXLAnalyticsCartContents(price: "5.0", productSKU: "AD-1324S", quantity: 2)],
                                            cartTotal: "18.0",
                                            cartTotalQuantity: 3,
                                            currency: "USD")) { error in
            guard error == nil else {
                self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }
            self.printToConsole(log: "Conversion fired")
        }
    }

    func printToConsole(log: String) {
        consoleLabel.text = log
        print(log)
    }
}
