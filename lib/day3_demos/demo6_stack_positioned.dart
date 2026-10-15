// Day 3 · Demo 6 — Stack and Positioned
// Run: flutter run -t lib/day3_demos/demo6_stack_positioned.dart
//
// Column/Row put children next to each other.
// Stack puts children ON TOP of each other: the first child is at the back.
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: StackDemo()));

class StackDemo extends StatelessWidget {
  const StackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack & Positioned')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Basic layering with alignment.
          const Text('1. Three layers, aligned to the centre'),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 200, height: 200, color: Colors.red),
              Container(width: 140, height: 140, color: Colors.green),
              Container(width: 80, height: 80, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 24),

          // 2. Positioned pins a child to the edges of the Stack.
          const Text('2. Positioned: a badge on an image'),
          const SizedBox(height: 8),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/dish1.jpg', height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Bestseller', style: TextStyle(color: Colors.white)),
                ),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: Icon(Icons.favorite, color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Notification dot on an icon — a very common real-world use.
          const Text('3. Notification dot'),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              clipBehavior: Clip.none, // lets the dot hang outside the icon
              children: [
                Icon(Icons.shopping_cart, size: 40),
                Positioned(
                  top: -4,
                  right: -6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text('3', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
