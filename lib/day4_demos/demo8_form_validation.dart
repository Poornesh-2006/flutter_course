// Day 4 · Demo 8 — Form, TextFormField, GlobalKey<FormState>, validators
// Run: flutter run -t lib/day4_demos/demo8_form_validation.dart
//
// Form groups fields together. The GlobalKey gives us a handle on the form
// so we can call validate() on every field at once.
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: SignUpScreen()));

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    // validate() runs every field's validator and shows their error messages.
    // It returns true only if all of them returned null.
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Form(
        key: _formKey,
        // Re-check a field as soon as the user has typed in it.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // A validator returns null when the value is OK,
            // or an error message String when it isn't.
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Enter your name';
                if (value.trim().length < 2) return 'Name is too short';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Enter your email';
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Enter a valid email, like name@example.com';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.length < 8) return 'Use at least 8 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm password', border: OutlineInputBorder()),
              // A validator can compare with another field through its controller.
              validator: (value) {
                if (value != _passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _submit, child: const Text('Create account')),
          ],
        ),
      ),
    );
  }
}
