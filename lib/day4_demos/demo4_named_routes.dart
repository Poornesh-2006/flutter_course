// Day 4 · Demo 4 — Named routes
// Run: flutter run -t lib/day4_demos/demo4_named_routes.dart
//
// Instead of building a MaterialPageRoute every time, give each screen a
// name in one place (the routes map) and navigate by name.
import 'package:flutter/material.dart';

void main() => runApp(const NamedRoutesApp());

// Keep route names as constants so a typo becomes a compile error,
// not a crash at runtime.
class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const profile = '/profile';
}

class NamedRoutesApp extends StatelessWidget {
  const NamedRoutesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
              child: const Text('Open settings'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              // Data travels in `arguments`.
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.profile,
                arguments: 'Priya',
              ),
              child: const Text("Open Priya's profile"),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Read the arguments passed to pushNamed. Their type isn't checked,
    // which is the main downside of named routes compared with constructors.
    final name = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('$name\'s profile')),
      body: Center(child: Text('Hello, $name!')),
    );
  }
}
