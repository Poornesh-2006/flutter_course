import 'package:flutter_test/flutter_test.dart';

import 'package:tutorial_project/main.dart';

void main() {
  testWidgets('Menu shows dishes and filters by category', (tester) async {
    await tester.pumpWidget(const RestaurantApp());

    expect(find.text('Spice Route'), findsOneWidget);
    expect(find.text('Paneer Tikka'), findsOneWidget);

    await tester.tap(find.text('Desserts'));
    await tester.pump();

    expect(find.text('Gulab Jamun'), findsOneWidget);
    expect(find.text('Paneer Tikka'), findsNothing);
  });
}
