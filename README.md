# Currency ConvertX 💱

A beautiful and professional currency converter application built with Flutter, featuring real-time exchange rates, Material 3 design, and advanced state management.

## ✨ Features

### Core Functionality
- **Real-time Exchange Rates**: Fetches live currency exchange rates from a reliable API
- **Multi-Currency Support**: Supports 20+ popular international currencies
- **Instant Conversion**: Real-time conversion as you type
- **Offline Caching**: Smart caching system for offline functionality
- **User Preferences**: Remembers your last used currencies and amounts

### User Experience
- **Material 3 Design**: Modern and beautiful UI following Material Design 3 guidelines
- **Android Green Theme**: Professional green color scheme with light and dark modes
- **Responsive Interface**: Optimized for different screen sizes
- **Smooth Animations**: Delightful transitions and loading states
- **Error Handling**: Comprehensive error handling with user-friendly messages

### Technical Excellence
- **Bloc State Management**: Clean and scalable state management architecture
- **Clean Architecture**: Well-organized code structure following best practices
- **Dependency Injection**: Proper dependency management with repositories
- **API Integration**: Robust HTTP client with error handling and retries

## 🎨 Design

The app features a professional **Android Green** color palette:
- Primary: Material Green (#4CAF50)
- Light variant: #81C784
- Dark variant: #388E3C
- Accent: #69F0AE

### Supported Currencies

🇺🇸 USD - US Dollar  
🇪🇺 EUR - Euro  
🇬🇧 GBP - British Pound  
🇯🇵 JPY - Japanese Yen  
🇦🇺 AUD - Australian Dollar  
🇨🇦 CAD - Canadian Dollar  
🇨🇭 CHF - Swiss Franc  
🇨🇳 CNY - Chinese Yuan  
🇸🇪 SEK - Swedish Krona  
🇳🇿 NZD - New Zealand Dollar  
🇲🇽 MXN - Mexican Peso  
🇸🇬 SGD - Singapore Dollar  
🇭🇰 HKD - Hong Kong Dollar  
🇳🇴 NOK - Norwegian Krone  
🇰🇷 KRW - South Korean Won  
🇹🇷 TRY - Turkish Lira  
🇷🇺 RUB - Russian Ruble  
🇮🇳 INR - Indian Rupee  
🇧🇷 BRL - Brazilian Real  
🇿🇦 ZAR - South African Rand

## 🏗️ Architecture

The project follows **Clean Architecture** principles:

```
lib/
├── business/
│   └── bloc/               # Business logic & state management
├── data/
│   ├── models/            # Data models and serialization
│   ├── repositories/      # Data repositories
│   └── services/          # API services
├── presentation/
│   ├── screens/           # UI screens
│   └── widgets/           # Reusable widgets
└── core/
    ├── constants/         # App constants
    ├── theme/            # Material 3 themes
    └── utils/            # Utility functions
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.4)
- Dart SDK
- Android Studio / VS Code
- Internet connection for API calls

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate JSON serialization code**
   ```bash
   dart run build_runner build
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

1. **Select Currencies**: Choose source and target currencies from the dropdown
2. **Enter Amount**: Type the amount you want to convert
3. **Instant Results**: See the converted amount instantly
4. **Swap Currencies**: Tap the swap button to quickly reverse conversion
5. **Quick Amounts**: Use preset amount buttons for common values
6. **Refresh Rates**: Pull down or tap refresh to update exchange rates

## 🔧 Configuration

### API Service
The app uses [ExchangeRate-API](https://api.exchangerate-api.com/) for real-time rates. You can switch to other providers by updating the `CurrencyApiService`.

### Caching
- Exchange rates are cached for 30 minutes
- User preferences are stored locally
- Offline mode available when cached data exists

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📦 Dependencies

### Core
- `flutter_bloc`: State management
- `equatable`: Value equality
- `http`: HTTP client
- `shared_preferences`: Local storage

### UI
- `cupertino_icons`: iOS-style icons
- `intl`: Internationalization

### Development
- `json_annotation` & `json_serializable`: JSON serialization
- `build_runner`: Code generation
- `flutter_lints`: Linting rules

## 🚀 Build & Release

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
flutter build apk --release
```

### Web Build
```bash
flutter build web
```

## 📊 Features Overview

| Feature | Status | Description |
|---------|--------|-------------|
| ✅ Real-time Rates | Complete | Live exchange rate fetching |
| ✅ Material 3 UI | Complete | Modern design system |
| ✅ Dark/Light Theme | Complete | Automatic theme switching |
| ✅ Offline Caching | Complete | 30-minute rate caching |
| ✅ Error Handling | Complete | Comprehensive error management |
| ✅ State Management | Complete | Bloc pattern implementation |
| ✅ User Preferences | Complete | Persistent settings |
| ✅ Multi-platform | Complete | Android, iOS, Web, Desktop |

---

Made with ❤️ and Flutter
