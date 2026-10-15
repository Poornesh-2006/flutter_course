// Day 7 · Demo 1 — shared_preferences: saving simple values on the device
// Run: flutter run -t lib/day7_demos/demo1_prefs_basics.dart
//
// Normal variables are lost when the app closes. shared_preferences saves
// small values on the phone (or in the browser) under a KEY, like labelled
// jars on a shelf:  "name" → "Ravi",  "darkMode" → true,  "openCount" → 4
//
// Try it: type a name, flip the switch, then fully restart the app
// (stop it and run again, or refresh the browser tab). Everything is still there.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: SettingsScreen()));

// The keys, written once so a typo can't create a second jar.
const _kName = 'name';
const _kDarkMode = 'darkMode';
const _kOpenCount = 'openCount';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences? _prefs; // null until loaded
  final _nameController = TextEditingController();
  bool _darkMode = false;
  int _openCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Loading saved data on app start.
  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance(); // open the shelf

    // getX returns null if nothing was ever saved under that key, so ?? gives a default.
    final openCount = (prefs.getInt(_kOpenCount) ?? 0) + 1;
    await prefs.setInt(_kOpenCount, openCount); // count this launch

    setState(() {
      _prefs = prefs;
      _nameController.text = prefs.getString(_kName) ?? '';
      _darkMode = prefs.getBool(_kDarkMode) ?? false;
      _openCount = openCount;
    });
  }

  Future<void> _saveName() async {
    await _prefs!.setString(_kName, _nameController.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Name saved')));
  }

  Future<void> _setDarkMode(bool value) async {
    setState(() => _darkMode = value);
    await _prefs!.setBool(_kDarkMode, value); // save straight away
  }

  Future<void> _forgetEverything() async {
    await _prefs!.clear(); // empties every jar (remove(key) empties just one)
    setState(() {
      _nameController.clear();
      _darkMode = false;
      _openCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a spinner until the saved values are loaded.
    if (_prefs == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Theme(
      data: ThemeData(
        brightness: _darkMode ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Saved settings')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'You have opened this app $_openCount ${_openCount == 1 ? 'time' : 'times'}.',
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _saveName, child: const Text('Save name')),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: const Text('Saved as soon as you flip it'),
              value: _darkMode,
              onChanged: _setDarkMode,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _forgetEverything,
              child: const Text('Forget everything'),
            ),
          ],
        ),
      ),
    );
  }
}
