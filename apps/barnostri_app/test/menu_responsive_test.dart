import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/menu/presentation/utils/menu_responsive.dart';

void main() {
  test('menuCrossAxisCount returns expected values', () {
    expect(menuCrossAxisCount(1200), 5);
    expect(menuCrossAxisCount(1000), 4);
    expect(menuCrossAxisCount(800), 3);
    expect(menuCrossAxisCount(600), 2);
    expect(menuCrossAxisCount(400), 1);
  });
}
