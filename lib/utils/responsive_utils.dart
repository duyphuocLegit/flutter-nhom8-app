import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Screen size categories for 320x640 (very small mobile)
  static const double verySmallWidth = 360;
  static const double smallWidth = 400;
  static const double mediumWidth = 600;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static bool isVerySmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= verySmallWidth;
  }

  static bool isSmallScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > verySmallWidth && width <= smallWidth;
  }

  // Responsive spacing
  static double getHorizontalPadding(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 12.0; // Reduced padding for 320px width
    } else if (isSmallScreen(context)) {
      return 16.0;
    } else if (isMobile(context)) {
      return 20.0;
    }
    return 24.0;
  }

  static double getVerticalSpacing(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 8.0; // Reduced vertical spacing
    } else if (isSmallScreen(context)) {
      return 12.0;
    } else if (isMobile(context)) {
      return 16.0;
    }
    return 20.0;
  }

  // Responsive font sizes
  static double getHeadingFontSize(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 20.0; // Smaller heading for 320px screens
    } else if (isSmallScreen(context)) {
      return 24.0;
    } else if (isMobile(context)) {
      return 28.0;
    }
    return 32.0;
  }

  static double getBodyFontSize(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 13.0; // Smaller body text
    } else if (isSmallScreen(context)) {
      return 14.0;
    } else if (isMobile(context)) {
      return 15.0;
    }
    return 16.0;
  }

  static double getButtonHeight(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 44.0; // Minimum touch target
    } else if (isSmallScreen(context)) {
      return 48.0;
    }
    return 50.0;
  }

  // Responsive icon sizes
  static double getIconSize(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 20.0;
    } else if (isSmallScreen(context)) {
      return 22.0;
    } else if (isMobile(context)) {
      return 24.0;
    }
    return 28.0;
  }

  static double getLargeIconSize(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 36.0;
    } else if (isSmallScreen(context)) {
      return 40.0;
    } else if (isMobile(context)) {
      return 44.0;
    }
    return 48.0;
  }

  // Card and container sizing
  static double getCardBorderRadius(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 8.0;
    } else if (isSmallScreen(context)) {
      return 10.0;
    }
    return 12.0;
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return const EdgeInsets.all(12.0);
    } else if (isSmallScreen(context)) {
      return const EdgeInsets.all(14.0);
    } else if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    }
    return const EdgeInsets.all(20.0);
  }

  // AppBar configuration
  static double getAppBarHeight(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 48.0; // Compact AppBar for small screens
    }
    return kToolbarHeight;
  }

  // Bottom navigation configuration
  static double getBottomNavHeight(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 56.0; // Standard height but ensure it fits
    }
    return 60.0;
  }

  // Screen-specific configurations for Android 14 (320x640)
  static bool isAndroid320x640(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= 320 && size.height <= 640;
  }

  // Optimizations for Android 14 specific features
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    if (isVerySmallScreen(context)) {
      // Ensure minimum padding but don't waste space
      return EdgeInsets.only(
        top: padding.top > 0 ? padding.top : 24.0,
        bottom: padding.bottom > 0 ? padding.bottom : 8.0,
        left: padding.left,
        right: padding.right,
      );
    }
    return padding;
  }

  // List item heights
  static double getListItemHeight(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 64.0; // Compact list items
    } else if (isSmallScreen(context)) {
      return 68.0;
    }
    return 72.0;
  }

  // Form field spacing
  static double getFormFieldSpacing(BuildContext context) {
    if (isVerySmallScreen(context)) {
      return 12.0;
    } else if (isSmallScreen(context)) {
      return 16.0;
    }
    return 20.0;
  }

  // Helper to get responsive value
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? verySmall,
    T? small,
  }) {
    if (isVerySmallScreen(context) && verySmall != null) {
      return verySmall;
    } else if (isSmallScreen(context) && small != null) {
      return small;
    } else if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    return mobile;
  }
}
