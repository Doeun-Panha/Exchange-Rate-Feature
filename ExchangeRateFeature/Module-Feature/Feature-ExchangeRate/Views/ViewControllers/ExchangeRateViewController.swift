//
//  ViewController.swift
//  ExchangeRateFeature
//
//  Created by Panha on 4/11/26.
//

import UIKit

class ExchangeRateViewController: UIViewController {
    private let viewModel = ExchangeRateViewModel()
    private var isDarkMode = false
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapThemeButton))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var themeButton: UIButton = {
        let button = UIButton(type: .custom)
        let iconImage = UIImage(named: "White&Cream-theme")
        button.setImage(iconImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hex: "f2e7cb").cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapThemeButton), for: .touchUpInside)
        return button
    }()
    
    private let themeDropdownView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lightThemeButton: UIButton = {
        return createThemeOptionButton(title: "☀️ White Cream", action: #selector(selectLightTheme))
    }()

    private lazy var darkThemeButton: UIButton = {
        return createThemeOptionButton(title: "🌙 Smoke Matte", action: #selector(selectDarkTheme))
    }()

    private lazy var themeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lightThemeButton, darkThemeButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func createThemeOptionButton(title: String, textColor: UIColor = UIColor(hex: "282d44"), action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = UIColor(hex: "282d44")
        label.textAlignment = .center
        label.text = "Exchange Rates"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textColor = UIColor(hex: "7a7e8e")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "f2e7cb")
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentHeaderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, UIView(), rateLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 24
        tableView.clipsToBounds = true
        tableView.separatorColor = UIColor(hex: "cd9e2f").withAlphaComponent(0.25)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: RateTableViewCell.identifier)
        tableView.dataSource = self
        return tableView
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
        label.textColor = UIColor(hex: "282d44")
        label.textAlignment = .center
        label.text = "The rates are quoted for indicative purpose only and subject to variation."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.loadRates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension ExchangeRateViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        view.addSubview(activityIndicatorView)
        
        containerView.addSubview(appIconImageView)
        containerView.addSubview(themeButton)
        containerView.addSubview(headerStackView)
        containerView.addSubview(contentContainerView)
        containerView.addSubview(dismissOverlayView)
        containerView.addSubview(themeDropdownView)
        
        themeDropdownView.addSubview(themeStackView)
        
        contentContainerView.addSubview(contentHeaderStackView)
        contentContainerView.addSubview(tableView)
        contentContainerView.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dismissOverlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dismissOverlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dismissOverlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dismissOverlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            appIconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            appIconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            appIconImageView.widthAnchor.constraint(equalToConstant: 48),
            appIconImageView.heightAnchor.constraint(equalToConstant: 48),
            
            themeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            themeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            themeButton.widthAnchor.constraint(equalToConstant: 40),
            themeButton.heightAnchor.constraint(equalToConstant: 40),
            
            themeDropdownView.topAnchor.constraint(equalTo: themeButton.bottomAnchor, constant: 8),
            themeDropdownView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            themeDropdownView.widthAnchor.constraint(equalToConstant: 160),
            themeDropdownView.heightAnchor.constraint(equalToConstant: 90),
            
            themeStackView.topAnchor.constraint(equalTo: themeDropdownView.topAnchor, constant: 8),
            themeStackView.leadingAnchor.constraint(equalTo: themeDropdownView.leadingAnchor, constant: 8),
            themeStackView.trailingAnchor.constraint(equalTo: themeDropdownView.trailingAnchor, constant: -8),
            themeDropdownView.bottomAnchor.constraint(equalTo: themeStackView.bottomAnchor, constant: 8),
            
            headerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            headerStackView.leadingAnchor.constraint(equalTo: appIconImageView.trailingAnchor, constant: 12),
            headerStackView.trailingAnchor.constraint(equalTo: themeButton.leadingAnchor, constant: -12),
            
            contentContainerView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 24),
            contentContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            contentHeaderStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 20),
            contentHeaderStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 30),
            contentHeaderStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -30),
            
            tableView.topAnchor.constraint(equalTo: contentHeaderStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: warningLabel.topAnchor, constant: -20),
            
            warningLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 10),
            warningLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -10),
            warningLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -20),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.viewModel.isLoading {
                    if !self.refreshControl.isRefreshing {
                        self.activityIndicatorView.startAnimating()
                    }
                } else {
                    self.activityIndicatorView.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
                
                if let error = self.viewModel.errorMessage {
                    self.showErrorAlert(message: error)
                }
                
                self.tableView.reloadData()
                self.descriptionLabel.text = "Base: \(self.viewModel.baseCurrency) | \(self.viewModel.lastUpdatedDate)"
            }
        }
    }
    
    @objc private func handleRefresh() {
        viewModel.loadRates(for: viewModel.baseCurrency)
    }
    
    @objc private func didTapThemeButton() {
        let isHidden = themeDropdownView.isHidden
        
        if isHidden {
            dismissOverlayView.isHidden = false
            themeDropdownView.isHidden = false
            themeDropdownView.alpha = 0
            themeDropdownView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.allowUserInteraction]) {
                self.themeDropdownView.alpha = 1
                self.themeDropdownView.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.themeDropdownView.alpha = 0
                self.themeDropdownView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                self.themeDropdownView.isHidden = true
                self.dismissOverlayView.isHidden = true
                self.themeDropdownView.transform = .identity
            }
        }
    }
    
    @objc private func selectLightTheme() {
        didTapThemeButton()
        isDarkMode = false
        
        view.backgroundColor = .white
        
        appIconImageView.image = UIImage(named: "AppLogo")
        
        themeButton.setImage(UIImage(named: "White&Cream-theme"), for: .normal)
        themeButton.layer.borderColor = UIColor(hex: "f2e7cb").cgColor
        
        themeDropdownView.backgroundColor = .white
        lightThemeButton.setTitleColor(UIColor(hex: "272b2d"), for: .normal)
        darkThemeButton.setTitleColor(UIColor(hex: "272b2d"), for: .normal)
        
        titleLabel.textColor = UIColor(hex: "272b2d")
        descriptionLabel.textColor = UIColor(hex: "272b2d").withAlphaComponent(0.75)
        
        contentContainerView.backgroundColor = UIColor(hex: "f2e7cb")
        
        currencyLabel.textColor = UIColor(hex: "272b2d")
        rateLabel.textColor = UIColor(hex: "272b2d")
        
        tableView.backgroundColor = UIColor(hex: "ffffff")
        tableView.separatorColor = UIColor(hex: "f2e7cb")
        tableView.reloadData()
        
        warningLabel.textColor = UIColor(hex: "272b2d")
    }
    
    @objc private func selectDarkTheme() {
        didTapThemeButton()
        isDarkMode = true
        
        view.backgroundColor = UIColor(hex: "636366")
        
        appIconImageView.image = UIImage(named: "AppLogo (Dark Mode)")
        
        themeButton.setImage(UIImage(named: "Smoke&Matte-theme"), for: .normal)
        themeButton.layer.borderColor = UIColor(hex: "272b2d").cgColor
        
        themeDropdownView.backgroundColor = UIColor(hex: "272b2d")
        lightThemeButton.setTitleColor(.white, for: .normal)
        darkThemeButton.setTitleColor(.white, for: .normal)
        
        titleLabel.textColor = UIColor(hex: "ffffff")
        descriptionLabel.textColor = UIColor(hex: "ffffff").withAlphaComponent(0.75)
        
        contentContainerView.backgroundColor = UIColor(hex: "272b2d")
        
        currencyLabel.textColor = .white
        rateLabel.textColor = .white
        
        tableView.backgroundColor = UIColor(hex: "636366")
        tableView.separatorColor = UIColor(hex: "272b2d")
        tableView.reloadData()
        
        warningLabel.textColor = .white
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.loadRates()
        })
        present(alert, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RateTableViewCell.identifier, for: indexPath) as? RateTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.rates[indexPath.row]
        
        let cellTextColor = isDarkMode ? UIColor.white : UIColor(hex: "272b2d")
        cell.configure(with: item.key, rate: item.value, textColor: cellTextColor)
        
        return cell
    }
}
