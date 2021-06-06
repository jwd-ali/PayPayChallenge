//
//  SearchService.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Combine
protocol CurrencyServiceType {
    func getRatesList<T: Decodable>() -> AnyPublisher<T, NetworkRequestError>
    func getCurrenciesList<T: Decodable>() -> AnyPublisher<T, NetworkRequestError>
}

class CurrencyService: CurrencyServiceType {
    private let apiClient: ApiService
    private let accessKey = "3bbac3040fc64849bef582c68c50c2d1"
    
    init(apiClient: ApiService = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getCurrenciesList<T: Decodable>() -> AnyPublisher<T, NetworkRequestError> {
        let route = Endpoint(route: Route.getCurrencies, method: .get, queryItems: ["access_key": accessKey])
        return apiClient.request(router: route)
    }
    
    func getRatesList<T: Decodable>() -> AnyPublisher<T, NetworkRequestError> {
        let route = Endpoint(route: Route.getExchangeRate, method: .get, queryItems: ["access_key": accessKey])
        return apiClient.request(router: route)
    }
    
}

