//
//  PricePoint.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//
import Foundation

extension Models.Core {
    struct PricePoint: Identifiable {
        let id = UUID()
        let timestamp: Date
        let price: Double
    }
}
