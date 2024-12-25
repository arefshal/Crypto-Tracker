//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Aref on 12/4/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var statistics: [StatisticsModel] = []
    @Published var isLoading: Bool = false
    @Published var showLottieAnimation: Bool = false
    @Published var sortOption: SortOption = .rank
    
    private let dataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    let lottieURL = "https://cdn.lottielab.com/l/AqzWjtHKzqpjY1.json"
    
    enum SortOption {
        case rank, price, priceChange, holdings
    }
    
    var sortedFilteredCoins: [CoinModel] {
        let filteredCoins = filterCoins(text: searchText, coins: allCoins)
        return sortCoins(coins: filteredCoins)
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // Updates allCoins
        $searchText
            .combineLatest(dataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { [weak self] (text, startingCoins, sortOption) -> [CoinModel] in
                let filteredCoins = self?.filterCoins(text: text, coins: startingCoins) ?? []
                return self?.sortCoins(coins: filteredCoins) ?? []
            }
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities, $sortOption)
            .map { [weak self] (coinModels, portfolioEntities, sortOption) -> [CoinModel] in
                let portfolioCoins = coinModels
                    .compactMap { coin -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
                return self?.sortCoins(coins: portfolioCoins) ?? []
            }
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // Updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map { (marketDataModel, portfolioCoins) -> [StatisticsModel] in
                var stats: [StatisticsModel] = []
                
                guard let data = marketDataModel else {
                    return stats
                }
                
                let marketCap = StatisticsModel(
                    title: "Market Cap",
                    value: data.marketCap,
                    percentageChange: data.marketCapChangePercentage24hUsd
                )
                
                let volume = StatisticsModel(
                    title: "24h Volume",
                    value: data.volume
                )
                
                let btcDominance = StatisticsModel(
                    title: "BTC Dominance",
                    value: data.btcDominance
                )
                
                let portfolioValue = portfolioCoins
                    .map { $0.currentHoldingsValue }
                    .reduce(0, +)
                
                let previousValue = portfolioCoins
                    .map { coin -> Double in
                        let currentValue = coin.currentHoldingsValue
                        let percentChange = (coin.priceChangePercentage24h ?? 0) / 100
                        let previousValue = currentValue / (1 + percentChange)
                        return previousValue
                    }
                    .reduce(0, +)
                
                let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
                
                let portfolio = StatisticsModel(
                    title: "Portfolio Value",
                    value: portfolioValue.asCurrencyWith2Decimals(),
                    percentageChange: percentageChange
                )
                
                stats.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                return stats
            }
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .rank:
            return coins.sorted(by: { (coin1: CoinModel, coin2: CoinModel) -> Bool in
                return coin1.rank < coin2.rank
            })
        case .price:
            return coins.sorted(by: { (coin1: CoinModel, coin2: CoinModel) -> Bool in
                return coin1.currentPrice > coin2.currentPrice
            })
        case .priceChange:
            return coins.sorted(by: { (coin1: CoinModel, coin2: CoinModel) -> Bool in
                return (coin1.priceChangePercentage24h ?? 0) > (coin2.priceChangePercentage24h ?? 0)
            })
        case .holdings:
            return coins.sorted(by: { (coin1: CoinModel, coin2: CoinModel) -> Bool in
                return coin1.currentHoldingsValue > coin2.currentHoldingsValue
            })
        }
    }
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .rank:
            return coins
        case .price:
            return coins.sorted(by: { (coin1: CoinModel, coin2: CoinModel) -> Bool in
                return coin1.currentPrice > coin2.currentPrice
            })
        case .priceChange:
            return coins.sorted(by: { (coin1: CoinModel, coin2: CoinModel) -> Bool in
                return (coin1.priceChangePercentage24h ?? 0) > (coin2.priceChangePercentage24h ?? 0)
            })
        case .holdings:
            return coins.sorted(by: { (coin1: CoinModel, coin2: CoinModel) -> Bool in
                return coin1.currentHoldingsValue > coin2.currentHoldingsValue
            })
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() async {
        showLottieAnimation = true
        
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            await dataService.getCoins()
            await marketDataService.getData()
        } catch {
            print("Error during refresh: \(error)")
        }
        
        showLottieAnimation = false
    }
    
}
