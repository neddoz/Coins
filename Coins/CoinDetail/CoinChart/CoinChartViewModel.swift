//
//  CoinChartViewModel.swift
//  Coins
//
//  Created by kayeli dennis on 06/03/2025.
//
import Combine
import Foundation

final class CoinChartViewModel: ObservableObject {

    // MARK: - Variables
    var coinHistory: [Models.Core.Coin.History]? = nil
    @Published var state: ViewModelState = .loading
    var currentTrendPeriod: Models.CoinRank.API.Coin.TrendPeriod = .twentyFourHours

    private let dependencies: CoinChartViewModel.Dependencies
    private let coinId: String

    init(dependencies: Dependencies, coinId: String) {
        self.dependencies = dependencies
        self.coinId = coinId
    }

    func fetchCoinHistory() async {
        Task { @MainActor in
            self.state = .loading
        }
        let request = self.requestForCoinHistory()
        
        do {
            let result: Models.CoinRank.API.Coin.History = try await self.dependencies.apiClient.send(request: request)
            let  normalizedResult = result.normalize()
            Task { @MainActor in
                self.coinHistory = normalizedResult
                self.state = .none
            }
        } catch {
            Task { @MainActor in
                if let error = error as? NetworkError {
                    self.state = .error(
                        error.errorMessage()
                    )
                } else {
                    self.state = .error(
                        error.localizedDescription
                    )
                }
            }
        }
    }
    
    func pricePoints() -> [Models.Core.PricePoint] {
        guard let items = coinHistory else {return []}
        return items.compactMap { point in
            if let price = Double(point.price ?? "")  {
                return Models.Core.PricePoint(
                    timestamp: Date(
                        timeIntervalSince1970: Double(point.timestamp)
                    ),
                    price: price
                )
            }
            return nil
        }
    }
    
    func updateTrendPeriod(_ trendPeriod: Models.CoinRank.API.Coin.TrendPeriod) {
        self.resetData()
        self.currentTrendPeriod = trendPeriod
        Task {
            await self.fetchCoinHistory()
        }
    }
    
    func resetData() {
        self.coinHistory = nil
    }

    // MARK: - Private functions

    private func requestForCoinHistory() -> some APIRequest {
        let request = CoinChartViewModel.CoinHistoryRequest(
            method: .GET,
            queryParameters: ["timePeriod": currentTrendPeriod.rawValue],
            coinId: self.coinId
        )
        return request
    }
    
}

extension CoinChartViewModel {
    struct Dependencies {
        let apiClient: APIClient
    }
}

extension CoinChartViewModel {
    struct CoinHistoryRequest: APIRequest {
        var method: RequestType
        var queryParameters: [String : String]
        var path: String {
            return "/coin/\(id)/history"
        }
        private let id: String

        init(method: RequestType, queryParameters: [String : String], coinId: String) {
            self.method = method
            self.queryParameters = queryParameters
            self.id = coinId
        }
    }
}
