//
//  CoinDetailView.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//
import SwiftUI
import Charts

struct CoinDetailView: View {
    @ObservedObject var viewModel: CoinDetailViewModel
    var body: some View {
        VStack {
            if viewModel.state == .loading {
                ProgressView()
            } else if case let .error(message) = viewModel.state {
                Text("\(message)")
            } else if let detail = viewModel.coinDetail {
                VStack(alignment: .leading, spacing: 16) {
                    Text(detail.name)
                        .font(.title)
                    Text("Price: \(detail.symbol)\(detail.price)")
                        .font(.headline)
                    Text("Price Trend")
                        .font(.subheadline)

                    /// Coin Chart

                    let coinChartViewModelDependencies = CoinChartViewModel.Dependencies(
                        apiClient: viewModel.networkClient()
                    )
                    let coinChartViewModel = CoinChartViewModel(
                        dependencies: coinChartViewModelDependencies,
                        coinId: viewModel.coinIdentifier()
                    )

                    CoinChartView(viewModel: coinChartViewModel)
                    Spacer()
                }
                .padding()
                .navigationTitle(detail.symbol)
            }
        }.task {
            await viewModel.fetchCoinDetails()
        }
    }
}

#Preview {
    let viewModel = CoinDetailViewModel(
        dependencies: .init(apiClient: NetworkClient()),
        coinId: "bitcoin"
    )
    CoinDetailView(viewModel: viewModel)
}



