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
}
