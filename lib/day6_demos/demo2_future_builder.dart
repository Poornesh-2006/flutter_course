// Day 6 · Demo 2 — Model classes, FutureBuilder, and the 4 screen states
// Run: flutter run -t lib/day6_demos/demo2_future_builder.dart
//
// Every screen that loads data must handle FOUR states:
//   loading → spinner      error → message + Retry
//   empty   → friendly text data  → the list
//
// Use the switches in the AppBar to see the error and empty states
// without switching off the Wi-Fi.
import 'package:flutter/material.dart';

import 'users_api.dart';

void main() => runApp(const MaterialApp(home: UsersScreen()));

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _broken = false;
  bool _empty = false;
  var name = 'Ravi';

  // Start the request ONCE, in initState, and keep the Future in a field.
  // Calling fetchUsers() inside build() would send a new request on every rebuild.
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }

  void _reload() {
    // Use { } here, not `() => ...`. The arrow form would RETURN the Future,
    // and setState refuses a callback that returns a Future.
    setState(() {
      _usersFuture = fetchUsers(broken: _broken, empty: _empty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users · FutureBuilder'),
        actions: [
          const Text('Break'),
          Switch(
            value: _broken,
            onChanged: (v) {
              _broken = v;
              _reload();
            },
          ),
          const Text('Empty'),
          Switch(
            value: _empty,
            onChanged: (v) {
              _empty = v;
              _reload();
            },
          ),
        ],
      ),
      // FutureBuilder rebuilds itself when the Future finishes.
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          // 1. Still waiting for the server.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Something went wrong.
          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          // 3. It worked, but there's nothing to show.
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          // 4. It worked and we have data.
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${user.id}')),
                title: Text(user.name),
                subtitle: Text('${user.email} · ${user.company}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
