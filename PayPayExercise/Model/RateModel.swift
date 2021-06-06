//
//  CurrencyModel.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation

struct RateModel: Codable {
    let terms: URL
    let privacy: URL
    let timestamp: Date
    let source: String
    let quotes: [String: Double]
}
