import 'package:flutter/material.dart';

import '../models/dish.dart';

class DishCard extends StatelessWidget {
  const DishCard({super.key, required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Card takes its shape, margin and elevation from cardTheme.
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack: the image at the back, badges on top.
          Stack(
            children: [
              Image.asset(
                dish.imagePath,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              if (dish.isBestseller)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: colors.onTertiary),
                        const SizedBox(width: 4),
                        Text(
                          'Bestseller',
                          style: text.labelSmall?.copyWith(color: colors.onTertiary),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _VegMark(isVeg: dish.isVeg),
                    const SizedBox(width: 8),
                    // Expanded stops a long dish name from overflowing the Row.
                    Expanded(
                      child: Text(
                        dish.name,
                        style: text.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${dish.price.toStringAsFixed(0)}',
                      style: text.titleMedium?.copyWith(color: colors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dish.description,
                  style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// The green/red square-in-a-dot food mark used on Indian menus.
// Green and red mean veg and non-veg by convention, so they stay fixed and
// don't come from the theme.
class _VegMark extends StatelessWidget {
  const _VegMark({required this.isVeg});

  final bool isVeg;

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? Colors.green.shade700 : Colors.red.shade700;
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(border: Border.all(color: color, width: 1.5)),
      alignment: Alignment.center,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
