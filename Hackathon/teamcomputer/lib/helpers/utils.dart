import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final format = NumberFormat.simpleCurrency();
  return format.format(amount);
}
