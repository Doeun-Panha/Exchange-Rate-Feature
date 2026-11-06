
# Exchange Rate Feature Module

A currency exchange rate tracking application built with **UIKit**, leveraging clean **MVVM** architecture, secure API configuration handling, and a global multi-theme engine.

---

## 🌟 Key Features

- **Secure API Configuration**: API endpoints and keys are completely decoupled from source code using a local `.gitignore`-protected `Config.xcconfig` file and bridged via `Info.plist`.
- **Global Theme Engine**: Seamless switching between **Light ("White Cream")** and **Dark ("Matte Smoke")** modes synchronized app-wide using a singleton `ThemeManager` and `NotificationCenter`.
- **Modular Component Architecture**: View complexity is minimized by breaking down layouts into reusable custom `UIView` components, custom table view cells, and decoupled ViewControllers.
- **Modern Asynchronous Networking**: Efficient network calls powered by Swift's native `async/await` and `URLSession`, complete with error handling, loading states, and pull-to-refresh capabilities.
- **Clean MVVM Separation**: Clear boundaries between Models, ViewModels, Services, and Views ensuring maintainable and testable code.

---

## 📁 Repository Structure

The project follows a clean, modular feature-first structure:

```text
ExchangeRateFeature/
├── Config.xcconfig
├── .gitignore
├── ExchangeRateFeature/
│   ├── Module-Core/
│   │   ├── DesignSystem/
│   │   ├── Manager/
│   │   │   └── ThemeManager
│   │   └── Utility/
│   │       └── Extension/
│   │           └── Color + Extension
│   ├── Module-Feature/
│   │   └── Feature-Exchangerate/
│   │       ├── Models/
│   │       │   └── ExchangeRateModel
│   │       ├── Services/
│   │       │   └── ExchangeRateService
│   │       ├── ViewModels/
│   │       │   └── ExchangeRateViewModel
│   │       └── Views/
│   │           ├── CustomViews/
│   │           │   ├── ExchangeRateContentView
│   │           │   └── RateTableViewCell
│   │           └── ViewControllers/
│   │               └── ExchangeRateViewController
│   └── Module-Main/
│       └── Views/
│           └── LaunchScreen/
│               └── LaunchScreen
├── AppDelegate
├── SceneDelegate
├── Assets
└── Info
