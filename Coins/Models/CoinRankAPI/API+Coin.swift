//
//  Coin.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//
import Foundation

// MARK: - Models.CoinRank.API.Coin

extension Models.CoinRank.API {
    struct CoinResponse: Codable {
        let coins: [Coin]
        let stats: stats
    }
}

extension Models.CoinRank.API.CoinResponse {
    struct stats: Codable {
        /// Total number of coins within the query
        let total: Int
        /// Total number of coins without the filters.
        let totalCoins: Int
    }
}

extension Models.CoinRank.API {
    ///  Coin Model
    struct Coin: Codable {
        /// UUID of the coin.
        let uuid: String

        /// Name of the coin.
        let name: String

        /// Currency symbol.
        let symbol: String

        /// Price of the coin.
        let price: String
        
        /// Change of price in a given period of time
        let change: String

        /// The position in the ranks
        let rank: Int

        ///  Main HEX color of the coin.
        let color: String?

        /// Location of the icon.
        let iconUrl: String
    }
}

extension Models.CoinRank.API.Coin {
    enum Filter: String, CaseIterable {
        case best24HourPerformance = "change"
        case highestPrice = "price"
    }
}

extension Models.CoinRank.API.Coin {
    enum TrendPeriod: String, CaseIterable {
        case oneHour = "1h"
        case threeHours = "3h"
        case twelveHours = "12h"
        case twentyFourHours = "24h"
        case sevenDays = "7d"
        case thirtyDays = "30d"
        case oneYear = "1y"
        case threeYears = "3y"
        case fiveYears = "5y"
    }
}

// MARK: - Models.CoinRank.API.Coin + Normalizable

extension Models.CoinRank.API.Coin: Normalizable {
    func normalize() -> Models.Core.Coin {
        return Models.Core.Coin(
            id: uuid,
            name: name,
            symbol: symbol,
            price: price,
            change: change,
            rank: rank,
            color: color ?? "#ffffff", // defaults to white
            iconUrl: iconUrl
        )
    }
}

// MARK: - Models.CoinRank.API.CoinResponse + Normalizable

extension Models.CoinRank.API.CoinResponse: Normalizable {
    func normalize() -> Models.Core.CoinResponse {
        let stats = Models.Core.Stats(total: stats.total, totalCoins: stats.totalCoins)
        return Models.Core.CoinResponse(coins: coins.compactMap {$0.normalize()}, stats: stats)
    }
}

// MARK: - Models.CoinRank.API.CoinResponse + Mockable

extension Models.CoinRank.API.CoinResponse: Mockable {
    public static func mocked() -> Models.CoinRank.API.CoinResponse {
        guard let url = Bundle.main.url(forResource: "CoinResponse", withExtension: "json") else {
            fatalError("Failed to locate coin.json in bundle")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let value = try decoder.decode(DataContainer<T>.self, from: data)
            return value.data
        } catch {
            fatalError("Failed to decode coin.json: \(error.localizedDescription)")
        }
    }
}
