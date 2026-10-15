import 'package:flutter/material.dart';

import '../data/menu_data.dart';
import '../widgets/category_strip.dart';
import '../widgets/dish_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = allCategory;

  @override
  Widget build(BuildContext context) {
    final visibleDishes = _selectedCategory == allCategory
        ? dishes
        : dishes.where((d) => d.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Spice Route')),
      body: Column(
        children: [
          CategoryStrip(
            selected: _selectedCategory,
            // setState is covered properly on Day 4; here it just re-filters the list.
            onSelected: (name) => setState(() => _selectedCategory = name),
          ),
          // A ListView inside a Column must be wrapped in Expanded
          // so it knows how much height it is allowed to use.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: visibleDishes.length,
              itemBuilder: (context, index) => DishCard(dish: visibleDishes[index]),
            ),
          ),
        ],
      ),
    );
  }
}
