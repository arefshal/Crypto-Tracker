import SwiftUI

struct DetailView: View {
    let coin: CoinModel
    @Binding var showDetailView: Bool
    @StateObject private var vm: DetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel, showDetailView: Binding<Bool>) {
        self.coin = coin
        self._showDetailView = showDetailView
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Chart
                ChartView(coin: coin)
                    .padding(.vertical)
                    .shadow(color: Color.theme.accent.opacity(0.4),
                           radius: 10, x: 0, y: 0)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.background)
                            .shadow(color: Color.theme.accent.opacity(0.2),
                                   radius: 5, x: 0, y: 0)
                    )
                    .padding()
                
                // Overview
                VStack(spacing: 20) {
                    Text("Overview")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    overviewGrid
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .shadow(color: Color.theme.accent.opacity(0.2),
                               radius: 5, x: 0, y: 0)
                )
                .padding(.horizontal)
                
                // Additional Details
                if let description = vm.coinDetails?.description.en {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Description")
                            .font(.title)
                            .bold()
                            .foregroundStyle(Color.theme.accent)
                        
                        Text(description)
                            .font(.callout)
                            .foregroundStyle(Color.theme.secondaryText)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.background)
                            .shadow(color: Color.theme.accent.opacity(0.2),
                                   radius: 5, x: 0, y: 0)
                    )
                    .padding(.horizontal)
                }
                
                // Links
                linksSection
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.background)
                            .shadow(color: Color.theme.accent.opacity(0.2),
                                   radius: 5, x: 0, y: 0)
                    )
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DetailView {
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            DetailGridItem(
                title: "Current Price",
                value: coin.currentPrice.asCurrencyWith6Decimals(),
                percentageChange: coin.priceChangePercentage24h
            )
            
            DetailGridItem(
                title: "Market Cap Rank",
                value: "\(coin.rank)"
            )
            
            DetailGridItem(
                title: "Market Cap",
                value: coin.marketCap?.formattedWithAbbreviations() ?? "N/A"
            )
            
            DetailGridItem(
                title: "Volume",
                value: coin.totalVolume?.formattedWithAbbreviations() ?? "N/A"
            )
            
            if let algorithm = vm.coinDetails?.hashingAlgorithm {
                DetailGridItem(
                    title: "Algorithm",
                    value: algorithm
                )
            }
        }
    }
    
    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Links")
                .font(.title)
                .bold()
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            if let website = vm.getHomepageURL(),
               let url = URL(string: website) {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                        Text("Website")
                    }
                    .font(.headline)
                }
                .tint(Color.theme.accent)
            }
            
            if let redditURL = vm.getSubredditURL(),
               let url = URL(string: redditURL) {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Image(systemName: "message.fill")
                        Text("Reddit")
                    }
                    .font(.headline)
                }
                .tint(Color.theme.accent)
            }
        }
    }
}
