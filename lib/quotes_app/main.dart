// Day 7 project — Quotes App
// Run: flutter run -t lib/quotes_app/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/quote_providers.dart';
import 'routes.dart';
import 'screens/favourites_screen.dart';
import 'screens/quotes_screen.dart';

Future<void> main() async {
  // Open local storage before the app starts, so saved favourites
  // are ready on the very first frame.
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      retry: (retryCount, error) => null,
      child: const QuotesApp(),
    ),
  );
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6F78)),
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.quotes,
      routes: {
        AppRoutes.quotes: (context) => const QuotesScreen(),
        AppRoutes.favourites: (context) => const FavouritesScreen(),
      },
    );
  }
}
