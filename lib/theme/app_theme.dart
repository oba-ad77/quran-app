import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ثيم التطبيق — المشكاة
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Tajawal';

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color bg = isDark ? AppColors.nightDeep : AppColors.moonCream;
    final Color surface = isDark ? AppColors.nightWarm : Colors.white;
    final Color textColor =
        isDark ? AppColors.moonCream : AppColors.nightDeep;
    final Color accent = AppColors.mishkatGold;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      primaryColor: accent,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
        primary: accent,
        secondary: AppColors.mishkatGoldSoft,
        surface: surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.nightDeep : surface,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      iconTheme: IconThemeData(color: textColor),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        thumbColor: accent,
        inactiveTrackColor: accent.withValues(alpha: 0.15),
        overlayColor: accent.withValues(alpha: 0.15),
      ),
    );
  }
}