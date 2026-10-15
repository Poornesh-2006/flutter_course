// Day 3 · Demo 3 — Expanded and Flexible
// Run: flutter run -t lib/day3_demos/demo3_expanded_flexible.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ExpandedFlexibleDemo()));

class ExpandedFlexibleDemo extends StatelessWidget {
  const ExpandedFlexibleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expanded & Flexible')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. The classic overflow bug: long text in a Row.
            //    Uncomment to show the yellow-black stripes, then fix with Expanded.
            // const Row(children: [
            //   Icon(Icons.warning),
            //   Text('This is a very long sentence that will not fit inside one row on a phone screen'),
            // ]),
            const Text('1. Expanded fixes long text in a Row'),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This is a very long sentence that will not fit inside one row on a phone screen',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Expanded takes ALL leftover space. flex sets the ratio.
            const Text('2. Expanded with flex 1 : 2 : 1'),
            Row(
              children: [
                Expanded(flex: 1, child: _bar(Colors.red, 'flex 1')),
                Expanded(flex: 2, child: _bar(Colors.green, 'flex 2')),
                Expanded(flex: 1, child: _bar(Colors.blue, 'flex 1')),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Flexible MAY take up to its share, but can be smaller.
            const Text('3. Flexible (left) vs Expanded (right)'),
            Row(
              children: [
                Flexible(child: _bar(Colors.orange, 'small', width: 60)),
                Expanded(child: _bar(Colors.purple, 'Expanded fills the rest')),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Expanded inside a Column fills the leftover height.
            const Text('4. Expanded in a Column fills the remaining height'),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                color: Colors.teal.shade100,
                alignment: Alignment.center,
                child: const Text('I take all the leftover height'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _bar(Color color, String text, {double? width}) => Container(
        width: width,
        height: 50,
        color: color,
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      );
}
