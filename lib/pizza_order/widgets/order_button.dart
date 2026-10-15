import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/order_provider.dart';
import '../routes.dart';

// Cart icon with a live item count. Only this small widget rebuilds when the
// order changes, not the whole builder screen.
class OrderButton extends ConsumerWidget {
  const OrderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(itemCountProvider);

    return IconButton(
      tooltip: 'View order',
      onPressed: () => Navigator.pushNamed(context, AppRoutes.summary),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.receipt_long),
      ),
    );
  }
}
