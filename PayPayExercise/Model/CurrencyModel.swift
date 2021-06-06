//
//  CurrencyModel.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation

struct CurrencyModel: Codable, Comparable {
    let name: String
    let code: String
    let rate: Double
    
    static func < (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        return lhs.name < rhs.name
    }
    

}
