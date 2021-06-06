//
//  MockCurrencyDefaults.swift
//  PayPayExerciseTests
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation
@testable import PayPayExercise
class MockCurrencyDefaults: CurrencyDefaultsType {
    var timestamp: Date = {
       return Date()
    }()
    
    var currencies: [CurrencyModel] = {
        CurrencyModel.mocked
    }()
    
    var selectedCurrency: CurrencyModel? = {
        CurrencyModel.mocked.first
    }()
    
    
}
