//
//  CoinDetailViewModel.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//
import Combine
import Foundation

final class CoinDetailViewModel: ObservableObject {
    // MARK: - Dependencies

    private let dependencies: CoinDetailViewModel.Dependencies
    private let coinId: String

    // MARK: - Variables

    var coinDetail: Models.Core.CoinDetail? = nil

    @Published var state: ViewModelState = .loading

    init(dependencies: Dependencies, coinId: String) {
        self.dependencies = dependencies
        self.coinId = coinId
    }

    // MARK: - Functions

    func fetchCoinDetails() async {
        Task { @MainActor in
            self.state = .loading
        }
        let request = requestForCoin()
        do {
            let result: Models.CoinRank.API.CoinDetailData = try await dependencies.apiClient.send(
                request: request
            )
            let normalizedResult = result.normalize()
            Task { @MainActor in
                self.coinDetail = normalizedResult
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
    
    func networkClient()-> APIClient {
        return self.dependencies.apiClient
    }
    
    func coinIdentifier() -> String {
        return self.coinId
    }
    
    // MARK: - Private functions

    private func requestForCoin() -> some APIRequest {
        let request = CoinDetailViewModel.CoinDetailRequest(
            method: .GET,
            queryParameters: [:],
            coinId: self.coinId
        )
        return request
    }
}

extension CoinDetailViewModel {
    struct Dependencies {
        let apiClient: APIClient
    }
}


extension CoinDetailViewModel {
    struct CoinDetailRequest: APIRequest {
        var method: RequestType
        var queryParameters: [String : String]
        var path: String {
            return "/coin/\(id)"
        }
        private let id: String

        init(method: RequestType, queryParameters: [String : String], coinId: String) {
            self.method = method
            self.queryParameters = queryParameters
            self.id = coinId
        }
    }
}
