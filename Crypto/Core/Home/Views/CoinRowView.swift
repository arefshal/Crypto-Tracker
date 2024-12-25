//
//  CoinRowView.swift
//  Crypto
//
//  Created by Aref on 12/3/24.
//

import SwiftUI

struct CoinRowView: View {
    let coin : CoinModel
    let showHoldingColumn : Bool
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingColumn {
                holdingsColumn
                totalPriceColumn
            } else {
                normalPriceColumn
            }
        }
        .font(.subheadline)
        .contentShape(Rectangle())
        .if(showHoldingColumn) { view in
            view
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        withAnimation {
                            deletePortfolio()
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .contextMenu {
                    Button(role: .destructive) {
                        withAnimation {
                            deletePortfolio()
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        }
    }
    
    private func deletePortfolio() {
        if showHoldingColumn {
            vm.updatePortfolio(coin: coin, amount: 0)
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.sampleCoin, showHoldingColumn: true)
    }
}

extension CoinRowView {
    private var leftColumn : some View {
        HStack(spacing: 0) {
            Text("\(coin.marketCapRank ?? 0 )")
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundStyle(Color.theme.accent)
        }
        .frame(minWidth: 90, alignment: .leading)
    }
    
    private var holdingsColumn: some View {
        VStack(alignment: .trailing) {
            Text("Holdings")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text((coin.currentHoldings ?? 0).asNumberString())
                .bold()
                .foregroundStyle(Color.theme.accent)
        }
        .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
    }
    
    private var totalPriceColumn: some View {
        VStack(alignment: .trailing) {
            Text("Total")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
    private var normalPriceColumn : some View {
        HStack(spacing: 4) {
            VStack(alignment: .trailing) {
                Text(coin.currentPrice.asCurrencyWith2Decimals())
                    .bold()
                    .foregroundStyle(Color.theme.accent)
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            VStack(alignment: .trailing) {
                Text(coin.priceChangePercentage24h?.asPercentString() ?? "")
                    .foregroundStyle(
                        (coin.priceChangePercentage24h ?? 0) >= 0 ?
                        Color.theme.green :
                        Color.theme.red
                    )
            }
            .frame(width: UIScreen.main.bounds.width / 4.5, alignment: .trailing)
        
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
