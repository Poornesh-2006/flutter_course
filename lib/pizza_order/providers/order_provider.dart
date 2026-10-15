import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/pizza.dart';

const deliveryFee = 40;

// The order: a list of pizzas with quantities. All the rules live here,
// so the screens only call methods and display the result.
class OrderNotifier extends Notifier<List<OrderItem>> {
  int _nextId = 1;

  @override
  List<OrderItem> build() => const [];

  void add(PizzaDraft draft) {
    state = [...state, OrderItem(id: _nextId++, pizza: draft.pizza, quantity: draft.quantity)];
  }

  void increment(int id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(quantity: item.quantity + 1) else item,
    ];
  }

  // Going below 1 removes the item.
  void decrement(int id) {
    state = [
      for (final item in state)
        if (item.id != id)
          item
        else if (item.quantity > 1)
          item.copyWith(quantity: item.quantity - 1),
    ];
  }

  void remove(int id) => state = state.where((item) => item.id != id).toList();

  void clear() => state = const [];
}

final orderProvider = NotifierProvider<OrderNotifier, List<OrderItem>>(OrderNotifier.new);

// One simple on/off value → StateProvider.
final homeDeliveryProvider = StateProvider<bool>((ref) => false);

// Derived values. They update automatically when the order changes.
final itemCountProvider = Provider<int>((ref) {
  return ref.watch(orderProvider).fold(0, (sum, item) => sum + item.quantity);
});

final subtotalProvider = Provider<int>((ref) {
  return ref.watch(orderProvider).fold(0, (sum, item) => sum + item.total);
});

final deliveryChargeProvider = Provider<int>((ref) {
  final hasItems = ref.watch(orderProvider).isNotEmpty;
  return hasItems && ref.watch(homeDeliveryProvider) ? deliveryFee : 0;
});

final totalProvider = Provider<int>((ref) {
  return ref.watch(subtotalProvider) + ref.watch(deliveryChargeProvider);
});
