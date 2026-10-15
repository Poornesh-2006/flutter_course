// Day 4 · Demo 2 — Passing data to a new screen
// Run: flutter run -t lib/day4_demos/demo2_pass_data.dart
//
// A screen is just a widget, so you pass data the same way you pass data
// to any widget: through its constructor.
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ProductListScreen()));

class Product {
  const Product(this.name, this.price, this.description);

  final String name;
  final int price;
  final String description;
}

const products = [
  Product('Wireless Earbuds', 1999, 'Bluetooth 5.3, 24-hour battery with the case.'),
  Product('Smart Watch', 3499, 'Heart-rate tracking and a 1.4-inch AMOLED screen.'),
  Product('Power Bank', 1299, '20,000 mAh with 22.5 W fast charging.'),
  Product('Phone Stand', 399, 'Adjustable aluminium stand for desks.'),
];

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('₹${product.price}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Hand the tapped product to the next screen.
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product; // received from the list screen

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: text.headlineSmall),
            const SizedBox(height: 8),
            Text('₹${product.price}', style: text.titleLarge),
            const SizedBox(height: 16),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
