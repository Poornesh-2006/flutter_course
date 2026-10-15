import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:tutorial_project/joke_app/main.dart';
import 'package:tutorial_project/joke_app/providers/joke_providers.dart';

// A fake server: no real internet needed in tests.
Widget appWith(MockClient client) => ProviderScope(
      overrides: [httpClientProvider.overrideWithValue(client)],
      retry: (retryCount, error) => null,
      child: const JokeApp(),
    );

String jokeJson(int id) => jsonEncode({
      'type': 'general',
      'setup': 'Setup number $id',
      'punchline': 'Punchline number $id',
      'id': id,
    });

void main() {
  testWidgets('shows a joke, and Next joke fetches another', (tester) async {
    var calls = 0;
    final client = MockClient((request) async => http.Response(jokeJson(++calls), 200));

    await tester.pumpWidget(appWith(client));
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // loading first
    await tester.pumpAndSettle();
    expect(find.text('Setup number 1'), findsOneWidget);
    expect(find.text('Punchline number 1'), findsOneWidget);

    await tester.tap(find.text('Next joke'));
    await tester.pumpAndSettle();
    expect(find.text('Setup number 2'), findsOneWidget);
  });

  testWidgets('server error shows a message and Try again recovers', (tester) async {
    var fail = true;
    final client = MockClient((request) async =>
        fail ? http.Response('oops', 500) : http.Response(jokeJson(7), 200));

    await tester.pumpWidget(appWith(client));
    await tester.pumpAndSettle();
    expect(find.text('The joke server answered 500. Try again in a moment.'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Setup number 7'), findsOneWidget);
  });

  testWidgets('no internet shows a friendly message', (tester) async {
    final client = MockClient((request) async => throw http.ClientException('offline'));

    await tester.pumpWidget(appWith(client));
    await tester.pumpAndSettle();
    expect(find.text('No internet connection. Check your Wi-Fi or mobile data.'), findsOneWidget);
  });
}
