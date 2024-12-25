//
//  CoinModel.swift
//  Crypto
//
//  Created by Aref on 12/3/24.
//

import Foundation

class CoinModel: Identifiable , Codable{
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double?
    let marketCapRank: Int?
    let totalVolume: Double?
    let high24h: Double?
    let low24h: Double?
    let priceChangePercentage24h: Double?
    let sparklineIn7d: Sparkline?
    let currentHoldings: Double?
    let lastUpdated: String?
    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }
       
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case sparklineIn7d = "sparkline_in_7d"
        case currentHoldings
        case lastUpdated = "last_updated"
    }
    init(id: String, symbol: String, name: String, image: String, currentPrice: Double, marketCap: Double?, marketCapRank: Int?, totalVolume: Double?, high24h: Double?, low24h: Double?, priceChangePercentage24h: Double?, sparklineIn7d: Sparkline?, currentHoldings: Double?, lastUpdated: String?) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.totalVolume = totalVolume
        self.high24h = high24h
        self.low24h = low24h
        self.priceChangePercentage24h = priceChangePercentage24h
        self.sparklineIn7d = sparklineIn7d
        self.currentHoldings = currentHoldings
        self.lastUpdated = lastUpdated
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, totalVolume: totalVolume, high24h: high24h, low24h: low24h, priceChangePercentage24h: priceChangePercentage24h, sparklineIn7d: sparklineIn7d, currentHoldings: amount, lastUpdated: lastUpdated)
    }

    var rank: Int {
        return marketCapRank ?? 0
    }
}

struct Sparkline: Codable {
    let price: [Double]?
}
