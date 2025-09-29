import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Dark theme palette - Enhanced for maximum visibility
  static const Color gold = Color(0xFFFFC107); // More vibrant gold
  static const Color goldBright = Color(0xFFFFEB3B); // Even brighter for text
  static const Color ember = Color(0xFFFF8F00); // Orange-gold for emphasis
  static const Color obsidian = Color(0xFF121212); // True Material dark
  static const Color onyx = Color(0xFF1E1E1E); // Lighter surface
  static const Color graphite = Color(0xFF2C2C2C); // More visible gray
  static const Color smoke = Color(0xFF757575); // Higher contrast gray
  static const Color ivory = Color(
    0xFFFFFFFF,
  ); // Pure white for maximum contrast
  static const Color parchment = Color(0xFFE0E0E0); // Light gray for subtitles

  // Light theme palette - High contrast professional
  static const Color lightGold = Color(
    0xFFE65100,
  ); // Darker orange-gold for better contrast
  static const Color lightGoldAccent = Color(
    0xFFBF360C,
  ); // Even darker for text
  static const Color lightEmber = Color(0xFF5D4037); // Brown-gold for emphasis
  static const Color pearl = Color(0xFFFFFFFF); // Pure white
  static const Color cloud = Color(0xFFF5F5F5); // Light background
  static const Color mist = Color(0xFFEEEEEE); // Card background
  static const Color slate = Color(0xFF424242); // Dark gray for readable text
  static const Color charcoal = Color(0xFF212121); // Very dark for main text
  static const Color whisper = Color(0xFFE0E0E0); // Border color
  static const Color warmWhite = Color(0xFFFAFAFA); // Warm background

  static ThemeData get luxeDarkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: gold,
      onPrimary: Colors.black, // Pure black for maximum contrast on gold
      secondary: goldBright,
      onSecondary: Colors.black,
      tertiary: parchment,
      onTertiary: Colors.black,
      error: Color(0xFFFF5252), // Bright red
      onError: Colors.white,
      surface: onyx,
      onSurface: ivory, // Pure white text
      surfaceVariant: graphite,
      onSurfaceVariant: ivory, // Pure white
      outline: goldBright,
      shadow: Colors.black54,
      scrim: Colors.black87,
      inverseSurface: ivory,
      onInverseSurface: obsidian,
      inversePrimary: ember,
    );

    final textTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'Poppins',
      displayColor: ivory,
      bodyColor: ivory,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: obsidian,
      fontFamily: 'Poppins',
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: ivory,
          fontSize: 32, // Larger for better visibility
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: ivory,
          fontSize: 28,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: ivory,
          fontSize: 22,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          height: 1.6,
          color: ivory,
          fontSize: 16,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          height: 1.5,
          color: parchment, // Slightly dimmed for hierarchy
          fontSize: 14,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: ivory,
          fontSize: 14,
        ),
      ),
      // Enhanced button themes for better visibility
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black, // Pure black text
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bolder text
            color: Colors.black,
          ),
          elevation: 6,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldBright,
          side: const BorderSide(
            color: goldBright,
            width: 2.5, // Thicker border for visibility
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: goldBright,
          ),
        ),
      ),
      // Enhanced input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: graphite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: smoke, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: smoke, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldBright, width: 3.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF5252), width: 2.0),
        ),
        hintStyle: const TextStyle(
          color: parchment,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: goldBright,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: goldBright,
        suffixIconColor: goldBright,
      ),
      // Rest of your existing theme configuration...
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ivory,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: onyx,
        surfaceTintColor: Colors.transparent,
        elevation: 8, // Higher elevation for better shadow
        shadowColor: Colors.black.withValues(alpha: 0.6),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: graphite,
            width: 1,
          ), // Add border for definition
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: Colors.black,
        elevation: 12, // Higher elevation
        splashColor: goldBright,
      ),
      // ... rest of your theme
    );
  }

  static ThemeData get luxeLightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: lightGold,
      onPrimary: Colors.white,
      secondary: lightGoldAccent,
      onSecondary: Colors.white,
      tertiary: lightEmber,
      onTertiary: Colors.white,
      error: Color(0xFFD32F2F), // Darker red for better contrast
      onError: Colors.white,
      surface: pearl,
      onSurface: charcoal,
      surfaceVariant: mist,
      onSurfaceVariant: slate,
      outline: lightGoldAccent,
      shadow: Colors.black26,
      scrim: Colors.black45,
      inverseSurface: charcoal,
      onInverseSurface: pearl,
      inversePrimary: gold,
    );

    final textTheme = ThemeData.light().textTheme.apply(
      fontFamily: 'Poppins',
      displayColor: charcoal,
      bodyColor: charcoal,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: warmWhite,
      fontFamily: 'Poppins',
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: charcoal,
          fontSize: 32,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: charcoal,
          fontSize: 28,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: charcoal,
          fontSize: 22,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          height: 1.6,
          color: charcoal,
          fontSize: 16,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          height: 1.5,
          color: slate,
          fontSize: 14,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: charcoal,
          fontSize: 14,
        ),
      ),
      // Similar enhancements for light theme...
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          elevation: 4,
        ),
      ),
      // ... rest of light theme configuration
    );
  }
}
