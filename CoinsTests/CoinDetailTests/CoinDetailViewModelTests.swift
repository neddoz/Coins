//
//  CoinDetailViewModelTests.swift
//  Coins
//
//  Created by kayeli dennis on 06/03/2025.
//
import Testing
@testable import Coins

@Suite("CoinDetailViewModelTests")
class CoinDetailViewModelTests {
    let mockAPIClient: APIClient = {
        return CoinDetailViewModelTests.MockAPIClient()
    }()

    @Test func decodesSuccessfully() async {
        let sut: CoinDetailViewModel = .init(
            dependencies: CoinDetailViewModel.Dependencies(
                apiClient: mockAPIClient
            ),
            coinId: "bitcoin"
        )
        #expect(sut.state == ViewModelState.loading)
        #expect(sut.coinDetail == nil)
        #expect(sut.coinIdentifier() == "bitcoin")

        await sut.fetchCoinDetails()
        Task { @MainActor in
            guard let coinDetail = sut.coinDetail else { return }
            #expect(sut.state == .none)
            #expect(coinDetail.name == "XRP")
            #expect(coinDetail.description == "XRP is a digital currency and payment network created to provide fast, low-cost international transactions with end-to-end visibility.")
            #expect(coinDetail.symbol == "XRP")
            #expect(coinDetail.price == "2.5066942400238434")
        }
    }
}

extension CoinDetailViewModelTests {
    struct MockAPIClient: APIClient {
        func send<T>(
            request: any APIRequest
        ) async throws -> T where T : Decodable, T : Encodable {
            guard
                let item = Models.CoinRank.API.CoinDetailData.mocked() as? T
            else {fatalError("Type is not mockable")}
            return item
        }
    }
}
