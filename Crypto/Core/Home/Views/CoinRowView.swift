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
                centerColumn
            }
            rightColumn

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
        HStack {
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
    }
    
    private var rightColumn  : some View {
        VStack (alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
            Text(coin.priceChangePercentage24h?.asPercentString() ?? "0")
                .foregroundStyle(
                    (
                        coin.priceChangePercentage24h ?? 0
                    ) >= 0 ? Color.theme.green : Color.theme.red
                )
        }
        .foregroundStyle(Color.theme.accent)
        .frame(width: UIScreen.main.bounds.width / 3 ,alignment: .trailing)
    }
    
    private var centerColumn : some View {
        VStack(spacing: 0) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
        .frame(width: UIScreen.main.bounds.width / 3 ,alignment: .trailing)
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
