//
//  RateTableViewCell.swift
//  ExchangeRateFeature
//
//  Created by Panha on 4/11/26.
//

import UIKit

final class RateTableViewCell: UITableViewCell {
    static let identifier = "RateTableViewCell"
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RateTableViewCell {
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(currencyLabel)
        contentView.addSubview(rateLabel)
        
        NSLayoutConstraint.activate([
            currencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            currencyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: currencyLabel.trailingAnchor, constant: 16),
            
            contentView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with currency: String, rate: Double, textColor: UIColor = UIColor(hex: "272b2d")) {
        currencyLabel.textColor = textColor
        rateLabel.textColor = textColor
        
        let flag = flagEmoji(for: currency)
        currencyLabel.text = "\(flag) \(currency)"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        
        let formattedRate = formatter.string(from: NSNumber(value: rate)) ?? "\(rate)"
        
        rateLabel.text = "\(formattedRate) \(currency)"
    }
    
    private func flagEmoji(for currencyCode: String) -> String {
        let countryMapping: [String: String] = [
            "USD": "US", "EUR": "EU", "GBP": "GB", "CHF": "CH",
            "AUD": "AU", "CAD": "CA", "JPY": "JP", "CNY": "CN",
            "KHR": "KH", "BRL": "BR", "CZK": "CZ", "DKK": "DK",
            "HKD": "HK", "HUF": "HU", "IDR": "ID", "ILS": "IL",
            "INR": "IN", "ISK": "IS", "KRW": "KR", "MXN": "MX",
            "MYR": "MY", "NOK": "NO", "NZD": "NZ", "PHP": "PH",
            "PLN": "PL", "RON": "RO", "SEK": "SE", "SGD": "SG",
            "THB": "TH", "TRY": "TR", "ZAR": "ZA"
        ]
        
        let countryCode = countryMapping[currencyCode] ?? "US"
        
        let base: UInt32 = 127397
        var flagString = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            if let unicodeScalar = UnicodeScalar(base + scalar.value) {
                flagString.append(String(unicodeScalar))
            }
        }
        return flagString
    }
}
