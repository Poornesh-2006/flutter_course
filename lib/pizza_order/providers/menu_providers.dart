import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pizza.dart';

// Read-only values → plain Provider.

final sizesProvider = Provider<List<PizzaSize>>((ref) => const [
      PizzaSize('Small', 8, 199),
      PizzaSize('Medium', 10, 299),
      PizzaSize('Large', 12, 399),
    ]);

final toppingsProvider = Provider<List<Topping>>((ref) => const [
      Topping('Extra cheese', 50),
      Topping('Mushroom', 40),
      Topping('Onion', 30),
      Topping('Capsicum', 30),
      Topping('Sweet corn', 30),
      Topping('Paneer', 60),
      Topping('Chicken', 80),
      Topping('Jalapeño', 35),
    ]);
