// Day 3 · Demo 4 — ListView and ListView.builder
// Run: flutter run -t lib/day3_demos/demo4_listview.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ListViewDemo()));

class ListViewDemo extends StatelessWidget {
  const ListViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Pretend this list came from a server: 1000 movies.
    final movies = List.generate(1000, (i) => 'Movie #${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('ListView')),
      body: Column(
        children: [
          // 1. Plain ListView: you write every child by hand.
          //    Fine for a few fixed items (a settings page).
          SizedBox(
            height: 150,
            child: ListView(
              children: const [
                ListTile(leading: Icon(Icons.person), title: Text('Profile')),
                ListTile(leading: Icon(Icons.lock), title: Text('Privacy')),
                ListTile(leading: Icon(Icons.notifications), title: Text('Notifications')),
              ],
            ),
          ),
          const Divider(thickness: 4),

          // 2. ListView.builder: builds rows lazily, only the ones on screen.
          //    Use it for long or dynamic lists. A ListView inside a Column needs
          //    a bounded height, hence Expanded.
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                // Watch the console: only visible rows get built.
                debugPrint('building row $index');
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(movies[index]),
                  subtitle: const Text('Action · 2h 10m'),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
