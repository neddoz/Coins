//
//  CoinsListViewModelTests.swift
//  Coins
//
//  Created by kayeli dennis on 07/03/2025.
//
import Testing
@testable import Coins
import SwiftData

@Suite("CoinsListViewModelTests")
class CoinsListViewModelTests {

    @Test func decodesSuccessfully() async {
        let sut: CoinsListViewModel = .init(
            dependencies: CoinsListViewModel.Dependencies(
                apiClient: mockAPIClient, container: sharedModelContainer
            )
        )
        #expect(sut.state == ViewModelState.loading)
        #expect(sut.showFilter == false)
        #expect(sut.totalCoins == 0)
        #expect(sut.preselectedFilterIndex == 0)
        #expect(sut.numberOfItems() == 0)

        await sut.fetchCoins()
        Task { @MainActor in
            #expect(sut.state == .none)
            #expect(sut.numberOfItems() == 50)
            let item = sut.item(at: 0)
            #expect(item.symbol == "BTC")
            #expect(item.name == "Bitcoin")
            #expect(item.rank == 1)
            #expect(item.change == "-4.72")
        }
    }

    private let mockAPIClient: APIClient = {
        return CoinsListViewModelTests.MockAPIClient()
    }()

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

extension CoinsListViewModelTests {
    struct MockAPIClient: APIClient {
        func send<T>(
            request: any APIRequest
        ) async throws -> T where T : Decodable, T : Encodable {
            guard
                let item = Models.CoinRank.API.CoinResponse.mocked() as? T
            else {fatalError("Type is not mockable")}
            return item
        }
    }
}
