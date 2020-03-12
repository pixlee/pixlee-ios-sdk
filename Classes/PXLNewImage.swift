//
//  PXLNewImage.swift
//  Alamofire
//
//  Created by Csaba Toth on 2020. 03. 06..
//

import Foundation
import UIKit

public struct PXLNewImage {
    // Example data from the documentation
    //    {
    //      "album_id": 9996319, //Required
    //      "title": "something something danger zone", //Required
    //      "email": "dennis@pixleeteam.com", //Required
    //      "username": "Dennis", //Required
    //      "approved": true, //Required
    //      "connected_user_id": 123456789, //optional, not used if email is included,
    //      "product_skus": ["productA", "productB"], //optional, for adding product tags
    //      "connected_user": {"shirt_size": "M"} //optional, for storing additional misc info
    //    }

    public let image: UIImage
    public let albumId: Int
    public let title: String
    public let email: String
    public let username: String
    public let approved: Bool
    public let connectedUserId: Int?
    public let productSKUs: [String]?
    public let connectedUser: [String: Any]?

    public var parameters: [String: Any] {
        var parameters = [
            "album_id": self.albumId,
            "title": self.title,
            "email": self.email,
            "username": self.username,
            "approved": self.approved,
        ] as [String: Any]

        if let connectedUserId = self.connectedUserId {
            parameters["connected_user_id"] = connectedUserId
        }

        if let productSKUs = self.productSKUs {
            parameters["product_skus"] = productSKUs
        }

        if let connectedUser = self.connectedUser {
            parameters["connected_user"] = connectedUser
        }
        return parameters
    }
}
