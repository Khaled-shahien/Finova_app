import 'package:intl/intl.dart';

/// Centralized currency formatting utility for consistent display across the app.
///
/// Formats amounts according to the design system's editorial style:
/// - Standard format: $X,XXX.XX
/// - Compact format for limited spaces
///
/// Example usage:
/// ```dart
/// CurrencyFormatter.format(1234.56); // '$1,234.56'
/// CurrencyFormatter.formatInt(1234); // '$1,234'
/// ```
class CurrencyFormatter {
  static final NumberFormat _format = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _intFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 0,
  );

  /// Format amount with 2 decimal places.
  ///
  /// Returns formatted string like `$1,234.56`
  static String format(double amount) {
    return _format.format(amount);
  }

  /// Format integer amount without decimals.
  ///
  /// Returns formatted string like `$1,234`
  static String formatInt(int amount) {
    return _intFormat.format(amount);
  }

  /// Format amount with custom symbol.
  static String formatWithSymbol(double amount, String symbol) {
    final format = NumberFormat.currency(
      locale: 'en_US',
      symbol: symbol,
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  /// Format percentage value.
  static String formatPercentage(double value, {int decimalPlaces = 1}) {
    final format = NumberFormat.decimalPattern('en_US');
    format.minimumFractionDigits = decimalPlaces;
    format.maximumFractionDigits = decimalPlaces;
    return '${format.format(value)}%';
  }
}
