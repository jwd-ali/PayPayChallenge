//
//  MockCurrencyRepository.swift
//  PayPayExerciseTests
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation
import Combine
@testable import PayPayExercise
class MockCurrencyRepository: RepositoryType {
    func saveSelectedCurrency(_ currency: CurrencyModel) {
    }
    
    func saveCurrencies(_ currencies: [CurrencyModel]) {
    }
    
    func getCurrencies() -> AnyPublisher<[CurrencyModel], NetworkRequestError> {
        Result.Publisher(CurrencyModel.mocked)
            .eraseToAnyPublisher()
    }
    
}

extension CurrencyModel {
   static var mocked: [CurrencyModel]  {
       return [CurrencyModel(name: "Pakistani rupee", code: "PKR", rate: 1.3)]
    }
}
