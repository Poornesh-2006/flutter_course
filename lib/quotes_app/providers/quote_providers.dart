import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quote.dart';
import '../services/quote_service.dart';

// ---------- Network (Session 6) ----------

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final quoteServiceProvider = Provider<QuoteService>((ref) {
  return QuoteService(ref.watch(httpClientProvider));
});

final quotesProvider = FutureProvider<List<Quote>>((ref) {
  return ref.watch(quoteServiceProvider).fetchQuotes();
});

// ---------- Local storage (Session 7) ----------

// Opened in main() before the app starts, then plugged in with overrideWithValue.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override sharedPreferencesProvider in main()');
});

const _kFavourites = 'favourite_quotes';

// Favourites are saved as a List<String>, one JSON string per quote:
//   ['{"id":1,"quote":"...","author":"Rumi"}', '{"id":7,...}']
// Saving the whole quote (not just its id) means favourites show even offline.
class FavouritesNotifier extends Notifier<List<Quote>> {
  @override
  List<Quote> build() {
    final saved = ref.watch(sharedPreferencesProvider).getStringList(_kFavourites) ?? [];
    return saved.map((s) => Quote.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }

  bool isFavourite(Quote quote) => state.any((q) => q.id == quote.id);

  void toggle(Quote quote) {
    state = isFavourite(quote)
        ? state.where((q) => q.id != quote.id).toList()
        : [quote, ...state]; // newest first
    _save();
  }

  void _save() {
    final encoded = state.map((q) => jsonEncode(q.toJson())).toList();
    ref.read(sharedPreferencesProvider).setStringList(_kFavourites, encoded);
  }
}

final favouritesProvider = NotifierProvider<FavouritesNotifier, List<Quote>>(FavouritesNotifier.new);
