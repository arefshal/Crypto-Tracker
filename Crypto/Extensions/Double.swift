//
//  Double.swift
//  Crypto
//
//  Created by Aref on 12/4/24.
//

import Foundation
 
extension Double {
    private var currencyFormater : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 2
        return formatter
    }

    private var currencyFormater6 : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }

    func asCurrencyWith2Decimals() -> String {
            let number = NSNumber(value: self)
            return currencyFormater.string(from: number) ?? "$0.00"
        }
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormater6.string(from: number) ?? "$0.00"
    }
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    func formattedWithAbbreviations() -> String {
        let num = abs(self)
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...:
            return "\(sign)\(String(format: "%.1f", num / 1_000_000_000_000))T"
        case 1_000_000_000...:
            return "\(sign)\(String(format: "%.1f", num / 1_000_000_000))B"
        case 1_000_000...:
            return "\(sign)\(String(format: "%.1f", num / 1_000_000))M"
        case 1_000...:
            return "\(sign)\(String(format: "%.1f", num / 1_000))K"
        default:
            return "\(sign)\(String(format: "%.2f", num))"
        }
    }
}
