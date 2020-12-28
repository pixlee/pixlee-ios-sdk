//
//  PixleeCredentials.swift
//  Example
//
//  Created by Sungjun Hong on 12/7/20.
//  Copyright © 2020 Pixlee. All rights reserved.
//

import Foundation

struct PixleeCredentials {
    enum ValidationError: Error {
        case noFile(_ error: String)
        case cantRead(_ error: String)
    }
    
    static func create() throws -> PixleeCredentials {
        var pixleeCredentials = PixleeCredentials()
        if let url = Bundle.main.url(forResource:"PixleeCredentials", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                // do something with the dictionary
                pixleeCredentials.apiKey = swiftDictionary["PIXLEE_API_KEY"] as? String
                pixleeCredentials.secretKey = swiftDictionary["PIXLEE_SECRET_KEY"] as? String
                pixleeCredentials.albumId = swiftDictionary["PIXLEE_ALBUM_ID"] as? String
                if swiftDictionary["PIXLEE_REGION_ID"] != nil{
                    if let regionId = swiftDictionary["PIXLEE_REGION_ID"] as? String {
                        pixleeCredentials.regionId = Int(regionId)
                    } else if let regionId =  swiftDictionary["PIXLEE_REGION_ID"] as? Int {
                        pixleeCredentials.regionId = regionId
                    }
                }
                
                
                print("swiftDictionary: \(swiftDictionary)")
                
            } catch {
                let message = "can't read Example/PixleeCredentials.plist \(error)"
                throw ValidationError.cantRead(message)
            }
        }else{
            // todo: show alert
            let message = "can't run the demo. please add Example/PixleeCredentials.plist to this project and run it again"
            throw ValidationError.noFile(message)
        }
        
        return pixleeCredentials
    }
    var apiKey:String?
    var secretKey:String?
    var albumId:String?
    var regionId:Int?
}
