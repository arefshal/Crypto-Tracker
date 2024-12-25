//
//  HomeView.swift
//  Crypto
//
//  Created by Aref on 12/2/24.
//

import SwiftUI
import Lottie

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var selectedCoin: CoinModel?
    @State private var showDetailView: Bool = false

    var body: some View {
        ZStack {
            // Background
            Color.theme.background
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }

            // Content
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitle

                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showPortfolioView) {
                NavigationView {
                    PortfolioView()
                        .environmentObject(vm)
                }
            }
            .navigationDestination(isPresented: $showDetailView) {
                if let coin = selectedCoin {
                    DetailView(coin: coin, showDetailView: $showDetailView)
                }
            }
        }
    }
}



// MARK: - Components
extension HomeView {

    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }

            Spacer()

            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)

            Spacer()

            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var allCoinsList: some View {
        ZStack {
            List {
                if vm.isLoading {
                    HStack {
                        Spacer()
                        LottieLoadingView(animationName: "Artboard 1", loopMode: .loop)
                            .frame(width: 100, height: 100)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                ForEach(vm.allCoins) { coin in
                    CoinRowView(coin: coin, showHoldingColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .listRowBackground(Color.theme.background)
                        .onTapGesture {
                            selectedCoin = coin
                            showDetailView.toggle()
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                vm.showLottieAnimation = true
                await vm.reloadData()
                vm.showLottieAnimation = false
            }
            
            if vm.showLottieAnimation {
                LottieLoadingView(animationName: "Artboard 1", loopMode: .loop)
                    .frame(width: 100, height: 100)
            }
        }
    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.theme.background)
                    .onTapGesture {
                        selectedCoin = coin
                        showDetailView.toggle()
                    }
            }
        }
        .listStyle(PlainListStyle())
    }

    private var columnTitle: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.default) {
                    vm.sortOption = .rank
                }
            } label: {
                HStack(spacing: 4) {
                    Text("Coin")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .rank ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
                }
            }
            .frame(minWidth: 90, alignment: .leading)
            .foregroundStyle(vm.sortOption == .rank ? Color.theme.accent : Color.theme.secondaryText)

            Spacer()

            if showPortfolio {
                Text("Holdings")
                    .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
                    .foregroundStyle(Color.theme.secondaryText)

                Button {
                    withAnimation(.default) {
                        vm.sortOption = .holdings
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Total")
                        Image(systemName: "chevron.down")
                            .opacity(vm.sortOption == .holdings ? 1.0 : 0.0)
                            .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                .foregroundStyle(vm.sortOption == .holdings ? Color.theme.accent : Color.theme.secondaryText)
            } else {
                Button {
                    withAnimation(.default) {
                        vm.sortOption = .price
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Price")
                        Image(systemName: "chevron.down")
                            .opacity(vm.sortOption == .price ? 1.0 : 0.0)
                            .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                .foregroundStyle(vm.sortOption == .price ? Color.theme.accent : Color.theme.secondaryText)

                Button {
                    withAnimation(.default) {
                        vm.sortOption = .priceChange
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("24h")
                        Image(systemName: "chevron.down")
                            .opacity(vm.sortOption == .priceChange ? 1.0 : 0.0)
                            .rotationEffect(Angle(degrees: vm.sortOption == .priceChange ? 0 : 180))
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 4.5, alignment: .trailing)
                .foregroundStyle(vm.sortOption == .priceChange ? Color.theme.accent : Color.theme.secondaryText)
            }
        }
        .font(.caption)
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
                .environmentObject(HomeViewModel())
        }
    }
}
