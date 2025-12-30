// API Constants
class ApiConstants {
  // Using exchangerate-api.com which provides free API
  static const String baseUrl = 'https://api.exchangerate-api.com/v4';
  static const String latestEndpoint = '/latest';

  // Alternative: Fixer.io (requires API key)
  // static const String baseUrl = 'https://api.fixer.io/v1';
  // static const String apiKey = 'YOUR_API_KEY';

  // Request headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Cache duration
  static const Duration cacheExpiration = Duration(minutes: 30);
}

// App Constants
class AppConstants {
  static const String appName = 'Currency ConvertX';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String keyBaseCurrency = 'base_currency';
  static const String keyTargetCurrency = 'target_currency';
  static const String keyLastAmount = 'last_amount';
  static const String keyCachedRates = 'cached_rates';
  static const String keyCacheTimestamp = 'cache_timestamp';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);
}
