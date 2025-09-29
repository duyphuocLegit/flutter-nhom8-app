import 'package:flutter/material.dart';

// Updated colors for better visibility
const Color kGoldPrimary = Color(0xFFFFD700); // Brighter gold
const Color kGoldSecondary = Color(0xFFFFF066); // More vibrant gold
const Color kGoldDeep = Color(0xFFCC9A00); // Deeper gold

const Color kYellowLight = Color(0xFFFFF8DC); // Lighter yellow
const Color kYellowDark = Color(0xFFB8860B); // Darker gold
const Color kYellow = kGoldPrimary;

const Color kBlueLight = Color(0xFF404040); // Lighter graphite
const Color kBlueDark = kGoldPrimary;
const Color kBlue = Color(0xFF5A5A5A); // Lighter smoke

const Color kRed = Color(0xFFFF5555); // Brighter red
const Color kRedDark = Color(0xFFCC4444); // Darker red
const Color kRedLight = Color(0xFF4A2C2C); // Lighter red background

const Color kWhite = Color(0xFFFFFFF0); // Pure ivory white
const Color kDark = Color(0xFF1A1A1A); // Lighter black
const Color kSurface = Color(0xFF2D2D2D); // Much lighter surface
const Color kSlate = Color(0xFF404040); // Lighter slate
const Color kSmoke = Color(0xFF5A5A5A); // Lighter smoke
const Color kTextMuted = Color(0xFFCCCCCC); // Much lighter muted text

class MyThemeColor {
  static const Color backgroundColor = kDark;
  static const Color textColor = kWhite;
  static const Color subText = kTextMuted;
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF404040)], // Lighter gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Responsive sizing constants for Android 14 (320x640)
class ResponsiveSizing {
  // Screen breakpoints
  static const double smallScreenWidth = 360;
  static const double mediumScreenWidth = 400;
  static const double largeScreenWidth = 600;

  // Padding constants
  static const double smallScreenPadding = 12.0;
  static const double mediumScreenPadding = 16.0;
  static const double largeScreenPadding = 20.0;

  // Font size constants
  static const double smallHeadingSize = 18.0;
  static const double mediumHeadingSize = 22.0;
  static const double largeHeadingSize = 28.0;

  static const double smallBodySize = 13.0;
  static const double mediumBodySize = 14.0;
  static const double largeBodySize = 16.0;

  // Button height constants
  static const double smallButtonHeight = 44.0;
  static const double mediumButtonHeight = 48.0;
  static const double largeButtonHeight = 52.0;

  // Icon size constants
  static const double smallIconSize = 20.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 28.0;
}
