//
//  APIClient.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//


import Foundation

protocol APIClient: Sendable {
    func send<T: Codable>(request: APIRequest) async throws -> T
}

struct NetworkClient: APIClient {
    // Send an API request and decode the response
    func send<T: Codable>(request: APIRequest) async throws -> T {
        let (data, response) = try await session.data(for: request.urlRequest())

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.status == .success  else {
            throw NetworkError(response: response, message: "Invalid response")
        }

        do {
            let value = try decoder.decode(DataContainer<T>.self, from: data)
            return value.data
        } catch {
            throw NetworkError.DecodingFailure(errorMessage: error.localizedDescription)
        }
    }

    private var session: URLSession
    private var decoder: JSONDecoder
}

extension NetworkClient {
    struct Dependencies {
        let session: URLSession
        let decoder: JSONDecoder
    }
}

extension NetworkClient {
    init(dependencies: Dependencies = .init(session: .shared, decoder: .init())) {
        self.session = dependencies.session
        self.decoder = dependencies.decoder
    }
}

struct DataContainer<T: Codable>: Codable { let data: T }
