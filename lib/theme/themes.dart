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
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // Background branco
    hintStyle:
        const TextStyle(color: Colors.grey), // Cor do hint (texto de dica)
    labelStyle: const TextStyle(color: Colors.black), // Cor do label (rótulo)
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(color: Colors.white),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
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
