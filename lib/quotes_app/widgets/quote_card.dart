import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quote.dart';
import '../providers/quote_providers.dart';

// Used on both screens. Watches the favourites so its heart is always right.
class QuoteCard extends ConsumerWidget {
  const QuoteCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavourite = ref.watch(favouritesProvider).any((q) => q.id == quote.id);
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('“${quote.text}”', style: text.bodyLarge),
                  const SizedBox(height: 8),
                  Text('— ${quote.author}', style: text.labelLarge?.copyWith(color: colors.primary)),
                ],
              ),
            ),
            IconButton(
              tooltip: isFavourite ? 'Remove from favourites' : 'Save to favourites',
              icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
              color: isFavourite ? colors.error : null,
              onPressed: () => ref.read(favouritesProvider.notifier).toggle(quote),
            ),
          ],
        ),
      ),
    );
  }
}
