import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';

ThemeData primaryThemeData = ThemeData(
  fontFamily: 'SourceSans',
  colorScheme: const ColorScheme(
      primary: Colors.white,
      secondary: Colors.black,
      error: Colors.red,
      surface: Colors.black,
      onError: Colors.red,
      outline: Colors.white,
      outlineVariant: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      brightness: Brightness.dark),
  scaffoldBackgroundColor: AppColors.background,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,

      side: const BorderSide(color: Colors.white), // Borda do botão
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  ),
);
