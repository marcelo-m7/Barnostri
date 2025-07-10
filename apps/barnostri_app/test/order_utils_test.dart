import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';

void main() {
  test('formatDateTime returns dd/MM/yyyy HH:mm', () async {
    await initializeDateFormatting('pt_BR');
    final date = DateTime(2024, 7, 9, 14, 30);
    final formatted = OrderService.formatDateTime(
      date,
      locale: 'pt_BR',
    );
    expect(formatted, '09/07/2024 14:30');
  });
}
