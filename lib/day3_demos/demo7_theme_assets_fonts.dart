// Day 3 · Demo 7 — ThemeData, assets and custom fonts
// Run: flutter run -t lib/day3_demos/demo7_theme_assets_fonts.dart
//
// The images and the Poppins font are registered in pubspec.yaml under
// `flutter: assets:` and `flutter: fonts:`. After editing pubspec.yaml,
// run `flutter pub get` and do a full restart; hot reload won't pick up new assets.
import 'package:flutter/material.dart';

void main() => runApp(const ThemeDemoApp());

class ThemeDemoApp extends StatelessWidget {
  const ThemeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define colors and text styles ONCE here…
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        fontFamily: 'Poppins', // the family name from pubspec.yaml
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const ThemeDemo(),
    );
  }
}

class ThemeDemo extends StatelessWidget {
  const ThemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // …then read them anywhere with Theme.of(context).
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme, Assets & Fonts'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('headlineSmall', style: text.headlineSmall),
          Text('titleMedium', style: text.titleMedium),
          Text('bodyMedium in Poppins', style: text.bodyMedium),
          Text('bodySmall', style: text.bodySmall),
          const SizedBox(height: 16),

          // ❌ Hardcoded: changing the brand color means hunting through every file.
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF009688),
            child: const Text('Hardcoded color', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 8),
          // ✅ From the theme: change seedColor above and this updates too.
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primaryContainer,
            child: Text('Theme color', style: TextStyle(color: colors.onPrimaryContainer)),
          ),
          const SizedBox(height: 16),

          // Local image asset, path must match pubspec.yaml.
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/dish2.jpg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: const Text('Themed button')),
        ],
      ),
    );
  }
}
