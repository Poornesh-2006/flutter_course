import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../widgets/contact_avatar.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  // Sample contacts so the list isn't empty on first launch.
  final List<Contact> _contacts = [
    const Contact(name: 'Ananya Rao', phone: '9876543210', email: 'ananya@example.com'),
    const Contact(name: 'Karthik Reddy', phone: '9123456780', email: 'karthik@example.com'),
    const Contact(name: 'Meera Iyer', phone: '9988776655', email: 'meera@example.com'),
  ];

  Future<void> _openAddContact() async {
    // Wait for the form screen to pop. It returns a Contact, or null if cancelled.
    final newContact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
    if (newContact == null || !mounted) return;

    setState(() {
      _contacts.add(newContact);
      _contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newContact.name} added')),
    );
  }

  Future<void> _openDetail(Contact contact) async {
    // The detail screen returns true when the user deletes the contact.
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => ContactDetailScreen(contact: contact)),
    );
    if (deleted != true || !mounted) return;

    setState(() => _contacts.remove(contact));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${contact.name} deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts (${_contacts.length})')),
      body: _contacts.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ListTile(
                  leading: ContactAvatar(contact: contact),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openDetail(contact),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddContact,
        icon: const Icon(Icons.person_add),
        label: const Text('Add contact'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.contacts_outlined, size: 64, color: colors.outline),
          const SizedBox(height: 12),
          const Text('No contacts yet'),
          const SizedBox(height: 4),
          Text('Tap “Add contact” to create one', style: TextStyle(color: colors.outline)),
        ],
      ),
    );
  }
}
