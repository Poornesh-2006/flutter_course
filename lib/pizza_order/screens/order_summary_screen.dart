import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pizza.dart';
import '../providers/order_provider.dart';
import '../widgets/quantity_stepper.dart';

class OrderSummaryScreen extends ConsumerWidget {
  const OrderSummaryScreen({super.key});

  void _placeOrder(BuildContext context, WidgetRef ref) {
    final total = ref.read(totalProvider);
    ref.read(orderProvider.notifier).clear();
    // Hide any "Added…" SnackBar still showing, otherwise this one waits behind it.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Order placed · ₹$total')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(orderProvider);
    final itemCount = ref.watch(itemCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Your order · $itemCount ${itemCount == 1 ? 'item' : 'items'}')),
      body: items.isEmpty
          ? const _EmptyOrder()
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final item in items) _OrderItemTile(item: item),
                const Divider(height: 32),
                SwitchListTile(
                  title: const Text('Home delivery'),
                  subtitle: const Text('+₹$deliveryFee'),
                  value: ref.watch(homeDeliveryProvider),
                  onChanged: (value) => ref.read(homeDeliveryProvider.notifier).state = value,
                ),
                const _Bill(),
              ],
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => _placeOrder(context, ref),
                  child: Text('Place order · ₹${ref.watch(totalProvider)}'),
                ),
              ),
            ),
    );
  }
}

class _OrderItemTile extends ConsumerWidget {
  const _OrderItemTile({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.read(orderProvider.notifier);
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.pizza.size.name} pizza', style: text.titleMedium),
                Text(item.pizza.toppingsLabel, style: text.bodySmall),
                const SizedBox(height: 4),
                Text('₹${item.total}', style: text.titleSmall),
              ],
            ),
          ),
          QuantityStepper(
            value: item.quantity,
            onIncrement: () => order.increment(item.id),
            onDecrement: () => order.decrement(item.id),
          ),
          IconButton(
            tooltip: 'Remove',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => order.remove(item.id),
          ),
        ],
      ),
    );
  }
}

class _Bill extends ConsumerWidget {
  const _Bill();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;

    Widget row(String label, int amount, {TextStyle? style}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(child: Text(label, style: style)),
              Text('₹$amount', style: style),
            ],
          ),
        );

    return Column(
      children: [
        row('Subtotal', ref.watch(subtotalProvider)),
        row('Delivery', ref.watch(deliveryChargeProvider)),
        row('Total', ref.watch(totalProvider), style: text.titleLarge),
      ],
    );
  }
}

class _EmptyOrder extends StatelessWidget {
  const _EmptyOrder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_pizza_outlined, size: 64, color: colors.outline),
          const SizedBox(height: 12),
          const Text('Your order is empty'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Build a pizza'),
          ),
        ],
      ),
    );
  }
}
