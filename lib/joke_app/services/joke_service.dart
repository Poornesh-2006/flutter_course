import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/joke.dart';

// A readable message the screen can show as-is.
class JokeException implements Exception {
  const JokeException(this.message);

  final String message;

  @override
  String toString() => message;
}

// All the network code lives here, not in widgets.
// The http.Client is passed in, so tests can give it a fake one.
class JokeService {
  JokeService(this._client);

  final http.Client _client;

  static final _url = Uri.parse('https://official-joke-api.appspot.com/random_joke');

  Future<Joke> fetchRandomJoke() async {
    try {
      final response = await _client.get(_url).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw JokeException('The joke server answered ${response.statusCode}. Try again in a moment.');
      }
      return Joke.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } on TimeoutException {
      throw const JokeException('The joke server is taking too long. Check your connection and try again.');
    } on http.ClientException {
      throw const JokeException('No internet connection. Check your Wi-Fi or mobile data.');
    } on FormatException {
      throw const JokeException('The joke server sent something we could not read.');
    }
  }
}
