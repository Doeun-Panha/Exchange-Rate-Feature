//
//  ViewController.swift
//  ExchangeRateFeature
//
//  Created by Panha on 4/11/26.
//

import UIKit

class ExchangeRateViewController: UIViewController {
    private let viewModel = ExchangeRateViewModel()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
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
        button.layer.borderColor = UIColor(hex: "caa243").cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapThemeButton), for: .touchUpInside)
        return button
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

    private lazy var themeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lightThemeButton, darkThemeButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var lightThemeButton: UIButton = {
        return createThemeOptionButton(title: "☀️ White Cream", action: #selector(selectLightTheme))
    }()

    private lazy var darkThemeButton: UIButton = {
        return createThemeOptionButton(title: "🌙 Matte Smoke", action: #selector(selectDarkTheme))
    }()
    
    private func createThemeOptionButton(title: String, textColor: UIColor = UIColor(hex: "272b2d"), action: Selector) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.baseForegroundColor = textColor
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 14, weight: .medium)
            return outgoing
        }
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        configuration.imagePadding = 0
        
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
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
    
    private let contentView = ExchangeRateContentView()
    
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleThemeChange),
            name: .themeDidChange,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateTheme(isDark: ThemeManager.shared.isDarkMode)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .themeDidChange,
            object: nil
        )
    }
}

extension ExchangeRateViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        view.addSubview(activityIndicatorView)
        
        containerView.addSubview(appIconImageView)
        containerView.addSubview(headerStackView)
        containerView.addSubview(themeButton)
        
        containerView.addSubview(contentView)
        
        containerView.addSubview(dismissOverlayView)
        containerView.addSubview(themeDropdownView)
        
        themeDropdownView.addSubview(themeStackView)
        
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
            
            contentView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        contentView.tableView.dataSource = nil
        contentView.tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        contentView.tableView.refreshControl = refreshControl
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
        
        let cellTextColor = ThemeManager.shared.isDarkMode ? UIColor.white : UIColor(hex: "272b2d")
        cell.configure(with: item.key, rate: item.value, textColor: cellTextColor)
        
        return cell
    }
}

extension ExchangeRateViewController {
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
        ThemeManager.shared.currentTheme = .light
    }
    
    @objc private func selectDarkTheme() {
        didTapThemeButton()
        ThemeManager.shared.currentTheme = .dark
    }
    
    @objc private func handleThemeChange() {
        updateTheme(isDark: ThemeManager.shared.isDarkMode)
    }
}

extension ExchangeRateViewController {
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
                
                self.contentView.tableView.reloadData()
                self.descriptionLabel.text = "Base: \(self.viewModel.baseCurrency) | \(self.viewModel.lastUpdatedDate)"
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.loadRates()
        })
        present(alert, animated: true)
    }
    
    private func updateTheme(isDark: Bool) {
        let backgroundColor = isDark ? UIColor(hex: "636366") : .white
        let textColor = isDark ? .white : UIColor(hex: "272b2d")
        let descriptionLabelColor = isDark ? UIColor.white.withAlphaComponent(0.75) : UIColor(hex: "272b2d").withAlphaComponent(0.75)
        let logoName = isDark ? "AppLogo (Dark Mode)" : "AppLogo"
        let themeIconName = isDark ? "Smoke&Matte-theme" : "White&Cream-theme"
        let dropdownBackground = isDark ? UIColor(hex: "636366") : .white
        let buttonTextColor = isDark ? UIColor.white : UIColor(hex: "272b2d")
        
        view.backgroundColor = backgroundColor
        appIconImageView.image = UIImage(named: logoName)
        themeButton.setImage(UIImage(named: themeIconName), for: .normal)
        
        themeDropdownView.backgroundColor = dropdownBackground
        lightThemeButton.configuration?.baseForegroundColor = buttonTextColor
        darkThemeButton.configuration?.baseForegroundColor = buttonTextColor
        
        titleLabel.textColor = textColor
        descriptionLabel.textColor = descriptionLabelColor
        
        contentView.updateTheme(isDark: isDark)
    }
}
