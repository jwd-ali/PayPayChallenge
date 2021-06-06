//
//  SupportedModel.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation

struct SupportedModel: Codable {
    let terms: URL
    let privacy: URL
    let currencies: [String: String]
}
