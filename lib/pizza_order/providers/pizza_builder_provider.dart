import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pizza.dart';
import 'menu_providers.dart';

// The pizza being built on the first screen: size, toppings and quantity.
class PizzaBuilderNotifier extends Notifier<PizzaDraft> {
  @override
  PizzaDraft build() {
    final medium = ref.watch(sizesProvider)[1];
    return PizzaDraft(pizza: Pizza(size: medium));
  }

  void selectSize(PizzaSize size) {
    state = state.copyWith(pizza: state.pizza.copyWith(size: size));
  }

  void toggleTopping(Topping topping) {
    final current = state.pizza.toppings;
    final updated = current.contains(topping)
        ? current.where((t) => t != topping).toList()
        : [...current, topping];
    state = state.copyWith(pizza: state.pizza.copyWith(toppings: updated));
  }

  void increment() => state = state.copyWith(quantity: state.quantity + 1);

  void decrement() {
    if (state.quantity > 1) state = state.copyWith(quantity: state.quantity - 1);
  }

  // Start again with a fresh pizza by re-running build().
  void reset() => ref.invalidateSelf();
}

final pizzaBuilderProvider =
    NotifierProvider<PizzaBuilderNotifier, PizzaDraft>(PizzaBuilderNotifier.new);
