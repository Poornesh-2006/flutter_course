// Day 3 · Demo 2 — MainAxisAlignment and CrossAxisAlignment
// Run: flutter run -t lib/day3_demos/demo2_main_cross_axis.dart
//
// Rule to remember:
//   Row    → main axis is HORIZONTAL, cross axis is vertical
//   Column → main axis is VERTICAL,   cross axis is horizontal
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AxisDemo()));

class AxisDemo extends StatelessWidget {
  const AxisDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main & Cross Axis')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final main in MainAxisAlignment.values)
            _RowExample(
              label: 'Row · mainAxisAlignment.${main.name}',
              mainAxisAlignment: main,
            ),
          const Divider(height: 32),
          for (final cross in [
            CrossAxisAlignment.start,
            CrossAxisAlignment.center,
            CrossAxisAlignment.end,
          ])
            _RowExample(
              label: 'Row · crossAxisAlignment.${cross.name}',
              crossAxisAlignment: cross,
            ),
        ],
      ),
    );
  }
}

class _RowExample extends StatelessWidget {
  const _RowExample({
    required this.label,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final String label;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            height: 70,
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              // Different heights so cross-axis alignment is visible.
              children: [
                _box(Colors.red, 30),
                _box(Colors.green, 50),
                _box(Colors.blue, 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _box(Color color, double height) =>
      Container(width: 40, height: height, color: color);
}
