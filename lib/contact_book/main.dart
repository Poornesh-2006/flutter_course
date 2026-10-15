// Day 4 project — Contact Book App
// Run: flutter run -t lib/contact_book/main.dart
import 'package:flutter/material.dart';

import 'screens/contact_list_screen.dart';

void main() {
  runApp(const ContactBookApp());
}

class ContactBookApp extends StatelessWidget {
  const ContactBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: 'Poppins',
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: const ContactListScreen(),
    );
  }
}
