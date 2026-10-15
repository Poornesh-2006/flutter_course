import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../widgets/contact_avatar.dart';

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen({super.key, required this.contact});

  final Contact contact; // passed in from the list screen

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(contact.name)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        children: [
          Center(child: ContactAvatar(contact: contact, radius: 48)),
          const SizedBox(height: 16),
          Text(contact.name, style: text.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(contact.phone),
            subtitle: const Text('Mobile'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(contact.email),
            subtitle: const Text('Email'),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: colors.error),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete contact'),
              // Close the screen and tell the list screen to remove this contact.
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
        ],
      ),
    );
  }
}
