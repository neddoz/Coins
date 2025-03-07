//
//  API+CoinDetail.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//

import Foundation

// MARK: - Models.CoinRank.API.CoinDetailData

extension Models.CoinRank.API {
    struct CoinDetailData: Codable {
        let coin: CoinDetail
    }
}

// MARK: - Models.CoinRank.API.CoinDetailData.CoinDetail

extension Models.CoinRank.API.CoinDetailData {
    struct CoinDetail: Codable {
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
        
        enum CodingKeys: String, CodingKey {
            case uuid, symbol, name, description, color, iconUrl, websiteUrl
            case supply, numberOfMarkets, numberOfExchanges
            case volume24h = "24hVolume"
            case marketCap, price, btcPrice, change, rank, sparkline, allTimeHigh
        }
    }
}

// MARK: - Models.CoinRank.API.CoinDetailData.CoinDetail.Supply

extension Models.CoinRank.API.CoinDetailData.CoinDetail {
    struct Supply: Codable {
        let confirmed: Bool
        let circulating: String?
        let total: String?
    }
}

extension Models.CoinRank.API.CoinDetailData.CoinDetail.Supply {
    public func normalize() ->  Models.Core.CoinDetail.Supply{
        return Models.Core.CoinDetail.Supply(confirmed: confirmed, circulating: circulating, total: total)
    }
}

// MARK: - Models.CoinRank.API.CoinDetailData.CoinDetail.AllTimeHigh

extension Models.CoinRank.API.CoinDetailData.CoinDetail {
    struct AllTimeHigh: Codable {
        let price: String
        let timestamp: Int
    }
}

extension Models.CoinRank.API.CoinDetailData.CoinDetail.AllTimeHigh: Normalizable {
    public func normalize() ->  Models.Core.CoinDetail.AllTimeHigh {
        return Models.Core.CoinDetail.AllTimeHigh.init(price: price, timestamp: timestamp)
    }
}

// MARK: - extension Models.CoinRank.API.CoinDetailData + Normalizable

extension Models.CoinRank.API.CoinDetailData: Normalizable {
    public func normalize() -> Models.Core.CoinDetail {
        return  Models.Core.CoinDetail(
            uuid: coin.uuid,
            symbol: coin.symbol,
            name: coin.name,
            description: coin.description,
            color: coin.color,
            iconUrl: coin.iconUrl,
            websiteUrl: coin.websiteUrl,
            supply: coin.supply.normalize(),
            numberOfMarkets: coin.numberOfMarkets,
            numberOfExchanges: coin.numberOfExchanges,
            volume24h: coin.volume24h,
            marketCap: coin.marketCap,
            price: coin.price,
            btcPrice: coin.btcPrice,
            change: coin.change,
            rank: coin.rank,
            sparkline: coin.sparkline,
            allTimeHigh: coin.allTimeHigh.normalize()
        )
    }
}

extension Models.CoinRank.API.CoinDetailData: Mockable {
    public static func mocked() -> Models.CoinRank.API.CoinDetailData {
        guard let url = Bundle.main.url(forResource: "CoinDetail", withExtension: "json") else {
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
