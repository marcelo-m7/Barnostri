import 'package:test/test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('OrderStatus enum', () {
    test('fromString returns correct value', () {
      expect(OrderStatus.fromString('Ready'), OrderStatus.ready);
    });

    test('supports Portuguese values', () {
      expect(OrderStatus.fromString('Em preparo'), OrderStatus.preparing);
    });

    test('defaults to received for unknown values', () {
      expect(OrderStatus.fromString('unknown'), OrderStatus.received);
    });
  });

  group('PaymentMethod enum', () {
    test('fromString returns correct value', () {
      expect(PaymentMethod.fromString('Card'), PaymentMethod.card);
    });

    test('supports Portuguese values', () {
      expect(PaymentMethod.fromString('Cartão'), PaymentMethod.card);
    });

    test('defaults to pix for unknown values', () {
      expect(PaymentMethod.fromString('bitcoin'), PaymentMethod.pix);
    });
  });

  group('UserType enum', () {
    test('fromString returns correct value', () {
      expect(UserType.fromString('lojista'), UserType.lojista);
    });

    test('defaults to cliente', () {
      expect(UserType.fromString('unknown'), UserType.cliente);
    });
  });
}
