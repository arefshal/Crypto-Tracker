//
//  PreviewProvider.swift
//  Crypto
//
//  Created by Aref on 12/3/24.
//

import Foundation
import SwiftUI
extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}
class DeveloperPreview {
    
    let homeVm = HomeViewModel()
    let coin = CoinModel(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
            currentPrice: 50000,
            marketCap: 1000000,
            marketCapRank: 1,
            totalVolume: 10000,
            high24h: 51000,
            low24h: 49000,
            priceChangePercentage24h: 2.5,
            sparklineIn7d: nil,
            currentHoldings: 2.0, lastUpdated: ""
        )
    let sampleCoin = CoinModel(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
            currentPrice: 50000,
            marketCap: 1000000,
            marketCapRank: 1,
            totalVolume: 10000,
            high24h: 51000,
            low24h: 49000,
            priceChangePercentage24h: 2.5,
            sparklineIn7d: nil,
            currentHoldings: 2.0, lastUpdated: ""
        )
    let sampleStat = StatisticsModel(title: "marketgap", value: "2.1B ", percentageChange: -1.2)
    
    static let instance = DeveloperPreview()
    private init() {
        
    }
}
 
