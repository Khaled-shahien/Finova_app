import 'package:intl/intl.dart';

/// Shared date formatting helpers for UI labels.
class DateFormatter {
  DateFormatter._();

  static String dayMonthYear(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String longDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  static String monthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  static String time(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String ledgerHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = today.difference(target).inDays;

    final prefix = switch (difference) {
      0 => 'Today',
      1 => 'Yesterday',
      _ => DateFormat('EEEE').format(date),
    };

    final suffix = DateFormat('MMM dd, yyyy').format(date).toUpperCase();
    return '$prefix $suffix';
  }
}
