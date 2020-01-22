//
//  PXLAnalyitcsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit
protocol PXLAnalyticsEvent {
    var eventName: String {get}
    var logParameters: [String: Any] { get }
}
