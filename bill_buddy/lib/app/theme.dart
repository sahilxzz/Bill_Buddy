import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFB02A30),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFB02A30),
    ),
  );
}