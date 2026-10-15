import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quote_providers.dart';
import '../widgets/quote_card.dart';

// Reads only from local storage (through favouritesProvider),
// so it works with no internet at all.
class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('My favourites (${favourites.length})')),
      body: favourites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 56, color: colors.outline),
                    const SizedBox(height: 12),
                    const Text('No favourites yet'),
                    const SizedBox(height: 4),
                    Text('Tap the heart on a quote to save it here.',
                        textAlign: TextAlign.center, style: TextStyle(color: colors.outline)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favourites.length,
              itemBuilder: (context, index) => QuoteCard(quote: favourites[index]),
            ),
    );
  }
}
