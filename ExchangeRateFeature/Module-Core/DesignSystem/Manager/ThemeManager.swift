//
//  ThemeManager.swift
//  ExchangeRateFeature
//
//  Created by Panha on 5/11/26.
//

import UIKit

enum AppTheme: Int {
    case light
    case dark
}

extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}

final class ThemeManager {
    static let shared = ThemeManager()
    
    private let themeKey = "selectedAppTheme"
    
    var currentTheme: AppTheme {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: themeKey)
            return AppTheme(rawValue: rawValue) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            NotificationCenter.default.post(name: .themeDidChange, object: nil)
        }
    }
    
    var isDarkMode: Bool {
        return currentTheme == .dark
    }
}
