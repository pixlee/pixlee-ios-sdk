//
//  PXLError.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 02. 12..
//

import Foundation

public class PXLError: LocalizedError {
    public let code: Int
    public let message: String
    public let externalError: Error?
    public init(code: Int, message: String, externalError: Error?) {
        self.code = code
        self.message = message
        self.externalError = externalError
    }

    public var errorMessage: String {
        guard externalError == nil else {
            return "\(message) with external error: \(externalError!.localizedDescription)"
        }
        return message
    }
}
