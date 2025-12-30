import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate.g.dart';

@JsonSerializable()
class ExchangeRateResponse extends Equatable {
  final bool success;
  final String? error;
  final Map<String, double>? rates;
  final String? base;
  final DateTime? timestamp;

  const ExchangeRateResponse({
    required this.success,
    this.error,
    this.rates,
    this.base,
    this.timestamp,
  });

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateResponseToJson(this);

  @override
  List<Object?> get props => [success, error, rates, base, timestamp];
}

@JsonSerializable()
class ConversionResult extends Equatable {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double convertedAmount;
  final double exchangeRate;
  final DateTime timestamp;

  const ConversionResult({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedAmount,
    required this.exchangeRate,
    required this.timestamp,
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) =>
      _$ConversionResultFromJson(json);

  Map<String, dynamic> toJson() => _$ConversionResultToJson(this);

  @override
  List<Object> get props => [
    amount,
    fromCurrency,
    toCurrency,
    convertedAmount,
    exchangeRate,
    timestamp,
  ];
}
