//
//  EmptyViewController.swift
//  Example
//
//  Created by Sungjun Hong on 2/2/21.
//  Copyright © 2021 Pixlee. All rights reserved.
//
import Foundation
import PixleeSDK
import UIKit

class EmptyViewController: UIViewController {
    static func getInstance(_ url: URL) -> EmptyViewController {
        let vc = EmptyViewController(nibName: "EmptyViewController", bundle: Bundle.main)
        vc.url = url
        return vc
    }
    
    var url: URL? = nil
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("< Back", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        titleLabel.textColor = UIColor.black
        titleLabel.text = "Product Detail"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(titleLabel)
        
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = UIColor.black
        bodyLabel.text = "This is just an example of your product page. You need to implement this inside your app.\n\nClicked product url: \(url)"
        bodyLabel.textAlignment = .center
        bodyLabel.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(bodyLabel)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var yPosition = CGFloat(0)
        if modalPresentationStyle.rawValue == 0 {
            yPosition = CGFloat(view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        }
        
        button.frame = CGRect(x: 0, y: yPosition, width: 100, height: 50)
        titleLabel.frame = CGRect(x:0, y: yPosition, width: view.frame.size.width, height: 50)
        let padding = CGFloat(10)
        bodyLabel.frame = CGRect(x:0 + padding, y: yPosition + 50 + padding, width: view.frame.size.width - (padding * 2), height: view.frame.size.height - (padding * 2))
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Back")
        dismiss(animated: true, completion: nil)
    }
}
