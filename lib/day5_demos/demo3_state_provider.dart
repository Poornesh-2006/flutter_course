// Day 5 · Demo 3 — StateProvider, and ref.watch vs ref.read
// Run: flutter run -t lib/day5_demos/demo3_state_provider.dart
//
// StateProvider holds ONE simple value that can change: a number, a bool,
// a selected tab. In Riverpod 3 it lives in the "legacy" import, because
// NotifierProvider (demo 4) is now preferred for anything bigger.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final counterProvider = StateProvider<int>((ref) => 0);
final darkModeProvider = StateProvider<bool>((ref) => false);

void main() => runApp(const ProviderScope(child: CounterApp()));

class CounterApp extends ConsumerWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching here means the whole app rebuilds when dark mode changes.
    final isDark = ref.watch(darkModeProvider);

    return MaterialApp(
      theme: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ ref.watch inside build: rebuild this widget whenever the value changes.
    final count = ref.watch(counterProvider);

    // ❌ ref.read inside build: reads the value ONCE and never updates.
    // final count = ref.read(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StateProvider'),
        actions: [
          Switch(
            value: ref.watch(darkModeProvider),
            // ✅ ref.read inside a callback: we only need to change the value,
            // not listen to it.
            onChanged: (value) => ref.read(darkModeProvider.notifier).state = value,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$count', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),
            const _DoubledText(), // reads the same provider, no constructor needed
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state--,
                  child: const Text('−1'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  child: const Text('+1'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => ref.read(counterProvider.notifier).state = 0,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DoubledText extends ConsumerWidget {
  const _DoubledText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('Doubled: ${count * 2}');
  }
}
