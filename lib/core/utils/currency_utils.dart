import 'package:intl/intl.dart';

class CurrencyUtils {
  static String formatCurrency({
    required double amount,
    required String currencyCode,
    String? symbol,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol ?? currencyCode,
      decimalDigits: amount >= 1 ? 2 : 6,
    );
    return formatter.format(amount);
  }

  static String formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    } else if (amount >= 1) {
      return amount.toStringAsFixed(2);
    } else {
      return amount.toStringAsFixed(6);
    }
  }

  static String formatExchangeRate(double rate) {
    if (rate >= 1000) {
      return rate.toStringAsFixed(2);
    } else if (rate >= 1) {
      return rate.toStringAsFixed(4);
    } else {
      return rate.toStringAsFixed(6);
    }
  }

  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }
}

class ValidationUtils {
  static bool isValidAmount(String input) {
    if (input.isEmpty) return false;
    final amount = double.tryParse(input);
    return amount != null && amount >= 0;
  }

  static double parseAmount(String input) {
    final amount = double.tryParse(input);
    return amount ?? 0.0;
  }
}

class NetworkUtils {
  static bool isNetworkError(String error) {
    final networkErrorKeywords = [
      'network',
      'connection',
      'timeout',
      'dns',
      'socket',
      'unreachable',
    ];

    final errorLowerCase = error.toLowerCase();
    return networkErrorKeywords.any(
      (keyword) => errorLowerCase.contains(keyword),
    );
  }

  static String getReadableErrorMessage(String error) {
    if (isNetworkError(error)) {
      return 'Please check your internet connection and try again.';
    } else if (error.contains('HTTP')) {
      return 'The currency service is temporarily unavailable.';
    } else if (error.contains('timeout')) {
      return 'The request took too long. Please try again.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }
}
