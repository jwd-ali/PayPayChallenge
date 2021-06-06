//
//  UserDefaultWrapper.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<Element: Codable> {
    let key: String
    let defaultValue: Element
    let userDefaults: UserDefaults = .standard
    
    var wrappedValue: Element {
        get {
            guard let jsonString = userDefaults.string(forKey: key) else {
                return defaultValue
            }
            
            guard let jsonData = jsonString.data(using: .utf8) else {
                return defaultValue
            }
            
            guard let value = try? JSONDecoder().decode(Element.self, from: jsonData) else {
                return defaultValue
            }
            
            return value
        }
        set {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            guard let jsonData = try? encoder.encode(newValue) else { return }
            
            let jsonString = String(bytes: jsonData, encoding: .utf8)
            userDefaults.set(jsonString, forKey: key)
        }
    }
}

protocol CurrencyDefaultsType {
    var timestamp: Date { get set }
    var currencies: [CurrencyModel] { get set }
    var selectedCurrency: CurrencyModel? { get set }
}

struct CurrencyDefaults: CurrencyDefaultsType {
    @UserDefaultsWrapper(key: "com.currency.timestamp",
                         defaultValue: Date(timeIntervalSince1970: 0))
     var timestamp: Date
    
    @UserDefaultsWrapper(key: "com.currency.list",
                         defaultValue: [])
     var currencies: [CurrencyModel]
    
    @UserDefaultsWrapper(key: "com.currency.selected",
                         defaultValue: nil)
     var selectedCurrency: CurrencyModel?
}
