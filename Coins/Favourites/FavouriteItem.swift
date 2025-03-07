//
//  Item.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//

import Foundation
import SwiftData

@Model
final class FavouriteItem {
    var timestamp: Date
    
    var id: String

    var name: String

    var symbol: String

    var price: String

    var change: String

    var rank: Int

    var color: String

    var iconUrl: String
    
    init(
        timestamp: Date,
        id: String,
        name: String,
        symbol: String,
        price: String,
        change: String,
        rank: Int,
        color: String,
        iconUrl: String
    ) {
        self.timestamp = timestamp
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

extension FavouriteItem: CoinView.CoinViewItem {}
