import 'package:flutter/material.dart';

import '../data/menu_data.dart';

// A one-row horizontal GridView of category tiles.
class CategoryStrip extends StatelessWidget {
  const CategoryStrip({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SizedBox(
      height: 110,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // one row, because the grid scrolls horizontally
          mainAxisSpacing: 12,
          childAspectRatio: 1.1, // height / width of each tile in a horizontal grid
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.name == selected;

          return GestureDetector(
            onTap: () => onSelected(category.name),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category.icon,
                    color: isSelected ? colors.onPrimary : colors.onPrimaryContainer,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: text.labelMedium?.copyWith(
                      color: isSelected ? colors.onPrimary : colors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
