import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Centralized color scheme
class AppColors {
  static const Color primary = Color(0xFFF9A825); // A vibrant amber/gold
  static const Color background = Color(0xFF121212); // A very dark grey
  static const Color surface = Color(
    0xFF1E1E1E,
  ); // A slightly lighter dark grey for cards
  static const Color onSurface = Color(0xFFE0E0E0); // A light grey for text
  static const Color error = Color(0xFFCF6679);
}

final appTheme = ThemeData(
  // 1. Opt-in to Material 3
  useMaterial3: true,

  // 2. Build the ColorScheme using the modern .dark() constructor
  colorScheme: ColorScheme.dark().copyWith(
    primary: AppColors.primary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
  ),

  // 3. Set specific theme properties
  scaffoldBackgroundColor: AppColors.background,

  // Define the typography using Google Fonts (this remains the same)
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme,
  ).apply(bodyColor: AppColors.onSurface, displayColor: AppColors.onSurface),

  // Define the theme for TextFormFields (this remains the same)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
    ),
    labelStyle: const TextStyle(color: AppColors.onSurface),
  ),

  // Define the theme for ElevatedButtons (this remains the same)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),

  // Define the theme for TextButtons (this remains the same)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      // Use withAlpha instead of withOpacity
      foregroundColor: AppColors.primary.withAlpha(204),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    ),
  ),
);
