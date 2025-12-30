import 'package:equatable/equatable.dart';

import '../../data/models/currency.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class LoadCurrencies extends CurrencyEvent {
  const LoadCurrencies();
}

class LoadUserPreferences extends CurrencyEvent {
  const LoadUserPreferences();
}

class SelectBaseCurrency extends CurrencyEvent {
  final Currency currency;

  const SelectBaseCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}

class SelectTargetCurrency extends CurrencyEvent {
  final Currency currency;

  const SelectTargetCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}

class SwapCurrencies extends CurrencyEvent {
  const SwapCurrencies();
}

class UpdateAmount extends CurrencyEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object> get props => [amount];
}

class ConvertCurrency extends CurrencyEvent {
  const ConvertCurrency();
}

class RefreshExchangeRates extends CurrencyEvent {
  const RefreshExchangeRates();
}
