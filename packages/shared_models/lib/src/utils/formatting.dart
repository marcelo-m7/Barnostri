import 'package:intl/intl.dart';

String formatCurrency(
  double value, {
  String locale = 'pt_BR',
  String symbol = 'R\$',
}) {
  final formatter = NumberFormat.currency(locale: locale, symbol: symbol);
  return formatter.format(value);
}
