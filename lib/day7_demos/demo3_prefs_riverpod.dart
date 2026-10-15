// Day 7 · Demo 3 — Local storage + Riverpod
// Run: flutter run -t lib/day7_demos/demo3_prefs_riverpod.dart
//
// Demo 2 again, but the favourites live in a Notifier that loads them from
// storage at the start and saves them on every change. The screens only
// call toggle(); they don't know storage exists.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cities = ['Hyderabad', 'Bengaluru', 'Chennai', 'Mumbai', 'Delhi', 'Kolkata', 'Pune', 'Jaipur'];
const _kFavourites = 'favouriteCities';

// A provider for the storage itself. It has no real value here:
// main() opens the storage first and plugs it in with overrideWithValue.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override sharedPreferencesProvider in main()');
});

class FavouritesNotifier extends Notifier<List<String>> {
  // Starting value = whatever was saved last time.
  @override
  List<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getStringList(_kFavourites) ?? [];
  }

  void toggle(String city) {
    state = state.contains(city) ? state.where((c) => c != city).toList() : [...state, city];
    ref.read(sharedPreferencesProvider).setStringList(_kFavourites, state); // save
  }

  void clear() {
    state = [];
    ref.read(sharedPreferencesProvider).remove(_kFavourites);
  }
}

final favouritesProvider = NotifierProvider<FavouritesNotifier, List<String>>(FavouritesNotifier.new);

// main is async: open the storage BEFORE the app starts, so every screen
// can read saved data straight away, with no loading spinner.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // needed before using plugins in main
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MaterialApp(home: CitiesScreen()),
    ),
  );
}

class CitiesScreen extends ConsumerWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities · Riverpod'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavouritesScreen()),
            ),
            icon: const Icon(Icons.favorite),
            label: Text('${favourites.length}'),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final city in cities)
            ListTile(
              title: Text(city),
              trailing: IconButton(
                icon: Icon(
                  favourites.contains(city) ? Icons.favorite : Icons.favorite_border,
                  color: favourites.contains(city) ? Colors.red : null,
                ),
                onPressed: () => ref.read(favouritesProvider.notifier).toggle(city),
              ),
            ),
        ],
      ),
    );
  }
}

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My favourites'),
        actions: [
          if (favourites.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(favouritesProvider.notifier).clear(),
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: favourites.isEmpty
          ? const Center(child: Text('No favourites yet. Tap a heart on the cities list.'))
          : ListView(
              children: [
                for (final city in favourites)
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(city),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Remove',
                      onPressed: () => ref.read(favouritesProvider.notifier).toggle(city),
                    ),
                  ),
              ],
            ),
    );
  }
}
