//
//  PXLErrorDTO.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 02. 12..
//

import Foundation
public struct PXLErrorDTO: Codable {
    public let status: Int
    public let message: String
    public let photos: [Int]
}
