// Day 6 · Demo 3 — FutureProvider and AsyncValue (the Riverpod way)
// Run: flutter run -t lib/day6_demos/demo3_future_provider.dart
//
// Same screen as demo 2, but:
//   - no StatefulWidget, no initState, no Future stored in a field,
//   - .when(loading:, error:, data:) instead of checking the snapshot by hand,
//   - Retry is ref.invalidate(usersProvider): "throw away the old result, fetch again".
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'users_api.dart';

final brokenProvider = StateProvider<bool>((ref) => false);
final emptyProvider = StateProvider<bool>((ref) => false);

// A FutureProvider runs an async function and remembers the result.
// Because it WATCHES the two switches, flipping one fetches again by itself.
final usersProvider = FutureProvider<List<User>>((ref) {
  return fetchUsers(
    broken: ref.watch(brokenProvider),
    empty: ref.watch(emptyProvider),
  );
});

void main() {
  runApp(
    ProviderScope(
      // Riverpod 3 retries failed providers automatically for ~30 seconds.
      // Turn that off so the error state shows straight away.
      retry: (retryCount, error) => null,
      child: const MaterialApp(home: UsersScreen()),
    ),
  );
}

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValue = "loading, OR error, OR data". Never more than one.
    final AsyncValue<List<User>> usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users · FutureProvider'),
        actions: [
          const Text('Break'),
          Switch(
            value: ref.watch(brokenProvider),
            onChanged: (v) => ref.read(brokenProvider.notifier).state = v,
          ),
          const Text('Empty'),
          Switch(
            value: ref.watch(emptyProvider),
            onChanged: (v) => ref.read(emptyProvider.notifier).state = v,
          ),
        ],
      ),
      // .when gives one function per state. You can't forget one: it won't compile.
      body: usersAsync.when(
        // Show the spinner again when Retry or a switch reloads the data.
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off, size: 56, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 12),
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(usersProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (users) {
          if (users.isEmpty) return const Center(child: Text('No users found.'));

          // Pull down to refresh. ref.refresh(...future) returns a Future,
          // so the spinner at the top disappears when loading finishes.
          return RefreshIndicator(
            onRefresh: () => ref.refresh(usersProvider.future),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${user.id}')),
                  title: Text(user.name),
                  subtitle: Text('${user.email} · ${user.company}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
