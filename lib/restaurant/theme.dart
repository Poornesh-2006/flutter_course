import 'package:flutter/material.dart';

// The ONLY place colors, fonts and shapes are defined.
// Widgets read them with Theme.of(context); no hardcoded colors in widgets.
ThemeData buildRestaurantTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFD35400), // warm "spice" orange
  );

  return ThemeData(
    colorScheme: colorScheme,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      clipBehavior: Clip.antiAlias, // so the image respects rounded corners
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
