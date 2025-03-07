//
//  CoinHistory.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//

extension Models.Core.Coin {
    struct History: Codable {
        /// Price of the coin.
        let price: String?
        /// An Epoch timestamp in seconds when the coin had the given price..
        let timestamp: Int

        /// Iniitalizes a `History` instance
        /// - Parameters:
        ///   - price: Price of the coin (optioanl).
        ///   - timestamp: An Epoch timestamp in seconds when the coin had the given price..
        init(price: String?, timestamp: Int) {
            self.price = price
            self.timestamp = timestamp
        }
    }
}
