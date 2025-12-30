// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateResponse _$ExchangeRateResponseFromJson(
  Map<String, dynamic> json,
) => ExchangeRateResponse(
  success: json['success'] as bool,
  error: json['error'] as String?,
  rates: (json['rates'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  base: json['base'] as String?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ExchangeRateResponseToJson(
  ExchangeRateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'error': instance.error,
  'rates': instance.rates,
  'base': instance.base,
  'timestamp': instance.timestamp?.toIso8601String(),
};

ConversionResult _$ConversionResultFromJson(Map<String, dynamic> json) =>
    ConversionResult(
      amount: (json['amount'] as num).toDouble(),
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      convertedAmount: (json['convertedAmount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ConversionResultToJson(ConversionResult instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'fromCurrency': instance.fromCurrency,
      'toCurrency': instance.toCurrency,
      'convertedAmount': instance.convertedAmount,
      'exchangeRate': instance.exchangeRate,
      'timestamp': instance.timestamp.toIso8601String(),
    };
