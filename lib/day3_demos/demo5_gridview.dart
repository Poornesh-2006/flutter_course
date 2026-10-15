// Day 3 · Demo 5 — GridView
// Run: flutter run -t lib/day3_demos/demo5_gridview.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: GridViewDemo()));

class GridViewDemo extends StatelessWidget {
  const GridViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Colors.primaries;

    return Scaffold(
      appBar: AppBar(title: const Text('GridView')),
      body: Column(
        children: [
          // 1. GridView.count: fixed number of columns, good for a few items.
          SizedBox(
            height: 200,
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: const [
                _Tile(Icons.local_pizza, 'Pizza'),
                _Tile(Icons.lunch_dining, 'Burger'),
                _Tile(Icons.ramen_dining, 'Noodles'),
                _Tile(Icons.icecream, 'Dessert'),
                _Tile(Icons.local_cafe, 'Coffee'),
                _Tile(Icons.set_meal, 'Seafood'),
              ],
            ),
          ),
          const Divider(thickness: 4),

          // 2. GridView.builder: lazy, like ListView.builder.
          //    childAspectRatio = width / height of each tile.
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: 50,
              itemBuilder: (context, index) => Container(
                color: colors[index % colors.length],
                alignment: Alignment.center,
                child: Text('Item $index', style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),

          // 3. Horizontal grid: set scrollDirection. This is the shape
          //    used for the category strip in the Restaurant Menu App.
          SizedBox(
            height: 100,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) => CircleAvatar(
                backgroundColor: colors[index % colors.length],
                child: Text('$index'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 32), Text(label)],
      ),
    );
  }
}
