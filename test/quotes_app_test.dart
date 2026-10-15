import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tutorial_project/quotes_app/main.dart';
import 'package:tutorial_project/quotes_app/providers/quote_providers.dart';

final fakeServer = MockClient((request) async => http.Response(
      jsonEncode({
        'quotes': [
          {'id': 1, 'quote': 'First quote', 'author': 'Rumi'},
          {'id': 2, 'quote': 'Second quote', 'author': 'Abdul Kalam'},
        ],
        'total': 2,
      }),
      200,
    ));

final offline = MockClient((request) async => throw http.ClientException('offline'));

Future<Widget> appWith(MockClient client) async {
  final prefs = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      httpClientProvider.overrideWithValue(client),
    ],
    retry: (retryCount, error) => null,
    child: const QuotesApp(),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({})); // empty storage before each test

  testWidgets('favourite a quote, and it is saved to storage', (tester) async {
    await tester.pumpWidget(await appWith(fakeServer));
    await tester.pumpAndSettle();
    expect(find.text('“First quote”'), findsOneWidget);

    await tester.tap(find.byTooltip('Save to favourites').first);
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favourite_quotes')!;
    expect(saved, hasLength(1));
    expect(jsonDecode(saved.single)['author'], 'Rumi');

    await tester.tap(find.byTooltip('My favourites'));
    await tester.pumpAndSettle();
    expect(find.text('My favourites (1)'), findsOneWidget);
    expect(find.text('“First quote”'), findsOneWidget);
  });

  testWidgets('saved favourites load on start and work offline', (tester) async {
    SharedPreferences.setMockInitialValues({
      'favourite_quotes': [jsonEncode({'id': 9, 'quote': 'Saved yesterday', 'author': 'Tagore'})],
    });

    await tester.pumpWidget(await appWith(offline));
    await tester.pumpAndSettle();
    expect(find.text('No internet connection. Your saved favourites still work offline.'), findsOneWidget);

    await tester.tap(find.text('Open my saved favourites'));
    await tester.pumpAndSettle();
    expect(find.text('“Saved yesterday”'), findsOneWidget);

    // Un-favourite it: storage is updated too.
    await tester.tap(find.byTooltip('Remove from favourites'));
    await tester.pumpAndSettle();
    expect(find.text('No favourites yet'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('favourite_quotes'), isEmpty);
  });
}
