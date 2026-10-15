// Day 4 · Demo 6 — StatefulWidget lifecycle: initState and dispose
// Run: flutter run -t lib/day4_demos/demo6_lifecycle.dart
//
// Order of calls:
//   createState → initState (once) → build (many times) → dispose (once)
//
// initState: set things up (start timers, create controllers, load data).
// dispose:   clean them up, or they keep running after the widget is gone.
import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: LifecycleDemo()));

class LifecycleDemo extends StatefulWidget {
  const LifecycleDemo({super.key});

  @override
  State<LifecycleDemo> createState() => _LifecycleDemoState();
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  bool _showCounter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lifecycle')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Removing the SecondsCounter from the tree calls its dispose().
            // Adding it back creates a NEW State and calls initState() again.
            if (_showCounter) const SecondsCounter(),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => setState(() => _showCounter = !_showCounter),
              child: Text(_showCounter ? 'Remove counter' : 'Add counter'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondsCounter extends StatefulWidget {
  const SecondsCounter({super.key});

  @override
  State<SecondsCounter> createState() => _SecondsCounterState();
}

class _SecondsCounterState extends State<SecondsCounter> {
  late final Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState(); // always call super first in initState
    debugPrint('initState: starting the timer');
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      debugPrint('tick $_seconds');
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    debugPrint('dispose: stopping the timer');
    // Try commenting out this line, then remove the counter.
    // The timer keeps ticking and you get
    // "setState() called after dispose()" in the console.
    _timer.cancel();
    super.dispose(); // always call super last in dispose
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds s',
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}
