//
//  APIRequest.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//

import Foundation

// MARK: - RequestType

/// Enum that Encapsulates the request method e.g GET, POST e.t.c
public enum RequestType: String {
    case GET
}

// MARK: - APIRequest

public protocol APIRequest {
    /// API Method for  a request.
    var method: RequestType { get }
    /// Resource  path fin a url string.
    var path: String { get }
    /// Query Parameters that can be passed in the url.
    var queryParameters: [String : String] { get }
}

// MARK: - RequestType Constants

extension RequestType {
    struct Constants {
        static let baseURLString = "https://api.coinranking.com/v2/"
    }
}

// MARK: - APIRequest + urlRequest Func

extension APIRequest {
    /// Builds a `URLRequest` instance using the path, method and query params.
    /// - Parameter baseURL: Base url for the API being called.
    /// - Returns: URLRequest object
    func urlRequest(
        with baseURL: URL = URL(
            string: RequestType.Constants.baseURLString
        )!
    ) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            throw URRequestError.unableToCreateURLComponent
        }

        components.queryItems = queryParameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            throw URRequestError.missingURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppEnvironment.coinApIKey, forHTTPHeaderField: "x-access-token")
        return request
    }
}


// MARK: URRequestError

enum URRequestError: Error {
    case invalidURL(String)
    case missingURL
    case unableToCreateURLComponent
    case invalidHTTPMethod
}
