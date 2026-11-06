//
//  ExchangeRateContentView.swift
//  ExchangeRateFeature
//
//  Created by Panha on 6/11/26.
//

import UIKit

final class ExchangeRateContentView: UIView {
    private lazy var contentHeaderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, UIView(), rateLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "f2e7cb")
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(hex: "282d44")
        label.text = "Currency"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(hex: "282d44")
        label.textAlignment = .right
        label.text = "Rate"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 24
        tableView.clipsToBounds = true
        tableView.separatorColor = UIColor(hex: "cd9e2f").withAlphaComponent(0.25)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: RateTableViewCell.identifier)
        return tableView
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
        label.textColor = UIColor(hex: "282d44")
        label.textAlignment = .center
        label.text = "The rates are quoted for indicative purpose only and subject to variation."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExchangeRateContentView {
    private func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentContainerView)
        
        contentContainerView.addSubview(contentHeaderStackView)
        contentContainerView.addSubview(tableView)
        contentContainerView.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentHeaderStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 20),
            contentHeaderStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 30),
            contentHeaderStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -30),
            
            tableView.topAnchor.constraint(equalTo: contentHeaderStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: warningLabel.topAnchor, constant: -20),
            
            warningLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 10),
            warningLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -10),
            warningLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -20)
        ])
    }
}

extension ExchangeRateContentView {
    func updateTheme(isDark: Bool) {
        let containerBackgroundColor = isDark ? UIColor(hex: "272b2d") : UIColor(hex: "f2e7cb")
        let textColor = isDark ? .white : UIColor(hex: "282d44")
        let backgroundColor = isDark ? UIColor(hex: "636366") : .white
        
        contentContainerView.backgroundColor = containerBackgroundColor
        
        currencyLabel.textColor = textColor
        rateLabel.textColor = textColor
        
        tableView.backgroundColor = backgroundColor
        tableView.separatorColor = containerBackgroundColor
        tableView.reloadData()
        
        warningLabel.textColor = textColor
    }
}
