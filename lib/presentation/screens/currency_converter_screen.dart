import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/bloc/currency_bloc.dart';
import '../../business/bloc/currency_event.dart';
import '../../business/bloc/currency_state.dart';
import '../widgets/currency_dropdown.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/conversion_result_card.dart';
import '../widgets/loading_and_error.dart';

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.monetization_on,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text('Currency ConvertX'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CurrencyBloc>().add(const RefreshExchangeRates());
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh rates',
          ),
        ],
      ),
      body: BlocListener<CurrencyBloc, CurrencyState>(
        listener: (context, state) {
          if (state.status == CurrencyStatus.failure ||
              state.status == CurrencyStatus.conversionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<CurrencyBloc>().add(const ConvertCurrency());
                  },
                ),
              ),
            );
          }
        },
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            if (state.status == CurrencyStatus.initial ||
                state.status == CurrencyStatus.loading) {
              return const LoadingIndicator(message: 'Loading currencies...');
            }

            if (state.status == CurrencyStatus.failure) {
              return Center(
                child: ErrorCard(
                  message: state.errorMessage ?? 'Failed to load currencies',
                  onRetry: () {
                    context.read<CurrencyBloc>().add(const LoadCurrencies());
                  },
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Convert currencies with real-time exchange rates',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Currency selection section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // From currency
                          CurrencyDropdown(
                            selectedCurrency: state.baseCurrency,
                            currencies: state.currencies,
                            label: 'From Currency',
                            onChanged: (currency) {
                              if (currency != null) {
                                context.read<CurrencyBloc>().add(
                                  SelectBaseCurrency(currency),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // Swap button
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  context.read<CurrencyBloc>().add(
                                    const SwapCurrencies(),
                                  );
                                },
                                icon: Icon(
                                  Icons.swap_vert,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                iconSize: 32,
                                tooltip: 'Swap currencies',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // To currency
                          CurrencyDropdown(
                            selectedCurrency: state.targetCurrency,
                            currencies: state.currencies,
                            label: 'To Currency',
                            onChanged: (currency) {
                              if (currency != null) {
                                context.read<CurrencyBloc>().add(
                                  SelectTargetCurrency(currency),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amount input section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: AmountInputField(
                        amount: state.amount,
                        currencySymbol: state.baseCurrency?.symbol,
                        onChanged: (amount) {
                          context.read<CurrencyBloc>().add(
                            UpdateAmount(amount),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Conversion result or loading
                  if (state.status == CurrencyStatus.converting)
                    const LoadingIndicator(message: 'Converting...')
                  else if (state.status == CurrencyStatus.converted &&
                      state.conversionResult != null)
                    ConversionResultCard(
                      result: state.conversionResult!,
                      targetCurrencySymbol: state.targetCurrency?.symbol ?? '',
                    )
                  else if (state.status == CurrencyStatus.conversionError)
                    ErrorCard(
                      message: state.errorMessage ?? 'Conversion failed',
                      onRetry: () {
                        context.read<CurrencyBloc>().add(
                          const ConvertCurrency(),
                        );
                      },
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Enter an amount to see the conversion',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Quick amount buttons
                  if (state.baseCurrency != null &&
                      state.targetCurrency != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick amounts',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [1, 5, 10, 25, 50, 100, 500, 1000]
                                  .map(
                                    (amount) => OutlinedButton(
                                      onPressed: () {
                                        context.read<CurrencyBloc>().add(
                                          UpdateAmount(amount.toDouble()),
                                        );
                                      },
                                      child: Text(
                                        '${state.baseCurrency?.symbol}$amount',
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
