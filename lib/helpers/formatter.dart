import 'package:intl/intl.dart';

class Formatter {
  static String formatCurrency(double value) {
    return NumberFormat.simpleCurrency(locale: 'vi').format(value);
  }
}
