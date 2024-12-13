//
//  MarketDataModel.swift
//  Crypto
//
//  Created by Aref on 12/10/24.
//

import Foundation


import Foundation

struct GlobalData: Codable {
    let data: MarketDataModel
}

struct MarketDataModel: Codable {
    let activeCryptocurrencies: Int
    let upcomingIcos: Int
    let ongoingIcos: Int
    let endedIcos: Int
    let markets: Int
    let totalMarketCap: [String: Double]
    let totalVolume: [String: Double]
    let marketCapPercentage: [String: Double]
    let marketCapChangePercentage24hUsd: Double
    let updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case upcomingIcos = "upcoming_icos"
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24hUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }

    
    var marketCap: String {
        if let item = totalMarketCap["usd"] {
            return "$\(item.formattedWithAbbreviations())"
        }
        return "$0.00"
    }

    
    var volume: String {
        if let item = totalVolume["usd"] {
            return "$\(item.formattedWithAbbreviations())"
        }
        return "$0.00"
    }

   
    var btcDominance: String {
        if let item = marketCapPercentage["btc"] {
            return item.asPercentString()
        }
        return "0.00%"
    }
}
