//
//  AppEnvironment.swift
//  Coins
//
//  Created by kayeli dennis on 06/03/2025.
//
import Foundation

public enum AppEnvironment {
    
    enum Keys {
        static let CoinApiKey = "COIN_API_KEY"
    }
    public static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    static let coinApIKey = {
        guard let apiKeyString = infoDictionary[Keys.CoinApiKey] as? String else {
            fatalError("api key not found in plist file")
        }
        return apiKeyString
    }()
}
