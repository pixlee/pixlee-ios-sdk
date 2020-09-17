//
//  PXLPhotoListView.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 17..
//

import UIKit

class PXLPhotoListView: UIView {
    let tableView = UITableView()

    var items: [PXLPhoto] = []

    init() {
        tableView.dataSource = self
        addSubview(tableView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PXLPhotoListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
}
