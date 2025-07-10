import 'package:flutter_test/flutter_test.dart';
int menuCrossAxisCount(double width) {
  if (width >= 1000) return 4;
  if (width >= 700) return 3;
  if (width >= 500) return 2;
  return 1;
}

void main() {
  test('menuCrossAxisCount returns expected values', () {
    expect(menuCrossAxisCount(1200), 4);
    expect(menuCrossAxisCount(800), 3);
    expect(menuCrossAxisCount(600), 2);
    expect(menuCrossAxisCount(400), 1);
  });
}
