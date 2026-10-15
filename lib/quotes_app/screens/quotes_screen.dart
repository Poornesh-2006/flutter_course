import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quote_providers.dart';
import '../routes.dart';
import '../widgets/quote_card.dart';

class QuotesScreen extends ConsumerWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesAsync = ref.watch(quotesProvider);
    final favouriteCount = ref.watch(favouritesProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
        actions: [
          IconButton(
            tooltip: 'My favourites',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favourites),
            icon: Badge(
              isLabelVisible: favouriteCount > 0,
              label: Text('$favouriteCount'),
              child: const Icon(Icons.favorite),
            ),
          ),
        ],
      ),
      body: quotesAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 56, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 12),
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(quotesProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.favourites),
                  child: const Text('Open my saved favourites'),
                ),
              ],
            ),
          ),
        ),
        data: (quotes) => quotes.isEmpty
            ? const Center(child: Text('No quotes right now. Pull down to try again.'))
            : RefreshIndicator(
                onRefresh: () => ref.refresh(quotesProvider.future),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: quotes.length,
                  itemBuilder: (context, index) => QuoteCard(quote: quotes[index]),
                ),
              ),
      ),
    );
  }
}
