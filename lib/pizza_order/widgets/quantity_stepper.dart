import 'package:flutter/material.dart';

// − 2 +   Used on both screens. It holds no state: the parent passes the
// value in and gets told when a button is pressed.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove),
            tooltip: 'Decrease',
            onPressed: onDecrement,
          ),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add),
            tooltip: 'Increase',
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
