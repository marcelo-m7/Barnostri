import 'package:test/test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('OrderStatus enum', () {
    test('fromString returns correct value', () {
      expect(OrderStatus.fromString('Pronto'), OrderStatus.pronto);
    });
  });

  group('PaymentMethod enum', () {
    test('fromString returns correct value', () {
      expect(PaymentMethod.fromString('Cart\u00e3o'), PaymentMethod.cartao);
    });
  });
}
