import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String formatAmount(double amount, String code) {
    final decimals = (code == 'JPY' || code == 'KRW') ? 0 : 2;
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
    );
    return formatter.format(amount);
  }

  static String formatRate(double rate) {
    if (rate >= 100) return rate.toStringAsFixed(2);
    if (rate >= 10) return rate.toStringAsFixed(3);
    return rate.toStringAsFixed(4);
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
