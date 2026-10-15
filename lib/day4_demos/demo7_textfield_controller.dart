// Day 4 · Demo 7 — TextField and TextEditingController
// Run: flutter run -t lib/day4_demos/demo7_textfield_controller.dart
//
// A TextEditingController lets your code READ, SET and CLEAR the text
// in a TextField. Create it in initState (or as a field) and dispose it.
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: TextFieldDemo()));

class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _greeting = '';
  bool _hidePassword = true;

  @override
  void dispose() {
    // Controllers hold resources, so dispose them with the widget.
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _sayHello() {
    // Read the current text from the controller.
    setState(() => _greeting = 'Hello, ${_nameController.text.trim()}!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextField')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your name',
              hintText: 'e.g. Ravi Kumar',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            // onChanged runs on every keystroke. Here it updates the counter below.
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _sayHello(), // the keyboard's Done key
          ),
          const SizedBox(height: 4),
          Text('${_nameController.text.length} characters'),
          const SizedBox(height: 16),

          TextField(
            controller: _passwordController,
            obscureText: _hidePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const TextField(
            keyboardType: TextInputType.phone, // shows the number pad
            decoration: InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: FilledButton(onPressed: _sayHello, child: const Text('Say hello')),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Change the text from code.
                    _nameController.clear();
                    setState(() => _greeting = '');
                  },
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(_greeting, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
