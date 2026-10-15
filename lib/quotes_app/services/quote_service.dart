import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/quote.dart';

class QuoteException implements Exception {
  const QuoteException(this.message);

  final String message;

  @override
  String toString() => message;
}

class QuoteService {
  QuoteService(this._client, {Random? random}) : _random = random ?? Random();

  final http.Client _client;
  final Random _random;

  static const pageSize = 20;

  /// Fetches [pageSize] quotes starting at a random position, so every
  /// refresh shows a different set. The API has about 1,450 quotes.
  Future<List<Quote>> fetchQuotes() async {
    final skip = _random.nextInt(1400);
    final url = Uri.parse('https://dummyjson.com/quotes?limit=$pageSize&skip=$skip');

    try {
      final response = await _client.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw QuoteException('The quotes server answered ${response.statusCode}. Pull down to try again.');
      }

      // The list is inside the "quotes" key: {"quotes": [...], "total": 1454, ...}
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> items = body['quotes'];
      return items.map((item) => Quote.fromJson(item as Map<String, dynamic>)).toList();
    } on TimeoutException {
      throw const QuoteException('The quotes server is taking too long. Check your connection.');
    } on http.ClientException {
      throw const QuoteException('No internet connection. Your saved favourites still work offline.');
    } on FormatException {
      throw const QuoteException('The quotes server sent something we could not read.');
    }
  }
}
