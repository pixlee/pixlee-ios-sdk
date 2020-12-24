//
//  PXLProduct.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

public struct PXLProduct {
    public let identifier: Int
    public let linkText: String?
    public let link: URL?
    public let imageUrl: URL?
    public let imageThumbUrl: URL?
    public let imageThumbSquareUrl: URL?
    public let title: String?
    public let sku: String?
    public let productDescription: String?
    public let price: Double?
    public let currency: String?

    static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        return formatter
    }()

    public var formattedPrice: String? {
        guard let currency = currency, let price = price, let formattedPrice = PXLProduct.currencyFormatter.string(from: NSNumber(value: price)) else { return "" }
        return "\(currency) \(formattedPrice)"
    }

    public var attributedPrice: NSAttributedString? {
        print("currency: \(currency), currencySymbol: \(currencySymbol), PXLProduct.currencyFormatter: \(PXLProduct.currencyFormatter)")
        
        if let price = price, let decimalSeparator = PXLProduct.currencyFormatter.decimalSeparator  {
            let doubleAsString = String(price);
            
            var mainPrice: String.SubSequence = doubleAsString[...]
            var decimalPrice: String.SubSequence? = nil
            if let indexOfDecimal = doubleAsString.firstIndex(of: ".") {
                mainPrice = doubleAsString[..<indexOfDecimal]
                decimalPrice = doubleAsString[indexOfDecimal...]
            }
            
            let priceString = "\(mainPrice)"
            let mutableAttributedString = NSMutableAttributedString(string: priceString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
            
            var secondPhase = " \(currencySymbol ?? "")"
            if let decimalPrice = decimalPrice {
                secondPhase = "\(decimalSeparator)\(decimalPrice) \(currencySymbol ?? "")"
            }
            
            let currencyString = NSAttributedString(string: secondPhase, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
            mutableAttributedString.append(currencyString)
            
            return mutableAttributedString
        }
        
        return NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
    }

    public var currencySymbol: String? {
        switch currency {
        case "EUR": return "€"
        case "USD": return "$"
        case "GBP": return "£"
        case "CZK": return "Kč"
        case "TRY": return "₺"
        case "AED": return "د.إ"
        case "AFN": return "؋"
        case "ARS": return "$"
        case "AUD": return "$"
        case "BBD": return "$"
        case "BDT": return " Tk"
        case "BGN": return "лв"
        case "BHD": return "BD"
        case "BMD": return "$"
        case "BND": return "$"
        case "BOB": return "$b"
        case "BRL": return "R$"
        case "BTN": return "Nu."
        case "BZD": return "BZ$"
        case "CAD": return "$"
        case "CHF": return "CHF"
        case "CLP": return "$"
        case "CNY": return "¥"
        case "COP": return "$"
        case "CRC": return "₡"
        case "DKK": return "kr"
        case "DOP": return "RD$"
        case "EGP": return "£"
        case "ETB": return "Br"
        case "GEL": return "₾"
        case "GHS": return "¢"
        case "GMD": return "D"
        case "GYD": return "$"
        case "HKD": return "$"
        case "HRK": return "kn"
        case "HUF": return "Ft"
        case "IDR": return "Rp"
        case "ILS": return "₪"
        case "INR": return "₹"
        case "ISK": return "kr"
        case "JMD": return "J$"
        case "JPY": return "¥"
        case "KES": return "KSh"
        case "KRW": return "₩"
        case "KWD": return "د.ك"
        case "KYD": return "$"
        case "KZT": return "лв"
        case "LAK": return "₭"
        case "LKR": return "₨"
        case "LRD": return "$"
        case "LTL": return "Lt"
        case "MAD": return "MAD"
        case "MDL": return "MDL"
        case "MKD": return "ден"
        case "MNT": return "₮"
        case "MUR": return "₨"
        case "MWK": return "MK"
        case "MXN": return "$"
        case "MYR": return "RM"
        case "MZN": return "MT"
        case "NAD": return "$"
        case "NGN": return "₦"
        case "NIO": return "C$"
        case "NOK": return "kr"
        case "NPR": return "₨"
        case "NZD": return "$"
        case "OMR": return "﷼"
        case "PEN": return "S/."
        case "PGK": return "K"
        case "PHP": return "₱"
        case "PKR": return "₨"
        case "PLN": return "zł"
        case "PYG": return "Gs"
        case "QAR": return "﷼"
        case "RON": return "lei"
        case "RSD": return "Дин."
        case "RUB": return "₽"
        case "SAR": return "﷼"
        case "SEK": return "kr"
        case "SGD": return "$"
        case "SOS": return "S"
        case "SRD": return "$"
        case "THB": return "฿"
        case "TTD": return "TT$"
        case "TWD": return "NT$"
        case "TZS": return "TSh"
        case "UAH": return "₴"
        case "UGX": return "USh"
        case "UYU": return "$U"
        case "VEF": return "Bs"
        case "VND": return "₫"
        case "YER": return "﷼"
        case "ZAR": return "R"
        default: return currency
        }
    }
}
