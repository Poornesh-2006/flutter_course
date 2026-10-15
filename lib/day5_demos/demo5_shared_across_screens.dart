// Day 5 · Demo 5 — The demo 1 shop, rebuilt with Riverpod
// Run: flutter run -t lib/day5_demos/demo5_shared_across_screens.dart
//
// Compare with demo 1. The cart is in a provider, so:
//   - no cart or callbacks are passed through constructors,
//   - the cart screen and the shop badge update by themselves,
//   - only the widgets that WATCH the cart rebuild.
//
// Watch the grey "built N×" tags: tap Add and ONLY the cart button's tag
// goes up. The screen title and every product tile stay at 1.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'build_counter.dart';

const products = ['Notebook', 'Pen', 'Backpack', 'Water bottle', 'Calculator'];

// Business logic lives here, not in the widgets.
class CartNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  void add(String item) => state = [...state, item];

  void remove(String item) {
    final copy = [...state]..remove(item);
    state = copy;
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<String>>(CartNotifier.new);

void main() => runApp(const ProviderScope(child: MaterialApp(home: ShopScreen())));

// A plain StatelessWidget: it holds no state any more.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final builds = BuildCounter.count('ShopScreen');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(child: Text('Shop (Riverpod)', overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            BuildTag(builds),
          ],
        ),
        actions: const [_CartButton()],
      ),
      body: ListView(
        children: [for (final p in products) _ProductTile(name: p)],
      ),
    );
  }
}

class _ProductTile extends ConsumerWidget {
  const _ProductTile({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builds = BuildCounter.count('tile:$name');

    return ListTile(
      title: Text(name),
      subtitle: Align(alignment: Alignment.centerLeft, child: BuildTag(builds)),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        // read = do something once. This tile does NOT watch the cart,
        // so it never rebuilds when the cart changes.
        onPressed: () => ref.read(cartProvider.notifier).add(name),
      ),
    );
  }
}

class _CartButton extends ConsumerWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch = rebuild me when the cart changes. Only this widget does that.
    final count = ref.watch(cartProvider).length;
    final builds = BuildCounter.count('CartButton');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BuildTag(builds),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          ),
          icon: Badge(label: Text('$count'), child: const Icon(Icons.shopping_cart)),
        ),
      ],
    );
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final builds = BuildCounter.count('CartScreen');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(child: Text('Cart (${cart.length})', overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            BuildTag(builds),
          ],
        ),
      ),
      body: ListView(
        children: [
          for (final item in cart)
            ListTile(
              title: Text(item),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => ref.read(cartProvider.notifier).remove(item),
              ),
            ),
        ],
      ),
    );
  }
}
