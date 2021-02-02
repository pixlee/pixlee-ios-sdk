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
    static func getInstance() -> EmptyViewController {
        return EmptyViewController(nibName: "EmptyViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let button = UIButton(frame: CGRect(x: 20, y: 60, width: 100, height: 50))
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("< Back", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Back")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
