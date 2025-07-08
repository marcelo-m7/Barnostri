import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.teal,
);
final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.teal,
  brightness: Brightness.dark,
);

final ThemeData lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  useMaterial3: true,
);
