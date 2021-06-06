//
//  Endpoint.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation

enum URLRequestError: Error {
    case invalidURL
}

public protocol URLRequestConvertible {
    func urlRequest() throws -> URLRequest
}

enum Route: String {
    case getCurrencies = "/list"
    case getExchangeRate = "/live"
}

enum HTTPMethod {
    case get
    case post(body: Data?)
    
    var toString: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

struct Endpoint {
    let scheme: String = "http"
    let host: String = "api.currencylayer.com"
    let route: Route
    let method: HTTPMethod
    let queryItems: [String: String]?
    let path: [String]?
    
    init(route: Route,
         method: HTTPMethod,
         path: [String]? = nil,
         queryItems: [String: String]? = nil) {
        self.route = route
        self.method = method
        self.path = path
        self.queryItems = queryItems
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = route.rawValue + (path?.compactMap { "/\($0)" }.joined() ?? "")
        components.queryItems = queryItems?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }
}

extension Endpoint: URLRequestConvertible {
    func urlRequest() throws -> URLRequest {
        guard let url = url else { throw URLRequestError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.toString
        
        if case let HTTPMethod.post(body) = method {
            request.httpBody = body
        }
        
        return request
    }
}
