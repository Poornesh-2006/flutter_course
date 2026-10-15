// Day 6 project — Joke App
// Run: flutter run -t lib/joke_app/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/joke_screen.dart';

void main() {
  runApp(
    ProviderScope(
      // Show errors straight away instead of retrying quietly for ~30 seconds.
      retry: (retryCount, error) => null,
      child: const JokeApp(),
    ),
  );
}

class JokeApp extends StatelessWidget {
  const JokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A4BC4)),
        fontFamily: 'Poppins',
      ),
      home: const JokeScreen(),
    );
  }
}
