// Day 5 · Demo 2 — Riverpod setup: ProviderScope, ConsumerWidget, Provider
// Run: flutter run -t lib/day5_demos/demo2_provider_basics.dart
//
// Three steps to use Riverpod:
//   1. Add flutter_riverpod to pubspec.yaml.
//   2. Wrap the app in ProviderScope. It stores the value of every provider.
//   3. Read providers in a ConsumerWidget with ref.watch.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A Provider exposes a value that never changes (read-only).
// It's declared at the top level, so any widget anywhere can read it:
// no constructors, no passing down.
final appNameProvider = Provider<String>((ref) => 'Campus Store');

final taxRateProvider = Provider<double>((ref) => 0.18); // 18% GST

// A provider can be built from other providers using ref.watch.
final priceWithTaxProvider = Provider<String>((ref) {
  final tax = ref.watch(taxRateProvider);
  const price = 500;
  return '₹$price + ${(tax * 100).toInt()}% GST = ₹${(price * (1 + tax)).toStringAsFixed(0)}';
});

void main() {
  runApp(
    // Without ProviderScope, any ref.watch call throws an error.
    const ProviderScope(child: MaterialApp(home: HomeScreen())),
  );
}

// ConsumerWidget = StatelessWidget + a `ref` to read providers.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appName = ref.watch(appNameProvider);

    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_Footer(), SizedBox(height: 16), _PriceLine()],
        ),
      ),
    );
  }
}

// This widget is deep in the tree, but it reads the provider directly.
// HomeScreen didn't have to pass anything to it.
class _Footer extends ConsumerWidget {
  const _Footer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('Welcome to ${ref.watch(appNameProvider)}!');
  }
}

class _PriceLine extends ConsumerWidget {
  const _PriceLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(ref.watch(priceWithTaxProvider));
  }
}
