//
//  PXLPlainErrorDTO.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 02. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

public struct PXLPlainErrorDTO: Codable {
    let error: String
    let status: String?
}
