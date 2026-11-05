//
//  ExchangeRateViewModel.swift
//  ExchangeRateFeature
//
//  Created by Panha on 4/11/26.
//

import Foundation

@MainActor
final class ExchangeRateViewModel {
    private let service = ExchangeRateService()
    
    private(set) var rates: [(key: String, value: Double)] = []
    private(set) var baseCurrency: String = "USD"
    private(set) var lastUpdatedDate: String = ""
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil
    
    var onStateChanged: (() -> Void)?
}

extension ExchangeRateViewModel {
    func loadRates(for base: String = "USD") {
        self.baseCurrency = base
        self.isLoading = true
        self.errorMessage = nil
        onStateChanged?()
        
        Task {
            do {
                let response = try await service.fetchRates(baseCurrency: base)
                self.rates = response.rates.sorted { $0.key < $1.key }
                self.lastUpdatedDate = response.date
                self.isLoading = false
                onStateChanged?()
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                onStateChanged?()
            }
        }
    }
}
