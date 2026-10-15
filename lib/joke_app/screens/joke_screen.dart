import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/joke.dart';
import '../providers/joke_providers.dart';

class JokeScreen extends ConsumerWidget {
  const JokeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokeAsync = ref.watch(jokeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Joke of the moment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            // One branch per state: loading, error, data.
            child: jokeAsync.when(
              skipLoadingOnRefresh: false,
              loading: () => const _Loading(),
              error: (error, _) => _ErrorMessage(message: error.toString()),
              data: (joke) => _JokeCard(joke: joke),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: FilledButton.icon(
            // Disabled while a joke is loading, so taps can't pile up.
            onPressed: jokeAsync.isLoading ? null : () => ref.invalidate(jokeProvider),
            icon: const Icon(Icons.sentiment_very_satisfied),
            label: Text(jokeAsync.hasError ? 'Try again' : 'Next joke'),
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Finding a joke…'),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.wifi_off, size: 56, color: colors.error),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _JokeCard extends StatelessWidget {
  const _JokeCard({required this.joke});

  final Joke joke;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(joke.type)),
            const SizedBox(height: 16),
            Text(joke.setup, style: text.headlineSmall),
            const SizedBox(height: 20),
            Text(joke.punchline, style: text.titleLarge?.copyWith(color: colors.primary)),
          ],
        ),
      ),
    );
  }
}
