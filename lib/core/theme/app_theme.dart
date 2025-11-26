import 'package:app_notes/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getTheme(bool isDarkMode) {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.soraTextTheme(
        ThemeData.light().textTheme.apply(
              bodyColor: isDarkMode ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
              displayColor: isDarkMode ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
            ),
      ),
      colorScheme: ColorScheme(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primary: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
        onPrimary: isDarkMode ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        secondary: isDarkMode ? AppColors.secondaryDark : AppColors.secondaryLight,
        onSecondary: isDarkMode ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        error: Colors.red,
        onError: Colors.white,
        surface: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
        onSurface: isDarkMode ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
      ),
      cardTheme: CardThemeData(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      ),
    );
  }
}
