import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class AppTypography {
  static const String fontFamily = 'Inter'; // Consider using Inter or Poppins

  // Responsive typography methods
  static TextStyle heading1(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtils.responsive<double>(
      context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
      verySmall: 20,
      small: 22,
    ),
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtils.responsive<double>(
      context,
      mobile: 20,
      tablet: 22,
      desktop: 24,
      verySmall: 18,
      small: 19,
    ),
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static TextStyle body1(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtils.responsive<double>(
      context,
      mobile: 14,
      tablet: 15,
      desktop: 16,
      verySmall: 13,
      small: 13.5,
    ),
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle body2(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtils.responsive<double>(
      context,
      mobile: 12,
      tablet: 13,
      desktop: 14,
      verySmall: 11,
      small: 11.5,
    ),
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtils.responsive<double>(
      context,
      mobile: 10,
      tablet: 11,
      desktop: 12,
      verySmall: 9,
      small: 9.5,
    ),
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // Legacy static styles for backward compatibility
  static const TextStyle heading1Static = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2Static = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle body1Static = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle body2Static = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static const TextStyle captionStatic = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
}
