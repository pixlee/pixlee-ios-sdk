//
//  BaseViewController.swift
//  Example
//
//  Created by Sungjun Hong on 1/6/21.
//  Copyright © 2021 Pixlee. All rights reserved.
//

import Foundation

import PixleeSDK
import UIKit

// MARK: - Show Popup
extension UIViewController {
    func showPopup(message:String) {
        let alert = UIAlertController(title: "No credential file", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { (action) in
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
