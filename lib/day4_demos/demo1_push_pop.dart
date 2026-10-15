// Day 4 · Demo 1 — Navigator push and pop
// Run: flutter run -t lib/day4_demos/demo1_push_pop.dart
//
// The Navigator keeps screens in a STACK, like a pile of plates:
//   push → put a new screen on top
//   pop  → take the top screen off, revealing the one below
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: FirstScreen()));

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First screen')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondScreen()),
            );
          },
          child: const Text('Go to second screen'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar adds a back arrow automatically. It calls pop for you.
      appBar: AppBar(title: const Text('Second screen')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdScreen()),
                );
              },
              child: const Text('Go to third screen'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back (pop)'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third screen')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back one screen'),
            ),
            const SizedBox(height: 12),
            // Pops screens until only the first one is left.
            OutlinedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Back to the first screen'),
            ),
          ],
        ),
      ),
    );
  }
}
