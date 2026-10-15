// Day 6 · Demo 1 — The http package, status codes and raw JSON
// Run: flutter run -t lib/day6_demos/demo1_http_basics.dart
//
// An API is a web address that returns DATA (JSON) instead of a web page.
// Open https://jsonplaceholder.typicode.com/users/1 in a browser to see it.
//
//   1. Send a GET request to the address.
//   2. Check the status code: 200 means OK, 404 means "not found".
//   3. The body is one long String of JSON. jsonDecode turns it into a Map.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: HttpBasicsScreen()));

class HttpBasicsScreen extends StatefulWidget {
  const HttpBasicsScreen({super.key});

  @override
  State<HttpBasicsScreen> createState() => _HttpBasicsScreenState();
}

class _HttpBasicsScreenState extends State<HttpBasicsScreen> {
  bool _loading = false;
  int? _statusCode;
  String _rawBody = '';
  String _decoded = '';

  // `async` because the request takes time. `await` waits for the answer
  // without freezing the app.
  Future<void> _send(String url) async {
    setState(() {
      _loading = true;
      _statusCode = null;
      _rawBody = '';
      _decoded = '';
    });

    final response = await http.get(Uri.parse(url));

    // The body is plain text. jsonDecode turns JSON text into Dart Maps and Lists.
    final Map<String, dynamic> json = jsonDecode(response.body);

    setState(() {
      _loading = false;
      _statusCode = response.statusCode;
      _rawBody = response.body;
      _decoded = response.statusCode == 200
          ? 'name:  ${json['name']}\nemail: ${json['email']}\ncity:  ${json['address']['city']}'
          : 'Nothing to read: the server said ${response.statusCode}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('http basics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton(
            onPressed: () =>
                _send('https://jsonplaceholder.typicode.com/users/1'),
            child: const Text('GET user 1  (should be 200)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () =>
                _send('https://jsonplaceholder.typicode.com/users/9999'),
            child: const Text('GET user 9999  (should be 404)'),
          ),
          const SizedBox(height: 24),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (_statusCode != null) ...[
            Text('Status code: $_statusCode', style: text.titleLarge),
            const SizedBox(height: 16),
            Text('1. Raw body (a String):', style: text.titleSmall),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: Text(
                _rawBody,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '2. After jsonDecode (read fields by name):',
              style: text.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(_decoded, style: const TextStyle(fontFamily: 'monospace')),
          ],
        ],
      ),
    );
  }
}
