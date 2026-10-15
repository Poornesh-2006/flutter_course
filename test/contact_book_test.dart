import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tutorial_project/contact_book/main.dart';
import 'package:tutorial_project/contact_book/validators.dart';

void main() {
  group('validators', () {
    test('name', () {
      expect(validateName(''), isNotNull);
      expect(validateName(' A '), isNotNull);
      expect(validateName('Ravi'), isNull);
    });

    test('phone', () {
      expect(validatePhone(''), isNotNull);
      expect(validatePhone('98765abcde'), isNotNull);
      expect(validatePhone('98765'), isNotNull);
      expect(validatePhone('98765 43210'), isNull);
    });

    test('email', () {
      expect(validateEmail(''), isNotNull);
      expect(validateEmail('ravi@'), isNotNull);
      expect(validateEmail('ravi@example.com'), isNull);
    });
  });

  testWidgets('add a contact, open it, delete it', (tester) async {
    await tester.pumpWidget(const ContactBookApp());
    expect(find.text('Contacts (3)'), findsOneWidget);

    // Open the form and submit it empty: errors appear, screen stays open.
    await tester.tap(find.text('Add contact'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save contact'));
    await tester.pump();
    expect(find.text('Enter a name'), findsOneWidget);
    expect(find.text('Enter a phone number'), findsOneWidget);

    // Fill it in and save: the new contact comes back to the list.
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ravi Kumar');
    await tester.enterText(fields.at(1), '9000011111');
    await tester.enterText(fields.at(2), 'ravi@example.com');
    await tester.tap(find.text('Save contact'));
    await tester.pumpAndSettle();
    expect(find.text('Contacts (4)'), findsOneWidget);
    expect(find.text('Ravi Kumar'), findsOneWidget);

    // Open the detail screen, then delete.
    await tester.tap(find.text('Ravi Kumar'));
    await tester.pumpAndSettle();
    expect(find.text('ravi@example.com'), findsOneWidget);
    await tester.tap(find.text('Delete contact'));
    await tester.pumpAndSettle();
    expect(find.text('Contacts (3)'), findsOneWidget);
    expect(find.text('Ravi Kumar'), findsNothing);
  });
}
