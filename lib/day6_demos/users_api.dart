// Shared by demos 2 and 3: a typed model class and one function that
// fetches users and turns every kind of failure into a readable message.
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  const User({required this.id, required this.name, required this.email, required this.company});

  final int id;
  final String name;
  final String email;
  final String company;

  // fromJson: turn one JSON Map into one User.
  // The keys must match the API exactly. `company` is nested: {"company": {"name": "..."}}.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      company: json['company']['name'] as String,
    );
  }
}

// Our own error type, so the screen can show `error.message` to the user.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// [broken] points at an address that doesn't exist, to practise error states
/// without switching off the Wi-Fi. [empty] asks for a list with no users.
Future<List<User>> fetchUsers({bool broken = false, bool empty = false}) async {
  final url = broken
      ? 'https://jsonplaceholder.typicode.com/no-such-page'
      : empty
          ? 'https://jsonplaceholder.typicode.com/users?id=0'
          : 'https://jsonplaceholder.typicode.com/users';

  try {
    // Give up after 10 seconds instead of spinning forever.
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw ApiException('The server answered ${response.statusCode}. Please try again.');
    }

    // The body is a JSON list: [ {...}, {...} ]. Turn each Map into a User.
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();
  } on TimeoutException {
    throw const ApiException('The server took too long to answer. Check your connection and try again.');
  } on http.ClientException {
    // No Wi-Fi, no mobile data, or the server can't be reached.
    throw const ApiException('No internet connection. Check your Wi-Fi or mobile data.');
  } on FormatException {
    throw const ApiException('The server sent data we could not read.');
  }
}
