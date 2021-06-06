//
//  MockCurrencyService.swift
//  PayPayExerciseTests
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation
import Combine
@testable import PayPayExercise


class MockCurrencyService: CurrencyServiceType {
    func getRatesList<T>() -> AnyPublisher<T, NetworkRequestError> where T : Decodable {
        Just(RateModel.mocked as! T)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
    }
    
    func getCurrenciesList<T>() -> AnyPublisher<T, NetworkRequestError> where T : Decodable {
        Just(SupportedModel.mocked as! T)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
    }
}

extension RateModel {
    static var mocked: [RateModel] {
        return [RateModel(terms: URL(string: "https://currencylayer.com/documentation")!, privacy: URL(string: "https://currencylayer.com/documentation")!, timestamp: Date(), source: "https://currencylayer.com/documentation", quotes: ["PKR": 1.2])]
    }
}

extension SupportedModel {
    static var mocked: [SupportedModel] {
        return [SupportedModel(terms: URL(string: "https://currencylayer.com/documentation")!, privacy: URL(string: "https://currencylayer.com/documentation")!, currencies: ["PKR": "1.2"])]
    }
}
