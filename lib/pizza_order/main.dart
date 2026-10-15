// Day 5 project — Pizza Order App
// Run: flutter run -t lib/pizza_order/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes.dart';
import 'screens/order_summary_screen.dart';
import 'screens/pizza_builder_screen.dart';

void main() {
  // ProviderScope stores the state of every provider in the app.
  runApp(const ProviderScope(child: PizzaApp()));
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC62828)),
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.builder,
      routes: {
        AppRoutes.builder: (context) => const PizzaBuilderScreen(),
        AppRoutes.summary: (context) => const OrderSummaryScreen(),
      },
    );
  }
}
