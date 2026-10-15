// Day 4 · Demo 3 — Returning a result from a screen
// Run: flutter run -t lib/day4_demos/demo3_return_result.dart
//
//   final result = await Navigator.push(...);   // waits until the screen pops
//   Navigator.pop(context, value);              // sends value back
//
// If the user presses the back arrow instead, result is null.
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: OrderScreen()));

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? _size; // null until the user picks one

  Future<void> _chooseSize() async {
    // push returns a Future that completes when SizeScreen pops.
    final chosen = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const SizeScreen()),
    );

    // The screen may have closed while we waited, so check before using context.
    if (!mounted) return;

    if (chosen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No size chosen')),
      );
      return;
    }

    setState(() => _size = chosen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order a T-shirt')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _size == null ? 'No size selected' : 'Selected size: $_size',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _chooseSize, child: const Text('Choose size')),
          ],
        ),
      ),
    );
  }
}

class SizeScreen extends StatelessWidget {
  const SizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const sizes = ['S', 'M', 'L', 'XL'];

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a size')),
      body: ListView(
        children: [
          for (final size in sizes)
            ListTile(
              title: Text(size),
              // Close this screen AND send the size back.
              onTap: () => Navigator.pop(context, size),
            ),
        ],
      ),
    );
  }
}
