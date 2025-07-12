import 'package:flutter/material.dart';

int menuCrossAxisCount(
  double width,
  Orientation orientation,
) {
  final adjustedWidth = width;

  int count;
  if (adjustedWidth >= 1200) {
    count = 5;
  } else if (adjustedWidth >= 1000) {
    count = 4;
  } else if (adjustedWidth >= 700) {
    count = 3;
  } else if (adjustedWidth >= 500) {
    count = 2;
  } else {
    count = 1;
  }

  if (orientation == Orientation.landscape && count < 5) {
    count += 1;
  }

  return count;
}
