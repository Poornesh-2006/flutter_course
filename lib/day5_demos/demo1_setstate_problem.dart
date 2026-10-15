// Day 5 · Demo 1 — Why setState breaks down
// Run: flutter run -t lib/day5_demos/demo1_setstate_problem.dart
//
// The cart lives in ShopScreen's State. Every widget that needs it must
// receive it through constructors ("prop drilling"), and the cart screen
// can't update the shop screen directly.
//
// Watch the grey "built N×" tags: each one flashes yellow and counts up
// whenever that widget rebuilds.
// Try it: tap Add on ONE product. EVERY tag on the screen goes up, because
// setState rebuilds the whole ShopScreen and everything inside it.
// Then open the cart, remove an item, and go back.
import 'package:flutter/material.dart';

import 'build_counter.dart';

void main() => runApp(const MaterialApp(home: ShopScreen()));

const products = ['Notebook', 'Pen', 'Backpack', 'Water bottle', 'Calculator'];

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<String> _cart = [];

  void _add(String item) => setState(() => _cart.add(item));
  void _remove(String item) => setState(() => _cart.remove(item));

  @override
  Widget build(BuildContext context) {
    final builds = BuildCounter.count('ShopScreen');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(child: Text('Shop (setState)', overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            BuildTag(builds),
          ],
        ),
        actions: [
          // 1. The badge needs the cart → pass it down.
          _CartButton(
            count: _cart.length,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  // 2. The cart screen needs the cart AND a remove callback → pass both.
                  builder: (context) =>
                      CartScreen(cart: _cart, onRemove: _remove),
                ),
              );
              // 3. The cart screen changed our list, so force a rebuild on return.
              setState(() {});
            },
          ),
        ],
      ),
      // 4. The list needs the add callback → pass it down two levels.
      body: _ProductList(onAdd: _add),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.onAdd});

  final ValueChanged<String>
  onAdd; // this widget doesn't use it, only passes it on

  @override
  Widget build(BuildContext context) {
    final builds = BuildCounter.count('ProductList');

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              const Text('Product list'),
              const SizedBox(width: 8),
              BuildTag(builds),
            ],
          ),
        ),
        for (final p in products) _ProductTile(name: p, onAdd: onAdd),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.name, required this.onAdd});

  final String name;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    final builds = BuildCounter.count('tile:$name');

    return ListTile(
      title: Text(name),
      subtitle: Align(alignment: Alignment.centerLeft, child: BuildTag(builds)),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () => onAdd(name),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final builds = BuildCounter.count('CartButton');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BuildTag(builds),
        IconButton(
          onPressed: onPressed,
          icon: Badge(
            label: Text('$count'),
            child: const Icon(Icons.shopping_cart),
          ),
        ),
      ],
    );
  }
}

// The cart screen is StatefulWidget ONLY so it can redraw itself after a removal.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.cart, required this.onRemove});

  final List<String> cart;
  final ValueChanged<String> onRemove;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final builds = BuildCounter.count('CartScreen');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(child: Text('Cart (${widget.cart.length})', overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            BuildTag(builds),
          ],
        ),
      ),
      body: ListView(
        children: [
          for (final item in widget.cart)
            ListTile(
              title: Text(item),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  widget.onRemove(item); // updates ShopScreen's list…
                  setState(() {}); // …and we must ALSO redraw this screen
                },
              ),
            ),
        ],
      ),
    );
  }
}
