import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/menu_providers.dart';
import '../providers/order_provider.dart';
import '../providers/pizza_builder_provider.dart';
import '../routes.dart';
import '../widgets/order_button.dart';
import '../widgets/quantity_stepper.dart';

class PizzaBuilderScreen extends ConsumerWidget {
  const PizzaBuilderScreen({super.key});

  void _addToOrder(BuildContext context, WidgetRef ref) {
    // ref.read in a callback: we act on the providers, we don't listen to them.
    final draft = ref.read(pizzaBuilderProvider);
    ref.read(orderProvider.notifier).add(draft);
    ref.read(pizzaBuilderProvider.notifier).reset();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Added ${draft.quantity} × ${draft.pizza.size.name} pizza'),
          action: SnackBarAction(
            label: 'View order',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.summary),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizes = ref.watch(sizesProvider);
    final toppings = ref.watch(toppingsProvider);
    final draft = ref.watch(pizzaBuilderProvider);
    final builder = ref.read(pizzaBuilderProvider.notifier);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Build your pizza'),
        actions: const [OrderButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Size', style: text.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final size in sizes)
                ChoiceChip(
                  label: Text('${size.name} ${size.inches}" · ₹${size.price}'),
                  selected: draft.pizza.size == size,
                  onSelected: (_) => builder.selectSize(size),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Toppings', style: text.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final topping in toppings)
                FilterChip(
                  label: Text('${topping.name} +₹${topping.price}'),
                  selected: draft.pizza.toppings.contains(topping),
                  onSelected: (_) => builder.toggleTopping(topping),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Text('Quantity', style: text.titleMedium)),
              QuantityStepper(
                value: draft.quantity,
                onIncrement: builder.increment,
                onDecrement: builder.decrement,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_pizza),
              title: Text('${draft.pizza.size.name} pizza · ₹${draft.pizza.unitPrice} each'),
              subtitle: Text(draft.pizza.toppingsLabel),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () => _addToOrder(context, ref),
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('Add ${draft.quantity} to order · ₹${draft.total}'),
          ),
        ),
      ),
    );
  }
}
