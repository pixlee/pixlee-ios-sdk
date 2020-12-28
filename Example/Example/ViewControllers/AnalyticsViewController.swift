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
    static func getInstance() -> AnalyticsViewController {
        return AnalyticsViewController(nibName: "AnalyticsViewController", bundle: Bundle.main)
    }    
    
    var photo: PXLPhoto?
    @IBOutlet var consoleLabel: UILabel!
    var album = PXLAlbum(identifier: "")
    var pixleeCredentials = PixleeCredentials()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            pixleeCredentials = try PixleeCredentials.create()
            album = PXLAlbum(identifier: String(pixleeCredentials.albumId ?? ""))
            album.regionId = pixleeCredentials.regionId
            
        } catch{
            showPopup(message: error.localizedDescription)
        }

        
        
        _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, error in
            guard error == nil else {
                self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }
            self.photo = photos?.first
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
            _ = photo.triggerEventOpenedLightbox(regionId: pixleeCredentials.regionId) { error in
                guard error == nil else {
                    self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                    return
                }
                self.printToConsole(log: "Opened lightbox fired")
            }
        } else {
            printToConsole(log: "Please insert a correct photo_album_id first")
        }
    }

    @IBAction func actionClicked(_ sender: Any) {
        if let photo = photo {
            _ = photo.triggerEventActionClicked(actionLink: "actionLink", regionId: pixleeCredentials.regionId, completionHandler: { error in
                guard error == nil else {
                    self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                    return
                }
                self.printToConsole(log: "Action clicked fired")
            })
        } else {
            printToConsole(log: "Please insert a correct photo_album_id first")
        }
    }

    @IBAction func addToCart(_ sender: Any) {
        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventAddCart(sku: "SL-BENJ", quantity: 1, price: "13.0", currency: "USD", regionId: pixleeCredentials.regionId)) { error in
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
                                            currency: "USD",
                                            regionId: pixleeCredentials.regionId)) { error in
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


// MARK: - Show Popup
extension AnalyticsViewController {
    func showPopup(message:String) {
        let alert = UIAlertController(title: "No credential file", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { (action) in
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
