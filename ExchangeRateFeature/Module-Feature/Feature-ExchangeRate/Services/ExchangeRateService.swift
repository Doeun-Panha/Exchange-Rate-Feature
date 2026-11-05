//
//  ExchangeRateService.swift
//  ExchangeRateFeature
//
//  Created by Panha on 4/11/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError
    case decodingFailed
}

final class ExchangeRateService {
    func fetchRates(baseCurrency: String = "USD") async throws -> ExchangeRateModel {
        let urlString = "https://api.frankfurter.dev/v1/latest?base=\(baseCurrency)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(ExchangeRateModel.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
