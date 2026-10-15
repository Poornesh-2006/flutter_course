// Day 3 · Demo 1 — Padding, margin, Alignment, Center
// Run: flutter run -t lib/day3_demos/demo1_padding_alignment.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PaddingAlignmentDemo()));

class PaddingAlignmentDemo extends StatelessWidget {
  const PaddingAlignmentDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Padding & Alignment')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Padding = space INSIDE a box, around its child.
          Container(
            color: Colors.orange.shade100,
            padding: const EdgeInsets.all(24),
            child: Container(color: Colors.orange, child: const Text('padding: all(24)')),
          ),

          // 2. Margin = space OUTSIDE a box, between it and its neighbours.
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            padding: const EdgeInsets.all(8),
            color: Colors.blue.shade200,
            child: const Text('margin: symmetric(h: 40, v: 16)'),
          ),

          // 3. The Padding widget does the same job without a Container.
          const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text('Padding widget: only(left: 60)'),
          ),

          // 4. Alignment positions a child inside a bigger box.
          //    (-1,-1) is top-left, (0,0) is centre, (1,1) is bottom-right.
          Container(
            height: 120,
            margin: const EdgeInsets.all(16),
            color: Colors.green.shade100,
            alignment: Alignment.bottomRight, // try topLeft, centerRight, Alignment(0.5, -0.5)
            child: const Icon(Icons.star, size: 40),
          ),

          // 5. Center is just Align(alignment: Alignment.center).
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.purple.shade100,
            child: const Center(child: Text('Center')),
          ),
        ],
      ),
    );
  }
}
