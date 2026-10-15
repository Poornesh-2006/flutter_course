class PizzaSize {
  const PizzaSize(this.name, this.inches, this.price);

  final String name;
  final int inches;
  final int price;
}

class Topping {
  const Topping(this.name, this.price);

  final String name;
  final int price;
}

// All model classes are immutable: to change something, make a copy.
class Pizza {
  const Pizza({required this.size, this.toppings = const []});

  final PizzaSize size;
  final List<Topping> toppings;

  int get unitPrice => size.price + toppings.fold(0, (sum, t) => sum + t.price);

  String get toppingsLabel =>
      toppings.isEmpty ? 'No extra toppings' : toppings.map((t) => t.name).join(', ');

  Pizza copyWith({PizzaSize? size, List<Topping>? toppings}) =>
      Pizza(size: size ?? this.size, toppings: toppings ?? this.toppings);
}

// What the user is building right now on the first screen.
class PizzaDraft {
  const PizzaDraft({required this.pizza, this.quantity = 1});

  final Pizza pizza;
  final int quantity;

  int get total => pizza.unitPrice * quantity;

  PizzaDraft copyWith({Pizza? pizza, int? quantity}) =>
      PizzaDraft(pizza: pizza ?? this.pizza, quantity: quantity ?? this.quantity);
}

// One line in the order.
class OrderItem {
  const OrderItem({required this.id, required this.pizza, required this.quantity});

  final int id;
  final Pizza pizza;
  final int quantity;

  int get total => pizza.unitPrice * quantity;

  OrderItem copyWith({int? quantity}) =>
      OrderItem(id: id, pizza: pizza, quantity: quantity ?? this.quantity);
}
