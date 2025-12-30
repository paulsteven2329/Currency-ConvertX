import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/currency.dart';
import '../models/exchange_rate.dart';
import '../services/currency_api_service.dart';
import '../../core/constants/app_constants.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getSupportedCurrencies();
  Future<ExchangeRateResponse> getExchangeRates(String baseCurrency);
  Future<ConversionResult?> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });
  Future<void> cacheExchangeRates(
    String baseCurrency,
    Map<String, double> rates,
  );
  Future<Map<String, double>?> getCachedExchangeRates(String baseCurrency);
  Future<void> saveUserPreferences({
    String? baseCurrency,
    String? targetCurrency,
    double? lastAmount,
  });
  Future<Map<String, dynamic>> getUserPreferences();
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyApiService _apiService;
  final SharedPreferences _prefs;

  CurrencyRepositoryImpl({
    required CurrencyApiService apiService,
    required SharedPreferences prefs,
  }) : _apiService = apiService,
       _prefs = prefs;

  @override
  Future<List<Currency>> getSupportedCurrencies() async {
    // Return our predefined popular currencies
    // In a real app, you might fetch this from an API
    return Currency.popularCurrencies;
  }

  @override
  Future<ExchangeRateResponse> getExchangeRates(String baseCurrency) async {
    try {
      // First, try to get cached rates if they're not expired
      final cachedRates = await getCachedExchangeRates(baseCurrency);
      if (cachedRates != null) {
        return ExchangeRateResponse(
          success: true,
          rates: cachedRates,
          base: baseCurrency,
          timestamp: DateTime.now(),
        );
      }

      // Fetch fresh rates from API
      final response = await _apiService.getLatestRates(baseCurrency);

      // Cache the rates if successful
      if (response.success && response.rates != null) {
        await cacheExchangeRates(baseCurrency, response.rates!);
      }

      return response;
    } catch (e) {
      return ExchangeRateResponse(
        success: false,
        error: 'Failed to fetch exchange rates: ${e.toString()}',
      );
    }
  }

  @override
  Future<ConversionResult?> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return await _apiService.convertCurrency(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }

  @override
  Future<void> cacheExchangeRates(
    String baseCurrency,
    Map<String, double> rates,
  ) async {
    final cacheKey = '${AppConstants.keyCachedRates}_$baseCurrency';
    final timestampKey = '${AppConstants.keyCacheTimestamp}_$baseCurrency';

    await _prefs.setString(cacheKey, json.encode(rates));
    await _prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<Map<String, double>?> getCachedExchangeRates(
    String baseCurrency,
  ) async {
    final cacheKey = '${AppConstants.keyCachedRates}_$baseCurrency';
    final timestampKey = '${AppConstants.keyCacheTimestamp}_$baseCurrency';

    final cachedData = _prefs.getString(cacheKey);
    final timestamp = _prefs.getInt(timestampKey);

    if (cachedData != null && timestamp != null) {
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      // Check if cache is still valid
      if (now.difference(cacheTime) < ApiConstants.cacheExpiration) {
        try {
          final Map<String, dynamic> decoded = json.decode(cachedData);
          return decoded.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          );
        } catch (e) {
          // If cache is corrupted, remove it
          await _prefs.remove(cacheKey);
          await _prefs.remove(timestampKey);
        }
      } else {
        // Cache expired, remove it
        await _prefs.remove(cacheKey);
        await _prefs.remove(timestampKey);
      }
    }

    return null;
  }

  @override
  Future<void> saveUserPreferences({
    String? baseCurrency,
    String? targetCurrency,
    double? lastAmount,
  }) async {
    if (baseCurrency != null) {
      await _prefs.setString(AppConstants.keyBaseCurrency, baseCurrency);
    }
    if (targetCurrency != null) {
      await _prefs.setString(AppConstants.keyTargetCurrency, targetCurrency);
    }
    if (lastAmount != null) {
      await _prefs.setDouble(AppConstants.keyLastAmount, lastAmount);
    }
  }

  @override
  Future<Map<String, dynamic>> getUserPreferences() async {
    return {
      'baseCurrency': _prefs.getString(AppConstants.keyBaseCurrency) ?? 'USD',
      'targetCurrency':
          _prefs.getString(AppConstants.keyTargetCurrency) ?? 'EUR',
      'lastAmount': _prefs.getDouble(AppConstants.keyLastAmount) ?? 1.0,
    };
  }
}
