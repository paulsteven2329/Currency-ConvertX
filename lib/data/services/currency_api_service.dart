import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rate.dart';
import '../../core/constants/app_constants.dart';

class CurrencyApiService {
  final http.Client _client;

  CurrencyApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the latest exchange rates for the given base currency
  Future<ExchangeRateResponse> getLatestRates(String baseCurrency) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.latestEndpoint}/$baseCurrency',
      );

      final response = await _client
          .get(url, headers: ApiConstants.defaultHeaders)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Convert the rates map to Map<String, double>
        final rates = (data['rates'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );

        return ExchangeRateResponse(
          success: true,
          rates: rates,
          base: data['base'] as String?,
          timestamp: data['date'] != null
              ? DateTime.tryParse(data['date'] as String)
              : DateTime.now(),
        );
      } else {
        return ExchangeRateResponse(
          success: false,
          error: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return ExchangeRateResponse(
        success: false,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Converts an amount from one currency to another
  Future<ConversionResult?> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      if (fromCurrency == toCurrency) {
        return ConversionResult(
          amount: amount,
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          convertedAmount: amount,
          exchangeRate: 1.0,
          timestamp: DateTime.now(),
        );
      }

      final response = await getLatestRates(fromCurrency);

      if (response.success && response.rates != null) {
        final rate = response.rates![toCurrency];
        if (rate != null) {
          final convertedAmount = amount * rate;

          return ConversionResult(
            amount: amount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            convertedAmount: convertedAmount,
            exchangeRate: rate,
            timestamp: response.timestamp ?? DateTime.now(),
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
