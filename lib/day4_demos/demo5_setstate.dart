// Day 4 · Demo 5 — setState() and how rebuilds work
// Run: flutter run -t lib/day4_demos/demo5_setstate.dart
//
// Watch the Debug Console while you tap the buttons.
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: SetStateDemo()));

class SetStateDemo extends StatefulWidget {
  const SetStateDemo({super.key});

  @override
  State<SetStateDemo> createState() => _SetStateDemoState();
}

class _SetStateDemoState extends State<SetStateDemo> {
  int _count = 0;

  void _incrementWrong() {
    // The value changes, but Flutter isn't told, so build() doesn't run
    // and the screen still shows the old number.
    _count++;
    debugPrint('WRONG: _count is now $_count, but the screen did not update');
  }

  void _incrementRight() {
    // setState changes the value AND asks Flutter to run build() again.
    setState(() => _count++);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build() ran, _count = $_count');

    return Scaffold(
      appBar: AppBar(title: const Text('setState')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$_count', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: _incrementWrong,
              child: const Text('+1 without setState'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _incrementRight,
              child: const Text('+1 with setState'),
            ),
            const SizedBox(height: 32),
            // A const widget is created once and reused. It is NOT rebuilt
            // when its parent calls setState. Check the console.
            const _StaticLabel(),
            // A non-const widget is rebuilt every time.
            _ChangingLabel(count: _count),
          ],
        ),
      ),
    );
  }
}

class _StaticLabel extends StatelessWidget {
  const _StaticLabel();

  @override
  Widget build(BuildContext context) {
    debugPrint('  _StaticLabel.build()');
    return const Text('I am const and never rebuild');
  }
}

class _ChangingLabel extends StatelessWidget {
  const _ChangingLabel({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    debugPrint('  _ChangingLabel.build()');
    return Text('I rebuild every time (count = $count)');
  }
}
