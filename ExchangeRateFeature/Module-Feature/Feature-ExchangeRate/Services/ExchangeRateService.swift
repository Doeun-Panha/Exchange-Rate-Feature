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
    
    private var apiBaseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
    }
    
    func fetchRates(baseCurrency: String = "USD") async throws -> ExchangeRateModel {
        guard !apiBaseURL.isEmpty else {
            throw NetworkError.invalidURL
        }
        
        let urlString = "\(apiBaseURL)\(baseCurrency)"
        
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
