import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/joke.dart';
import '../services/joke_service.dart';

// One http.Client for the whole app, closed when the app is done with it.
// Tests replace this provider with a fake client.
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final jokeServiceProvider = Provider<JokeService>((ref) {
  return JokeService(ref.watch(httpClientProvider));
});

// The current joke. ref.invalidate(jokeProvider) throws it away and fetches a new one.
final jokeProvider = FutureProvider<Joke>((ref) {
  return ref.watch(jokeServiceProvider).fetchRandomJoke();
});
