//
//  DetailView.swift
//  Crypto
//
//  Created by Aref on 12/20/24.
//

import SwiftUI

struct DetailView: View {
    let coin: CoinModel
    @Binding var showDetailView: Bool
    
    var body: some View {
        Text(coin.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showDetailView = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.sampleCoin, showDetailView: .constant(true))
        }
    }
}
