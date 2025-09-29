import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Configuration class for Android 14 specific optimizations
/// Especially optimized for 320x640 resolution screens
class Android14Config {
  // Screen density configurations for Android 14
  static const Map<String, double> screenDensities = {
    'ldpi': 120.0, // ~0.75
    'mdpi': 160.0, // ~1.0 (baseline)
    'hdpi': 240.0, // ~1.5
    'xhdpi': 320.0, // ~2.0
    'xxhdpi': 480.0, // ~3.0
    'xxxhdpi': 640.0, // ~4.0
  };

  // Android 14 Material You color optimizations
  static const List<Color> android14AccentColors = [
    Color(0xFF1976D2), // Blue
    Color(0xFF388E3C), // Green
    Color(0xFFF57C00), // Orange
    Color(0xFF7B1FA2), // Purple
    Color(0xFFD32F2F), // Red
    Color(0xFF00796B), // Teal
  ];

  // Android 14 system bar configuration
  static SystemUiOverlayStyle getSystemUIOverlayStyle({
    required bool isDarkMode,
    required bool isSmallScreen,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFFAFAFA),
      systemNavigationBarIconBrightness: isDarkMode
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  // Performance optimizations for low-end devices
  static const Map<String, dynamic> performanceSettings = {
    'animationDuration': 200, // Reduced animation duration
    'shadowOpacity': 0.15, // Reduced shadow opacity
    'blurRadius': 8.0, // Reduced blur radius
    'elevationMultiplier': 0.75, // Reduced elevation for performance
  };

  // Touch target optimizations for small screens
  static double getMinTouchTarget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 320) {
      return 44.0; // Android accessibility minimum
    } else if (screenWidth <= 360) {
      return 46.0;
    } else {
      return 48.0; // Standard Material Design
    }
  }

  // Optimized spacing for Android 14 (320x640)
  static EdgeInsets getOptimizedPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth <= 320 && screenHeight <= 640) {
      return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
    } else if (screenWidth <= 360) {
      return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
    }
  }

  // Android 14 haptic feedback patterns
  static void provideHapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.lightImpact:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.mediumImpact:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavyImpact:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selectionClick:
        HapticFeedback.selectionClick();
        break;
    }
  }

  // Memory optimization settings
  static const Map<String, int> memorySettings = {
    'maxImageCacheSize': 50 * 1024 * 1024, // 50MB for small devices
    'maxImageCacheCount': 100,
    'thumbnailSize': 150, // Reduced thumbnail size
  };

  // Battery optimization settings
  static const Map<String, dynamic> batteryOptimizations = {
    'reduceAnimations': true,
    'lowerFrameRate': false, // Keep smooth for user experience
    'optimizeNetworkCalls': true,
    'cacheAggressively': true,
  };

  // Android 14 specific edge-to-edge configuration
  static void configureEdgeToEdge() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Configure system settings for better text rendering
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: true,
        systemNavigationBarContrastEnforced: true,
      ),
    );
  }

  // Optimized theme configuration for Android 14
  static ThemeData getOptimizedThemeData({
    required ColorScheme colorScheme,
    required bool isSmallScreen,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Optimized button themes for small screens
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(isSmallScreen ? 88 : 100, isSmallScreen ? 40 : 44),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isSmallScreen ? 8 : 10,
          ),
          textStyle: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Optimized input decoration for small screens
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 10 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
        ),
      ),

      // Optimized card theme
      cardTheme: CardThemeData(
        margin: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 4 : 6,
        ),
        elevation: isSmallScreen ? 2 : 4,
      ),

      // Optimized list tile theme
      listTileTheme: ListTileThemeData(
        minVerticalPadding: isSmallScreen ? 4 : 8,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
        ),
      ),
    );
  }

  // Network optimization for limited data plans
  static const Map<String, dynamic> networkOptimizations = {
    'compressImages': true,
    'cacheMaxAge': 3600, // 1 hour cache
    'maxConcurrentConnections': 3,
    'timeoutDuration': 15000, // 15 seconds
  };

  // Android 14 notification optimization
  static const Map<String, dynamic> notificationSettings = {
    'importance': 'default',
    'showBadge': true,
    'enableVibration': true,
    'enableLights': true,
    'groupMessages': true,
  };

  // Accessibility optimizations for Android 14
  static bool shouldReduceAnimations(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  static double getOptimizedFontScale(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    // Clamp text scale factor for better readability on small screens
    return textScaler.scale(1.0).clamp(0.85, 1.3);
  }

  // Configure text rendering for crisp display
  static TextStyle getOptimizedTextStyle({
    required double fontSize,
    required Color color,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontFamily: fontFamily ?? 'Poppins',
      decoration: TextDecoration.none,
      height: 1.4,
      // Ensure crisp text rendering
      fontFeatures: const [
        FontFeature.enable('liga'), // Enable ligatures
        FontFeature.enable('kern'), // Enable kerning
      ],
    );
  }
}

enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
}
