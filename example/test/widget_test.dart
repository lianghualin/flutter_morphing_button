import 'package:flutter_test/flutter_test.dart';

import 'package:morphing_button_example/main.dart';

void main() {
  testWidgets('App renders playground page', (WidgetTester tester) async {
    await tester.pumpWidget(const MorphingButtonApp());
    expect(find.text('Morphing Buttons'), findsOneWidget);
  });
}
