//
//  Coin.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//

extension Models.Core {
    struct CoinResponse {
        let coins: [Coin]
        let stats: Stats

        /// Initializes an instance
        /// - Parameters:
        ///   - coins: lis of coins.
        ///   - data: stats about the coins.
        public init(coins: [Coin], stats: Stats) {
            self.coins = coins
            self.stats = stats
        }
    }
}

extension Models.Core {
    struct Stats {
        /// Total number of coins within the query
        let total: Int
        /// Total number of coins without the filters.
        let totalCoins: Int
    }
}

extension Models.Core {
    /// Coin Model
    struct Coin: Identifiable {
        /// UUID of the coin.
        let id: String

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
        let color: String

        /// Location of the icon.
        let iconUrl: String

        /// Initializes a `Coin` Instance.
        /// - Parameters:
        ///   - id: UUID of the coin.
        ///   - name: Name of the coin.
        ///   - symbol: Currency symbol.
        ///   - price: Price of the coin.
        ///   - rank: The position in the ranks
        ///   - color: Main HEX color of the coin.
        ///   - iconUrl: Location of the icon.
        public init(
            id: String,
            name: String,
            symbol: String,
            price: String,
            change: String,
            rank: Int,
            color: String,
            iconUrl: String
        ) {
            self.id = id
            self.name = name
            self.symbol = symbol
            self.price = price
            self.change = change
            self.rank = rank
            self.color = color
            self.iconUrl = iconUrl
        }
    }
}

extension Models.Core.Coin: CoinView.CoinViewItem {}
