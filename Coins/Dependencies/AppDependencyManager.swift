//
//  AppDependencyManager.swift
//  Coins
//
//  Created by kayeli dennis on 03/03/2025.
//

protocol AppDependencyManagerProtocol {
    var apiClient: APIClient { get }
}

final class AppDependencyManager: AppDependencyManagerProtocol {
    lazy var apiClient: APIClient = {
        return NetworkClient()
    }()
}
