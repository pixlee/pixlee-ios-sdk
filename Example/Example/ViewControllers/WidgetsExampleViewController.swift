//
//  WidgetsExampleViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 03. 18..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class WidgetsExampleViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var consoleOutput: UILabel!
    
    let album = PXLAlbum(identifier: ProcessInfo.processInfo.environment["PIXLEE_ALBUM_ID"])
    var widgetVisibleFired = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "WidgetTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "widgetCell")

        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedWidget(album: album, widget: .other(customValue: "customWidgetName"))) { error in
            guard error == nil else {
                self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                return
            }
            self.printToConsole(log: "Opened widget fired")
        }
    }

    func printToConsole(log: String) {
        consoleOutput.text = log
        print(log)
    }
}

extension WidgetsExampleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if widgetVisible(), !widgetVisibleFired {
            widgetVisibleFired = true
            _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventWidgetVisible(album: album, widget: .other(customValue: "customWidgetName"))) { error in
                guard error == nil else {
                    self.printToConsole(log: "🛑 There was an error \(error?.localizedDescription ?? "")")
                    return
                }
                self.printToConsole(log: "Widget visible fired")
            }
        }
    }

    func widgetVisible() -> Bool {
        if let indices = tableView.indexPathsForVisibleRows {
            for index in indices {
                if index.row == 51 {
                    return true
                }
            }
        }
        return false
    }
}

extension WidgetsExampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 102
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 51, let widgetCell = tableView.dequeueReusableCell(withIdentifier: "widgetCell") {
            return widgetCell
        }

        let cell = UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
        if indexPath.row == 0 {
            cell.textLabel?.text = "This example demonstrates when you have to fire 'Opened Widget' and 'Widget Visible'\n\n Be aware of the difference between 'Opened Widget' and 'Widget Visible'\n\n 'Opened Widget': You should fire this when firing the api is done and loading the photo data into your own view for the widget is complete.\n\n'Widget Visible': 'Opened Widget' should be fired first. Then, you can fire this when your own view for the widget started to be visible on the screen.\n\nPlease scroll down to see it in action."
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
        } else if indexPath.row < 51 {
            cell.textLabel?.text = "Before Widget Visible \(indexPath.row)"
            cell.textLabel?.textColor = .green
        } else {
            cell.textLabel?.text = "After Widget Visible \(indexPath.row - 51)"
            cell.textLabel?.textColor = .red
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
