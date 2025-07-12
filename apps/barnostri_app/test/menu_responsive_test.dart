import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/menu/presentation/utils/menu_responsive.dart';

void main() {
  group('menuCrossAxisCount portrait', () {
    test('returns expected values', () {
      expect(menuCrossAxisCount(1200, Orientation.portrait, 1.0), 5);
      expect(menuCrossAxisCount(1000, Orientation.portrait, 1.0), 4);
      expect(menuCrossAxisCount(800, Orientation.portrait, 1.0), 3);
      expect(menuCrossAxisCount(600, Orientation.portrait, 1.0), 2);
      expect(menuCrossAxisCount(400, Orientation.portrait, 1.0), 1);
    });
  });

  group('menuCrossAxisCount landscape', () {
    test('returns expected values', () {
      expect(menuCrossAxisCount(1200, Orientation.landscape, 1.0), 5);
      expect(menuCrossAxisCount(1000, Orientation.landscape, 1.0), 5);
      expect(menuCrossAxisCount(800, Orientation.landscape, 1.0), 4);
      expect(menuCrossAxisCount(600, Orientation.landscape, 1.0), 3);
      expect(menuCrossAxisCount(400, Orientation.landscape, 1.0), 2);
    });
  });
}
