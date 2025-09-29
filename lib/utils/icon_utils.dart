import 'package:flutter/material.dart';

/// Utility class for rendering crisp icons on different screen densities
class IconUtils {
  /// Get optimized icon size based on screen density
  static double getOptimizedIconSize(BuildContext context, double baseSize) {
    final mediaQuery = MediaQuery.of(context);
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    // Adjust icon size based on pixel density for crisp rendering
    if (devicePixelRatio <= 1.0) {
      return baseSize;
    } else if (devicePixelRatio <= 2.0) {
      return baseSize * 1.1;
    } else if (devicePixelRatio <= 3.0) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.3;
    }
  }

  /// Create optimized icon widget
  static Widget createOptimizedIcon({
    required IconData iconData,
    required double size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return Icon(
      iconData,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      // Ensure icons render at pixel boundaries for crispness
      opticalSize: size,
    );
  }

  /// Get standard icon sizes for different contexts
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;
}
