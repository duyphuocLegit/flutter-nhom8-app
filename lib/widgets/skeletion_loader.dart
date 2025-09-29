import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Add shimmer: ^3.0.0 to pubspec.yaml

class SkeletonLoader extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    Key? key,
    required this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceVariant.withOpacity(0.8),
      highlightColor: colorScheme.surfaceVariant.withOpacity(0.4),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}
