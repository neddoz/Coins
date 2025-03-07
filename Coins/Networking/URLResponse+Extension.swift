//
//  URLResponse+Extension.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//

//
//  URLResponse+Extension.swift
//  WeatherForecast
//
//  Created by kayeli dennis on 09/11/2022.
//

import Foundation

extension URLResponse {
    /// A type that encapsulates the possible responses from an API.
    public enum HTTPStatus {
        public enum description {
            case success
            case created
            case badRequest
            case unauthorized
            case forbidden
            case notFound
            case conflict
            case serverError
            case other
        }
        
        case code(Int)
        
        var status: description {
            switch self{
            case .code(200...299):
                return .success
            case .code(400):
                return .badRequest
            case .code(401):
                return .unauthorized
            case .code(403):
                return .forbidden
            case .code(404):
                return .notFound
            case .code(409):
                return .conflict
            case .code(500...599):
                return .serverError
            default:
                return .other
            }
        }
    }
    
    var status: HTTPStatus.description {
        let response = self as? HTTPURLResponse ?? HTTPURLResponse()
        
        let statusCode = HTTPStatus.code(response.statusCode).status
        return statusCode
    }
    
}

///  Network Error Encapsulation
public enum NetworkError: Error {
    case DecodingFailure(errorMessage: String)
    case BadRequest(errorMessage: String)
    case Unauthorized
    case NotFound(errorMessage: String)
    case other(errorMessage: String)
    
    /// Initializes a `NetworkError` instance.
    /// - Parameters:
    ///   - response: URLResponse Object.
    ///   - message: Message from the error
    init(response: URLResponse, message: String) {
        switch response.status {
        case .badRequest:
            self = .BadRequest(errorMessage: message)
        case .notFound:
            self = .BadRequest(errorMessage: message)
        case .unauthorized:
            self = .Unauthorized
        default:
            self = .other(errorMessage: message)
        }
    }
    
    /// A utility function to return the error message from a `NetworkError` instance.
    /// - Returns: The message as a string.
    func errorMessage()-> String {
        switch self {
        case .BadRequest(let message):
            return message
        case .NotFound(let message):
            return message
        case .DecodingFailure(let message):
            return message
        case .Unauthorized:
            return "Unauthorized"
        case .other(errorMessage: let message):
            return message
        }
    }
}
