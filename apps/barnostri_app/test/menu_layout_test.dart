import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/menu/presentation/menu_layout.dart';

void main() {
  group('responsiveCrossAxisCount', () {
    test('returns 4 for wide screens', () {
      expect(responsiveCrossAxisCount(1200), 4);
    });
    test('returns 3 for medium screens', () {
      expect(responsiveCrossAxisCount(750), 3);
    });
    test('returns 2 for small screens', () {
      expect(responsiveCrossAxisCount(550), 2);
    });
    test('returns 1 for very small screens', () {
      expect(responsiveCrossAxisCount(400), 1);
    });
  });
}
