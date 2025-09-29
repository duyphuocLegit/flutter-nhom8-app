import 'package:flutter/material.dart';

/// Utility class for theme-related helper functions
class ThemeUtils {
  /// Creates an elevated surface color by blending an overlay with the surface
  static Color elevatedSurface(ColorScheme scheme, double overlayOpacity) {
    final overlay = scheme.onSurface.withOpacity(overlayOpacity);
    return Color.alphaBlend(overlay, scheme.surface);
  }

  /// Priority color mapping for consistency across the app
  static final Map<String, Color> priorityColors = {
    'high': Colors.red,
    'medium': Colors.orange,
    'low': Colors.green,
  };

  /// Get priority color with fallback
  static Color getPriorityColor(String priority) =>
      priorityColors[priority] ?? Colors.blue;

  /// Creates a consistent card decoration
  static BoxDecoration createCardDecoration(
    ColorScheme colorScheme, {
    double borderRadius = 20,
    double borderOpacity = 0.16,
    double gradientStartOpacity = 0.26,
    double gradientEndOpacity = 0.14,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: colorScheme.primary.withOpacity(borderOpacity),
        width: 1.1,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          elevatedSurface(colorScheme, gradientStartOpacity),
          elevatedSurface(colorScheme, gradientEndOpacity),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          blurRadius: 22,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  /// Creates a consistent dialog decoration
  static BoxDecoration createDialogDecoration(
    ColorScheme colorScheme, {
    double borderRadius = 24,
    double overlayOpacity = 0.22,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: elevatedSurface(colorScheme, overlayOpacity),
    );
  }

  /// Creates a standardized AlertDialog with consistent theming
  static AlertDialog createStyledDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    IconData? titleIcon,
    double borderRadius = 24,
    double overlayOpacity = 0.22,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: elevatedSurface(colorScheme, overlayOpacity),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      title: titleIcon != null
          ? Row(
              children: [
                Icon(titleIcon, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
      content: content,
      actions: actions,
    );
  }
}
