import 'package:flutter/material.dart';

class AppColors {
  static const Color nightDeep = Color(0xFF0E1410);
  static const Color nightWarm = Color(0xFF16201A);
  static const Color mishkatGold = Color(0xFFD4AF37);
  static const Color mishkatGoldSoft = Color(0xFFE8C766);
  static const Color moonCream = Color(0xFFF5EFE0);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFD4AF37),
      Color(0xFFE8C766),
      Color(0xFFD4AF37),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nightGradient = LinearGradient(
    colors: [
      Color(0xFF0E1410),
      Color(0xFF16201A),
      Color(0xFF0E1410),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static Color getMonthColor(String month) {
    final m = month.trim();
    if (m.contains('محرم')) return const Color(0xFFB91C1C);
    if (m.contains('صفر')) return const Color(0xFF1D4ED8);
    if (m.contains('ربيع') && (m.contains('أول') || m.contains('1'))) {
      return const Color(0xFF047857);
    }
    if (m.contains('ربيع')) return const Color(0xFF0E7490);
    if (m.contains('جمادى') && (m.contains('أول') || m.contains('1'))) {
      return const Color(0xFF7C3AED);
    }
    if (m.contains('جمادى')) return const Color(0xFF9333EA);
    if (m.contains('رجب')) return const Color(0xFFC2410C);
    if (m.contains('شعبان')) return const Color(0xFF0369A1);
    if (m.contains('رمضان')) return const Color(0xFF854D0E);
    if (m.contains('شوال')) return const Color(0xFFBE185D);
    if (m.contains('قعدة')) return const Color(0xFF4D7C0F);
    if (m.contains('حجة')) return const Color(0xFF991B1B);
    return const Color(0xFF6B7280);
  }
}