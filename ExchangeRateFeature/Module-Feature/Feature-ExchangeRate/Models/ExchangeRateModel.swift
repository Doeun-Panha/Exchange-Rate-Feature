//
//  ExchangeRateModel.swift
//  ExchangeRateFeature
//
//  Created by Panha on 4/11/26.
//

import Foundation

struct ExchangeRateModel: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
}
