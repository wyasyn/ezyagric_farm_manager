import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatUgx(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'UGX ${formatter.format(amount)}';
  }

  static String formatVariance(double variance) {
    final abs = variance.abs();
    final formatted = formatUgx(abs);
    if (variance > 0) {
      return '+$formatted';
    } else if (variance < 0) {
      return '-$formatted';
    }
    return formatted;
  }
}
