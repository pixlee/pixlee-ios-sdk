//
//  PXLProduct.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation
import UIKit
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
    public let salesPrice: Double?
    public let salesStartDate: Date?
    public let salesEndDate: Date?

    static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        return formatter
    }()

    public var formattedPrice: String? {
        guard let currency = currency, let price = price, let formattedPrice = PXLProduct.currencyFormatter.string(from: NSNumber(value: price)) else { return nil }
        return "\(currency) \(formattedPrice)"
    }

    private func getDiscountPercentage() -> Int? {
        guard let salesPrice = salesPrice, let price = price else {return nil}
        return Int(((1.0 - (salesPrice / price)) * 100.0).rounded())
    }

    public func getAttributedPrice(discountPrice: DiscountPrice?) -> NSAttributedString? {
        guard let price = price else { return nil }

        let largeFontSize = CGFloat(18)
        let middleFontSize = CGFloat(14)
        let smallFontSize = CGFloat(12)
        let defaultColor = UIColor.darkText
        let salesColor = UIColor.red
        let disabledColor = UIColor.darkText.withAlphaComponent(0.5)

        let mutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 7, weight: .bold)])

        // Sales Price UI
        let availableSalesPrice = hasAvailableSalesPrice()
        if let discountPrice = discountPrice, availableSalesPrice {
            let priceStrings = getAttributedString(discountPrice: discountPrice, price: salesPrice,
                    integerAttributs: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: largeFontSize, weight: .bold), NSAttributedString.Key.foregroundColor: salesColor],
                    decimalAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallFontSize, weight: .bold), NSAttributedString.Key.foregroundColor: salesColor])
            for priceString in priceStrings {
                mutableAttributedString.append(priceString)
            }

            mutableAttributedString.append(NSAttributedString(string: " ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: largeFontSize, weight: .bold)]))
        }

        // Default Price UI
        var priceStrings: [NSAttributedString]
        if availableSalesPrice, let discountPrice = discountPrice {
            let disabledAttributedString:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: middleFontSize, weight: .bold), NSAttributedString.Key.foregroundColor: disabledColor]
            let disabledAttributedStringWithUnderline:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: middleFontSize, weight: .bold), NSAttributedString.Key.foregroundColor: disabledColor, NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: disabledColor]
            switch (discountPrice.discountLayout) {
            case .CROSS_THROUGH:
                priceStrings = getAttributedString(discountPrice: discountPrice,
                        price: price,
                        integerAttributs: disabledAttributedStringWithUnderline,
                        decimalAttributes: disabledAttributedStringWithUnderline)
            case .WAS_OLD_PRICE:
                priceStrings = getAttributedString(discountPrice: discountPrice,
                        price: price,
                        integerAttributs: disabledAttributedString,
                        decimalAttributes: disabledAttributedString, formattedString: MultiLanguage.getWasOldPrice()) // percent off UI
            case .WITH_DISCOUNT_LABEL:
                if let discountPercentage = getDiscountPercentage() {
                    priceStrings = getAttributedString(discountPrice: discountPrice,
                            price: price,
                            integerAttributs: disabledAttributedStringWithUnderline,
                            decimalAttributes: disabledAttributedStringWithUnderline)
                    priceStrings.append(NSAttributedString(string: String(format:MultiLanguage.getPercentOff(), "\n\(discountPercentage)"),
                            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: middleFontSize, weight: .regular), NSAttributedString.Key.foregroundColor: salesColor]))
                } else {
                    priceStrings = getAttributedString(discountPrice: discountPrice,
                            price: price,
                            integerAttributs: disabledAttributedString,
                            decimalAttributes: disabledAttributedString)
                }
            }
        } else {
            priceStrings = getAttributedString(discountPrice: discountPrice,
                    price: price,
                    integerAttributs: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: largeFontSize, weight: .bold), NSAttributedString.Key.foregroundColor: defaultColor],
                    decimalAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallFontSize, weight: .bold), NSAttributedString.Key.foregroundColor: defaultColor])
        }
        for priceString in priceStrings {
            mutableAttributedString.append(priceString)
        }

        return mutableAttributedString
    }

    private func getAttributedString(discountPrice: DiscountPrice?, price:Double?, integerAttributs: [NSAttributedString.Key : Any], decimalAttributes:[NSAttributedString.Key : Any], formattedString: String? = nil) -> [NSAttributedString] {
        guard let price = price else {
            return []
        }

        let isCurrencyLeading = discountPrice?.isCurrencyLeading ?? false
        let doubleAsString = String(price);
        var integerString: String.SubSequence = doubleAsString[...]
        var decimalString: String.SubSequence? = nil
        if let indexOfDecimal = doubleAsString.firstIndex(of: ".") {
            integerString = doubleAsString[..<indexOfDecimal]
            decimalString = doubleAsString[indexOfDecimal...]
        }

        var nsAttributedStrings:[NSAttributedString] = []
        var leadingSymbol = isCurrencyLeading ? (currencySymbol ?? "") : ""
        var trailingSymbol = isCurrencyLeading ? "" : (currencySymbol ?? "")
        if let decimalPrice = decimalString {
            if let formattedString = formattedString {
                nsAttributedStrings.append(NSAttributedString(string: String(format: formattedString, "\(leadingSymbol)\(integerString)\(decimalPrice)\(trailingSymbol)"), attributes: integerAttributs))
            }else {
                nsAttributedStrings.append(NSAttributedString(string: "\(leadingSymbol)\(integerString)", attributes: integerAttributs))
                nsAttributedStrings.append(NSAttributedString(string: "\(decimalPrice)\(trailingSymbol)", attributes: decimalAttributes))
            }
        }else {
            if let formattedString = formattedString {
                nsAttributedStrings.append(NSAttributedString(string: String(format: formattedString, "\(leadingSymbol)\(integerString)\(trailingSymbol)"), attributes: integerAttributs))
            } else {
                nsAttributedStrings.append(NSAttributedString(string: "\(leadingSymbol)\(integerString)\(trailingSymbol)", attributes: integerAttributs))
            }
        }
        return nsAttributedStrings
    }

    private func hasAvailableSalesPrice() -> Bool {
        // we show price if the displayOptions has productPrice true, and the product actually has an actual price > 0
        var salesPriceLessThanStandard = false
        if let price = price, let salesPrice = salesPrice, price > salesPrice{
            salesPriceLessThanStandard = true
        }

        let today = Date();
        // Assume by default its true, because more often than naught, its more likely we dont get the start or end date atm
        var isWithinSalesDateRange = true;

        if let salesStartDate = salesStartDate, salesEndDate == nil {
            isWithinSalesDateRange = salesStartDate <= today;
        } else if salesStartDate == nil, let salesEndDate = salesEndDate {
            isWithinSalesDateRange = salesEndDate >= today;
        } else if let salesStartDate = salesStartDate, let salesEndDate = salesEndDate {
            isWithinSalesDateRange = salesStartDate <= today && salesEndDate >= today;
        }

        return salesPriceLessThanStandard && isWithinSalesDateRange;
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
