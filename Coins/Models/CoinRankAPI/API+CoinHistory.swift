//
//  API+CoinHistory.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//

// MARK: - Models.CoinRank.API.Coin.History

extension Models.CoinRank.API.Coin {
    struct History: Codable {
        let history: [HistoryPoint]
    }
}

// MARK: - Models.CoinRank.API.Coin.History.HistoryPoint

extension Models.CoinRank.API.Coin.History {
    struct HistoryPoint: Codable {
        /// Price of the coin.
        let price: String?
        
        /// An Epoch timestamp in seconds when the coin had the given price..
        let timestamp: Int
    }
}

// MARK: - Models.CoinRank.API.Coin.History + Normalizable

extension Models.CoinRank.API.Coin.History: Normalizable {
    public func normalize() -> [Models.Core.Coin.History] {
        return history.map { Models.Core.Coin.History(price: $0.price, timestamp: $0.timestamp)}
    }
}
