//
//  CoinsListViewModel.swift
//  Coins
//
//  Created by kayeli dennis on 02/03/2025.
//
import SwiftUI
import SwiftData

/// Object that contains the business logic for the coins list view.

final class CoinsListViewModel: Observable {

    // MARK: - Public readable accessible variables

    @Published var state: ViewModelState = .loading
    @Published var showFilter: Bool = false

    var totalCoins: Int {
        return stats?.total ?? 0
    }
    var preselectedFilterIndex: Int {
        return Models.CoinRank.API.Coin.Filter.allCases.firstIndex(of: currentFilter) ?? 0
    }
    private var offset = 0
    private var currentFilter: Models.CoinRank.API.Coin.Filter = .best24HourPerformance
    private let limit = 20
    var shouldFetchMore = true

    // MARK: - Initializer

    /// Initializes a `CoinsListViewModel` instance
    /// - Parameter dependencies: `Dependencies` struct needed by the viewModel
    init (dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Public functions
    
    func updateFilterAndRefresh(_ filter: Models.CoinRank.API.Coin.Filter) {
        self.resetData()
        self.currentFilter = filter
        Task {
            await self.fetchCoins()
        }
    }

    func fetchCoins() async {
        self.state = .loading
        let request = requestForCoins()
        do {
            let result: Models.CoinRank.API.CoinResponse = try await dependencies.apiClient.send(
                request: request
            )
            let normalizedResult = result.normalize()
            Task { @MainActor in
                self.items.append(
                    contentsOf: normalizedResult.coins
                )
                self.offset += limit // 20 is the offset limit
                self.shouldFetchMore = !normalizedResult.coins.isEmpty
                self.stats = normalizedResult.stats
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
    
    @MainActor func addToFavourite(item at: Int) {
        let itemToAdd = self.items[at]
        let item = FavouriteItem.init(
            timestamp: Date(),
            id: itemToAdd.id,
            name: itemToAdd.name,
            symbol: itemToAdd.symbol,
            price: itemToAdd.price,
            change: itemToAdd.change,
            rank: itemToAdd.rank,
            color: itemToAdd.color,
            iconUrl: itemToAdd.iconUrl
        )
        self.dependencies.container.mainContext.insert(item)
    }

    func networkClient() -> APIClient {
        return dependencies.apiClient
    }

    // MARK: - Private functions

    private func requestForCoins() -> some APIRequest {
        let request = CoinsListViewModel.CoinsRequest(
            method: .GET,
            queryParameters: [
                "limit": "\(limit)",
                "offset": "\(offset)",
                "orderBy": "\(currentFilter.rawValue)",
                "orderDirection": "desc"
            ]
        )
        return request
    }
    
    private func resetData() {
        self.items.removeAll()
        self.offset = 0
    }

    // MARK: - Private Variables

    /// The coins to be shown in the view
    private var items: [Models.Core.Coin] = []
    
    private var stats: Models.Core.Stats? = nil

    /// Dependencies struct that has Apiclient instance.
    private var dependencies: Dependencies
}

// MARK: - CoinsDataSource Method

extension CoinsListViewModel {
    func numberOfItems() -> Int {
        return items.count
    }

    func item(at index: Int) -> Models.Core.Coin {
        return items[index]
    }
}

extension CoinsListViewModel {
    struct Dependencies {
        let apiClient: APIClient
        let container: ModelContainer
    }

    struct CoinsRequest: APIRequest {
        var method: RequestType
        var queryParameters: [String : String]
        var path: String {
            return "/coins"
        }

        init(method: RequestType, queryParameters: [String : String]) {
            self.method = method
            self.queryParameters = queryParameters
        }
    }
}

extension Models.CoinRank.API.Coin.Filter {
    func title() -> String {
        switch self {
        case .best24HourPerformance:
            "Ordered by best 24-hour performance"
        case .highestPrice:
            "Ordered by highest price"
        }
    }
}


