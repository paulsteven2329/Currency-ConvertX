import 'package:equatable/equatable.dart';

import '../../data/models/currency.dart';
import '../../data/models/exchange_rate.dart';

enum CurrencyStatus {
  initial,
  loading,
  success,
  failure,
  converting,
  converted,
  conversionError,
}

class CurrencyState extends Equatable {
  final CurrencyStatus status;
  final List<Currency> currencies;
  final Currency? baseCurrency;
  final Currency? targetCurrency;
  final double amount;
  final ConversionResult? conversionResult;
  final Map<String, double> exchangeRates;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const CurrencyState({
    this.status = CurrencyStatus.initial,
    this.currencies = const [],
    this.baseCurrency,
    this.targetCurrency,
    this.amount = 1.0,
    this.conversionResult,
    this.exchangeRates = const {},
    this.errorMessage,
    this.lastUpdated,
  });

  CurrencyState copyWith({
    CurrencyStatus? status,
    List<Currency>? currencies,
    Currency? baseCurrency,
    Currency? targetCurrency,
    double? amount,
    ConversionResult? conversionResult,
    Map<String, double>? exchangeRates,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return CurrencyState(
      status: status ?? this.status,
      currencies: currencies ?? this.currencies,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      amount: amount ?? this.amount,
      conversionResult: conversionResult ?? this.conversionResult,
      exchangeRates: exchangeRates ?? this.exchangeRates,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currencies,
    baseCurrency,
    targetCurrency,
    amount,
    conversionResult,
    exchangeRates,
    errorMessage,
    lastUpdated,
  ];
}
