import 'package:test/test.dart';
import 'package:shared_models/src/utils/formatting.dart';

void main() {
  group('formatCurrency', () {
    test('formats BRL values correctly', () {
      final result = formatCurrency(10.5, locale: 'pt_BR', symbol: 'R\$');
      expect(result.contains('10,50'), isTrue);
    });

    test('supports different locales', () {
      final result = formatCurrency(10.5, locale: 'en_US', symbol: '\$');
      expect(result.contains('10.50'), isTrue);
    });
  });
}
