// Day 7 · Demo 2 — Saving a list: favourites that survive a restart
// Run: flutter run -t lib/day7_demos/demo2_prefs_list.dart
//
// shared_preferences can save a List<String>. Here we save the NAMES of the
// favourite cities. Tap some hearts, restart the app: they're still red.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: CitiesScreen()));

const cities = ['Hyderabad', 'Bengaluru', 'Chennai', 'Mumbai', 'Delhi', 'Kolkata', 'Pune', 'Jaipur'];
const _kFavourites = 'favouriteCities';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  List<String> _favourites = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favourites = prefs.getStringList(_kFavourites) ?? [];
      _loaded = true;
    });
  }

  Future<void> _toggle(String city) async {
    setState(() {
      _favourites = _favourites.contains(city)
          ? _favourites.where((c) => c != city).toList()
          : [..._favourites, city];
    });
    // Save the whole list every time it changes.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavourites, _favourites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite cities (${_favourites.length})')),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                for (final city in cities)
                  ListTile(
                    title: Text(city),
                    trailing: IconButton(
                      icon: Icon(
                        _favourites.contains(city) ? Icons.favorite : Icons.favorite_border,
                        color: _favourites.contains(city) ? Colors.red : null,
                      ),
                      onPressed: () => _toggle(city),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Saved under the key "$_kFavourites":\n$_favourites',
                      style: const TextStyle(fontFamily: 'monospace')),
                ),
              ],
            ),
    );
  }
}
