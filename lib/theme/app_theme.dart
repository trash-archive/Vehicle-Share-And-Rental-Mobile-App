import 'package:flutter/material.dart';

class MovanaColors {
  // Primary brand palette
  static const Color primary = Color(0xFF0B6E4F);       // Deep forest green
  static const Color primaryLight = Color(0xFF18A56C);   // Vibrant green
  static const Color primaryDark = Color(0xFF084D37);    // Dark green
  static const Color primarySurface = Color(0xFFE8F5F0); // Light mint bg

  // Accent
  static const Color accent = Color(0xFFFF6B35);         // Warm orange
  static const Color accentLight = Color(0xFFFF8F65);    // Soft orange
  static const Color accentSurface = Color(0xFFFFF0EB);  // Peach tint

  // Neutrals
  static const Color ink = Color(0xFF0D1117);            // Near black
  static const Color inkMedium = Color(0xFF3D4450);      // Dark gray
  static const Color inkLight = Color(0xFF6B7280);       // Medium gray
  static const Color border = Color(0xFFE5E7EB);         // Light border
  static const Color surface = Color(0xFFF8F9FA);        // Off white
  static const Color white = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Category colors
  static const Color motorColor = Color(0xFF6366F1);
  static const Color carColor = Color(0xFF0EA5E9);
  static const Color truckColor = Color(0xFFF59E0B);
  static const Color constructionColor = Color(0xFFEF4444);
  static const Color agriColor = Color(0xFF10B981);
  static const Color waterColor = Color(0xFF06B6D4);
}

class MovanaTextStyles {
  static const String displayFont = 'Syne';
  static const String bodyFont = 'Inter';

  static const TextStyle displayXL = TextStyle(
    fontFamily: displayFont,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -0.5,
    color: MovanaColors.ink,
  );

  static const TextStyle displayLG = TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.3,
    color: MovanaColors.ink,
  );

  static const TextStyle displayMD = TextStyle(
    fontFamily: displayFont,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: MovanaColors.ink,
  );

  static const TextStyle headingSM = TextStyle(
    fontFamily: displayFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: MovanaColors.ink,
  );

  static const TextStyle bodyLG = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: MovanaColors.inkMedium,
  );

  static const TextStyle bodyMD = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: MovanaColors.inkMedium,
  );

  static const TextStyle bodySM = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: MovanaColors.inkLight,
  );

  static const TextStyle labelLG = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: MovanaColors.ink,
  );

  static const TextStyle labelMD = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: MovanaColors.ink,
  );

  static const TextStyle labelSM = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: MovanaColors.ink,
  );
}

class MovanaTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: MovanaColors.primary,
        primary: MovanaColors.primary,
        onPrimary: MovanaColors.white,
        secondary: MovanaColors.accent,
        surface: MovanaColors.surface,
        background: MovanaColors.white,
        error: MovanaColors.error,
      ),
      scaffoldBackgroundColor: MovanaColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: MovanaColors.white,
        foregroundColor: MovanaColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: MovanaTextStyles.headingSM,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MovanaColors.primary,
          foregroundColor: MovanaColors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: MovanaTextStyles.labelLG,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MovanaColors.primary,
          side: const BorderSide(color: MovanaColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: MovanaTextStyles.labelLG,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MovanaColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MovanaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MovanaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MovanaColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: MovanaTextStyles.bodyMD.copyWith(color: MovanaColors.inkLight),
        labelStyle: MovanaTextStyles.labelMD,
      ),
      cardTheme: CardThemeData(
        color: MovanaColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: MovanaColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: MovanaColors.surface,
        selectedColor: MovanaColors.primarySurface,
        labelStyle: MovanaTextStyles.labelSM,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: MovanaColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: MovanaColors.white,
        selectedItemColor: MovanaColors.primary,
        unselectedItemColor: MovanaColors.inkLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: MovanaColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

// Spacing system
class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
  static const double page = 20;
}

// Border radius system
class Radii {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double pill = 100;
  static const double circle = 9999;
}
