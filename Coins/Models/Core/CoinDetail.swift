//
//  CoinDetail.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//

// MARK: - Models.CoinRank.API.CoinDetailData.CoinDetail

extension Models.Core {
    struct CoinDetail {
        /// UUID of the coin.
        let uuid: String
        
        /// Currency symbol.
        let symbol: String
        
        /// Name of the coin.
        let name: String
        
        /// Small description of the coin
        let description: String?
        
        /// Main HEX color of the coin
        let color: String?
        
        /// Location of the icon.
        let iconUrl: String?
        
        /// URL of the primary website
        let websiteUrl: String?
        
        /// Supply of the coin
        let supply: Supply
        
        let numberOfMarkets: Int
        
        /// The number of exchanges that trade this coin
        let numberOfExchanges: Int
        
        let volume24h: String
        
        /// Market capitalization. Price times circulating supply
        let marketCap: String
        
        /// Price of the coin
        let price: String
        
        /// Price of the coin expressed in Bitcoin
        let btcPrice: String?
        
        /// Percentage of change over the given time period
        let change: String
        
        /// The position in the ranks
        let rank: Int
        
        /// Array of prices based on the time period parameter, useful for a sparkline
        let sparkline: [String?]
        
        /// The highest price that the coin has reached
        let allTimeHigh: AllTimeHigh
        
        /// Intializes an instance of `CoinDetail`
        /// - Parameters:
        ///   - uuid: UUID of the coin.
        ///   - symbol: Currency symbol.
        ///   - name:  Name of the coin.
        ///   - description: Small description of the coin
        ///   - color: Main HEX color of the coin
        ///   - iconUrl:  Location of the icon.
        ///   - websiteUrl: URL of the primary website
        ///   - supply: Supply of the coin
        ///   - numberOfMarkets: number of makerts for the coiin
        ///   - numberOfExchanges: The number of exchanges that trade this coin
        ///   - volume24h: volume24h of the coin
        ///   - marketCap: Market capitalization. Price times circulating supply
        ///   - price: Price of the coin
        ///   - btcPrice:  Price of the coin expressed in Bitcoin
        ///   - change: Percentage of change over the given time period
        ///   - rank: The position in the ranks
        ///   - sparkline: Array of prices based on the time period parameter, useful for a sparkline
        ///   - allTimeHigh: The highest price that the coin has reached
        init(
            uuid: String,
            symbol: String,
            name: String,
            description: String?,
            color: String?,
            iconUrl: String?,
            websiteUrl: String?,
            supply: Supply,
            numberOfMarkets: Int,
            numberOfExchanges: Int,
            volume24h: String,
            marketCap: String,
            price: String,
            btcPrice: String?,
            change: String,
            rank: Int,
            sparkline: [String?],
            allTimeHigh: AllTimeHigh
        ) {
            self.uuid = uuid
            self.symbol = symbol
            self.name = name
            self.description = description
            self.color = color
            self.iconUrl = iconUrl
            self.websiteUrl = websiteUrl
            self.supply = supply
            self.numberOfMarkets = numberOfMarkets
            self.numberOfExchanges = numberOfExchanges
            self.volume24h = volume24h
            self.marketCap = marketCap
            self.price = price
            self.btcPrice = btcPrice
            self.change = change
            self.rank = rank
            self.sparkline = sparkline
            self.allTimeHigh = allTimeHigh
        }
    }
}

// MARK: - Models.Core.CoinDetail.Supply

extension Models.Core.CoinDetail {
    struct Supply: Codable {
        let confirmed: Bool
        let circulating: String?
        let total: String?
    }
}

// MARK: - Models.Core.CoinDetail.AllTimeHigh

extension Models.Core.CoinDetail {
    struct AllTimeHigh: Codable {
        let price: String
        let timestamp: Int
    }
}
