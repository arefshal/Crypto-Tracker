import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published var coinDetails: CoinDetailModel? = nil
    private let coinDetailService = CoinDetailService()
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        addSubscribers(coin: coin)
    }
    
    private func addSubscribers(coin: CoinModel) {
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
            }
            .store(in: &cancellables)
        
        self.coinDetailService.getCoinDetails(coin: coin.id)
    }
    
    func getHomepageURL() -> String? {
        return coinDetails?.links.homepage.first
    }
    
    func getSubredditURL() -> String? {
        return coinDetails?.links.subredditURL
    }
}
