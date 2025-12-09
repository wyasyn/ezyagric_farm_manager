import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static bool isOverdue(DateTime targetDate) {
    final today = DateTime.now();
    return targetDate.isBefore(DateTime(today.year, today.month, today.day));
  }

  static bool isUpcoming(DateTime targetDate) {
    final today = DateTime.now();
    return !targetDate.isBefore(DateTime(today.year, today.month, today.day));
  }
}
