import 'package:flutter/material.dart';

import '../models/contact.dart';

// Circle with the contact's initials. Used on both the list and detail screens.
class ContactAvatar extends StatelessWidget {
  const ContactAvatar({super.key, required this.contact, this.radius = 20});

  final Contact contact;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primaryContainer,
      foregroundColor: colors.onPrimaryContainer,
      child: Text(contact.initials, style: TextStyle(fontSize: radius * 0.8)),
    );
  }
}
