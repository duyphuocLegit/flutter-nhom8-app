import 'package:flutter/material.dart';
import '../config/android14_config.dart';

Widget customText(
  String text,
  double size,
  Color color, [
  FontWeight? fontWeight,
]) {
  return Builder(
    builder: (context) {
      return Text(
        text,
        style: Android14Config.getOptimizedTextStyle(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
        ),
        // Use optimized text scaling
        textScaler: TextScaler.linear(
          Android14Config.getOptimizedFontScale(context),
        ),
      );
    },
  );
}
