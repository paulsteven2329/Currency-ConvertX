import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/currency_repository.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _repository;
  Timer? _debounceTimer;

  CurrencyBloc({required CurrencyRepository repository})
    : _repository = repository,
      super(const CurrencyState()) {
    on<LoadCurrencies>(_onLoadCurrencies);
    on<LoadUserPreferences>(_onLoadUserPreferences);
    on<SelectBaseCurrency>(_onSelectBaseCurrency);
    on<SelectTargetCurrency>(_onSelectTargetCurrency);
    on<SwapCurrencies>(_onSwapCurrencies);
    on<UpdateAmount>(_onUpdateAmount);
    on<ConvertCurrency>(_onConvertCurrency);
    on<RefreshExchangeRates>(_onRefreshExchangeRates);
  }

  Future<void> _onLoadCurrencies(
    LoadCurrencies event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CurrencyStatus.loading));

      final currencies = await _repository.getSupportedCurrencies();

      emit(
        state.copyWith(status: CurrencyStatus.success, currencies: currencies),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CurrencyStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadUserPreferences(
    LoadUserPreferences event,
    Emitter<CurrencyState> emit,
  ) async {
    try {
      final preferences = await _repository.getUserPreferences();
      final currencies = state.currencies;

      if (currencies.isNotEmpty) {
        final baseCurrency = currencies.firstWhere(
          (currency) => currency.code == preferences['baseCurrency'],
          orElse: () => currencies.first,
        );

        final targetCurrency = currencies.firstWhere(
          (currency) => currency.code == preferences['targetCurrency'],
          orElse: () =>
              currencies.length > 1 ? currencies[1] : currencies.first,
        );

        emit(
          state.copyWith(
            baseCurrency: baseCurrency,
            targetCurrency: targetCurrency,
            amount: preferences['lastAmount'] as double,
          ),
        );

        // Trigger conversion with loaded preferences
        add(const ConvertCurrency());
      }
    } catch (error) {
      // Don't emit failure state for preferences, use defaults
      if (state.currencies.isNotEmpty) {
        emit(
          state.copyWith(
            baseCurrency: state.currencies.first,
            targetCurrency: state.currencies.length > 1
                ? state.currencies[1]
                : state.currencies.first,
          ),
        );
      }
    }
  }

  Future<void> _onSelectBaseCurrency(
    SelectBaseCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(state.copyWith(baseCurrency: event.currency));

    // Save preference
    await _repository.saveUserPreferences(baseCurrency: event.currency.code);

    // Trigger conversion
    add(const ConvertCurrency());
  }

  Future<void> _onSelectTargetCurrency(
    SelectTargetCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(state.copyWith(targetCurrency: event.currency));

    // Save preference
    await _repository.saveUserPreferences(targetCurrency: event.currency.code);

    // Trigger conversion
    add(const ConvertCurrency());
  }

  Future<void> _onSwapCurrencies(
    SwapCurrencies event,
    Emitter<CurrencyState> emit,
  ) async {
    if (state.baseCurrency != null && state.targetCurrency != null) {
      final newBaseCurrency = state.targetCurrency!;
      final newTargetCurrency = state.baseCurrency!;

      emit(
        state.copyWith(
          baseCurrency: newBaseCurrency,
          targetCurrency: newTargetCurrency,
        ),
      );

      // Save preferences
      await _repository.saveUserPreferences(
        baseCurrency: newBaseCurrency.code,
        targetCurrency: newTargetCurrency.code,
      );

      // Trigger conversion
      add(const ConvertCurrency());
    }
  }

  void _onUpdateAmount(UpdateAmount event, Emitter<CurrencyState> emit) {
    emit(state.copyWith(amount: event.amount));

    // Debounce the conversion to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(const ConvertCurrency());
    });

    // Save the amount preference
    _repository.saveUserPreferences(lastAmount: event.amount);
  }

  Future<void> _onConvertCurrency(
    ConvertCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    if (state.baseCurrency == null ||
        state.targetCurrency == null ||
        state.amount <= 0) {
      return;
    }

    try {
      emit(state.copyWith(status: CurrencyStatus.converting));

      final result = await _repository.convertCurrency(
        amount: state.amount,
        fromCurrency: state.baseCurrency!.code,
        toCurrency: state.targetCurrency!.code,
      );

      if (result != null) {
        emit(
          state.copyWith(
            status: CurrencyStatus.converted,
            conversionResult: result,
            lastUpdated: DateTime.now(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CurrencyStatus.conversionError,
            errorMessage: 'Failed to convert currency',
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: CurrencyStatus.conversionError,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshExchangeRates(
    RefreshExchangeRates event,
    Emitter<CurrencyState> emit,
  ) async {
    if (state.baseCurrency == null) return;

    try {
      emit(state.copyWith(status: CurrencyStatus.loading));

      final response = await _repository.getExchangeRates(
        state.baseCurrency!.code,
      );

      if (response.success && response.rates != null) {
        emit(
          state.copyWith(
            status: CurrencyStatus.success,
            exchangeRates: response.rates!,
            lastUpdated: DateTime.now(),
          ),
        );

        // Trigger conversion with fresh rates
        add(const ConvertCurrency());
      } else {
        emit(
          state.copyWith(
            status: CurrencyStatus.failure,
            errorMessage: response.error ?? 'Failed to refresh rates',
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: CurrencyStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
