// Day 3 project — Restaurant Menu App
// Run: flutter run
import 'package:flutter/material.dart';

import 'restaurant/screens/menu_screen.dart';
import 'restaurant/theme.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spice Route',
      debugShowCheckedModeBanner: false,
      theme: buildRestaurantTheme(),
      home: const MenuScreen(),
    );
  }
}
