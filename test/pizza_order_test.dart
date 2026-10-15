import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tutorial_project/pizza_order/main.dart';
import 'package:tutorial_project/pizza_order/providers/menu_providers.dart';
import 'package:tutorial_project/pizza_order/providers/order_provider.dart';
import 'package:tutorial_project/pizza_order/providers/pizza_builder_provider.dart';

void main() {
  // Business logic tested with no widgets at all.
  group('providers', () {
    late ProviderContainer container;
    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('builder computes price from size, toppings and quantity', () {
      final builder = container.read(pizzaBuilderProvider.notifier);
      final toppings = container.read(toppingsProvider);

      expect(container.read(pizzaBuilderProvider).total, 299); // Medium, no toppings
      builder.toggleTopping(toppings[0]); // Extra cheese +50
      builder.increment();
      expect(container.read(pizzaBuilderProvider).total, (299 + 50) * 2);

      builder.toggleTopping(toppings[0]); // off again
      builder.decrement();
      builder.decrement(); // can't go below 1
      expect(container.read(pizzaBuilderProvider).quantity, 1);
      expect(container.read(pizzaBuilderProvider).total, 299);
    });

    test('order totals, delivery and removing at zero', () {
      final order = container.read(orderProvider.notifier);
      final draft = container.read(pizzaBuilderProvider).copyWith(quantity: 2);

      expect(container.read(deliveryChargeProvider), 0);
      order.add(draft);
      expect(container.read(itemCountProvider), 2);
      expect(container.read(subtotalProvider), 598);

      container.read(homeDeliveryProvider.notifier).state = true;
      expect(container.read(totalProvider), 598 + deliveryFee);

      final id = container.read(orderProvider).single.id;
      order.decrement(id);
      order.decrement(id);
      expect(container.read(orderProvider), isEmpty);
      expect(container.read(totalProvider), 0); // no delivery fee on an empty order
    });
  });

  testWidgets('build a pizza, see it on the summary, place the order', (tester) async {
    // A tall screen: the test font draws every letter as a wide block, so the
    // chips wrap onto many rows and the form would not fit on a normal phone.
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: PizzaApp()));

    await tester.tap(find.textContaining('Large'));
    await tester.tap(find.textContaining('Paneer'));
    await tester.tap(find.byTooltip('Increase'));
    await tester.pump();
    expect(find.text('Add 2 to order · ₹918'), findsOneWidget); // (399 + 60) × 2

    await tester.tap(find.text('Add 2 to order · ₹918'));
    await tester.pump();
    // Builder reset to 1 Medium; the badge shows 2 items.
    expect(find.text('Add 1 to order · ₹299'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byTooltip('View order'));
    await tester.pumpAndSettle();
    expect(find.text('Your order · 2 items'), findsOneWidget);
    expect(find.text('Place order · ₹918'), findsOneWidget);

    await tester.tap(find.text('Home delivery'));
    await tester.pump();
    expect(find.text('Place order · ₹958'), findsOneWidget);

    await tester.tap(find.text('Place order · ₹958'));
    await tester.pumpAndSettle();
    expect(find.text('Build your pizza'), findsOneWidget);
    expect(find.text('Order placed · ₹958'), findsOneWidget);
  });
}
