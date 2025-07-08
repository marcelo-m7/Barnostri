import 'package:test/test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('OrderStatus enum', () {
    test('fromString returns correct value', () {
      expect(OrderStatus.fromString('Ready'), OrderStatus.ready);
    });
  });

  group('PaymentMethod enum', () {
    test('fromString returns correct value', () {
      expect(PaymentMethod.fromString('Card'), PaymentMethod.card);
    });
  });
}
