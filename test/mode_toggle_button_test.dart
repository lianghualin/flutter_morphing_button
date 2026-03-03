import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphing_button/morphing_button.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('ModeToggleState enum', () {
    test('has 3 values', () {
      expect(ModeToggleState.values.length, 3);
    });

    test('contains expected values', () {
      expect(ModeToggleState.values, contains(ModeToggleState.split));
      expect(ModeToggleState.values, contains(ModeToggleState.collapsedRight));
      expect(ModeToggleState.values, contains(ModeToggleState.collapsedLeft));
    });
  });

  group('ModeToggleButton construction', () {
    testWidgets('renders with defaults', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(),
      ));
      expect(find.byType(ModeToggleButton), findsOneWidget);
    });

    testWidgets('renders with custom values', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.split,
          expandedWidth: 260,
          collapsedWidth: 48,
          label: 'Menu',
          iconSize: 20,
          arrowSize: 8,
          strokeWidth: 1.5,
          animationDuration: Duration(milliseconds: 200),
        ),
      ));
      expect(find.byType(ModeToggleButton), findsOneWidget);
    });
  });

  group('ModeToggleButton split mode', () {
    testWidgets('renders HamburgerMorphPainter', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.split,
          label: 'Menu',
        ),
      ));
      final paints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
      final hasHamburger = paints.any(
        (cp) => cp.painter.runtimeType.toString() == 'HamburgerMorphPainter',
      );
      expect(hasHamburger, isTrue);
    });

    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.split,
          label: 'Menu',
        ),
      ));
      expect(find.text('Menu'), findsOneWidget);
    });

    testWidgets('fires onLeftTap when left portion is tapped', (tester) async {
      var leftTapped = false;
      var rightTapped = false;
      await tester.pumpWidget(wrap(
        ModeToggleButton(
          state: ModeToggleState.split,
          label: 'Menu',
          expandedWidth: 220,
          onLeftTap: () => leftTapped = true,
          onRightTap: () => rightTapped = true,
        ),
      ));

      // Tap left portion of the button
      final buttonFinder = find.byType(ModeToggleButton);
      final topLeft = tester.getTopLeft(buttonFinder);
      await tester.tapAt(Offset(topLeft.dx + 20, topLeft.dy + 24));
      await tester.pump();

      expect(leftTapped, isTrue);
      expect(rightTapped, isFalse);
    });

    testWidgets('fires onRightTap when right portion is tapped',
        (tester) async {
      var leftTapped = false;
      var rightTapped = false;
      await tester.pumpWidget(wrap(
        ModeToggleButton(
          state: ModeToggleState.split,
          label: 'Menu',
          expandedWidth: 220,
          onLeftTap: () => leftTapped = true,
          onRightTap: () => rightTapped = true,
        ),
      ));

      // Tap right portion of the button
      final buttonFinder = find.byType(ModeToggleButton);
      final topRight = tester.getTopRight(buttonFinder);
      await tester.tapAt(Offset(topRight.dx - 20, topRight.dy + 24));
      await tester.pump();

      expect(rightTapped, isTrue);
      expect(leftTapped, isFalse);
    });
  });

  group('ModeToggleButton collapsedRight mode', () {
    testWidgets('renders at full width after animation', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.collapsedRight,
          expandedWidth: 220,
          label: 'Menu',
        ),
      ));
      // Pump past animation duration (ticker never settles, so use explicit duration)
      await tester.pump(const Duration(milliseconds: 350));

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final hasExpandedWidth = sizedBoxes.any(
        (sb) => sb.width != null && (sb.width! - 220).abs() < 1,
      );
      expect(hasExpandedWidth, isTrue);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        ModeToggleButton(
          state: ModeToggleState.collapsedRight,
          label: 'Menu',
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(ModeToggleButton));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.collapsedRight,
          label: 'Menu',
        ),
      ));
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Menu'), findsOneWidget);
    });
  });

  group('ModeToggleButton collapsedLeft mode', () {
    testWidgets('renders at collapsed width after animation', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.collapsedLeft,
          collapsedWidth: 52,
          label: 'Menu',
        ),
      ));
      await tester.pump(const Duration(milliseconds: 350));

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final hasCollapsedWidth = sizedBoxes.any(
        (sb) => sb.width != null && (sb.width! - 52).abs() < 1,
      );
      expect(hasCollapsedWidth, isTrue);
    });

    testWidgets('hides label at collapsed width', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.collapsedLeft,
          collapsedWidth: 52,
          label: 'Menu',
        ),
      ));
      await tester.pump(const Duration(milliseconds: 350));

      // At collapsed width, label should not be rendered (labelOpacity <= 0.01)
      expect(find.text('Menu'), findsNothing);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        ModeToggleButton(
          state: ModeToggleState.collapsedLeft,
          label: 'Menu',
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(ModeToggleButton));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('ModeToggleButton disabled', () {
    testWidgets('suppresses taps when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        ModeToggleButton(
          state: ModeToggleState.split,
          label: 'Menu',
          enabled: false,
          onTap: () => tapped = true,
          onLeftTap: () => tapped = true,
          onRightTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(ModeToggleButton));
      await tester.pump();
      expect(tapped, isFalse);
    });
  });

  group('ModeToggleButton branding (icon + label)', () {
    testWidgets('renders icon widget in split mode', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.split,
          icon: Icon(Icons.dashboard, size: 20),
          label: 'Playground',
        ),
      ));
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.text('Playground'), findsOneWidget);
    });

    testWidgets('icon is wrapped in IgnorePointer', (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.split,
          icon: Icon(Icons.dashboard, size: 20),
          label: 'Playground',
        ),
      ));
      final iconFinder = find.byIcon(Icons.dashboard);
      final ignorePointer = find.ancestor(
        of: iconFinder,
        matching: find.byType(IgnorePointer),
      );
      expect(ignorePointer, findsWidgets);
    });

    testWidgets('collapsedLeft shows icon overlay instead of hamburger',
        (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.collapsedLeft,
          collapsedWidth: 52,
          icon: Icon(Icons.dashboard, size: 20),
          label: 'Playground',
        ),
      ));
      await tester.pump(const Duration(milliseconds: 350));

      // Icon should still be visible (in the overlay)
      expect(find.byIcon(Icons.dashboard), findsWidgets);
      // Label should be hidden at collapsed width
      expect(find.text('Playground'), findsNothing);
    });

    testWidgets('collapsedLeft shows monogram when label-only (no icon)',
        (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.collapsedLeft,
          collapsedWidth: 52,
          label: 'Playground',
        ),
      ));
      await tester.pump(const Duration(milliseconds: 350));

      // Monogram first character should appear
      expect(find.text('P'), findsOneWidget);
      // Full label should be hidden
      expect(find.text('Playground'), findsNothing);
    });

    testWidgets('collapsedRight renders icon + label + morphed icon',
        (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.collapsedRight,
          icon: Icon(Icons.dashboard, size: 20),
          label: 'Playground',
        ),
      ));
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byIcon(Icons.dashboard), findsWidgets);
      expect(find.text('Playground'), findsOneWidget);
    });

    testWidgets('no icon or label renders exactly as before (backwards compat)',
        (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.split,
        ),
      ));

      // No IgnorePointer wrapping an icon
      expect(find.byType(Icon), findsNothing);
      // Hamburger painter still present
      final paints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
      final hasHamburger = paints.any(
        (cp) => cp.painter.runtimeType.toString() == 'HamburgerMorphPainter',
      );
      expect(hasHamburger, isTrue);
    });

    testWidgets('icon-only (no label) renders icon in split mode',
        (tester) async {
      await tester.pumpWidget(wrap(
        const ModeToggleButton(
          state: ModeToggleState.split,
          icon: Icon(Icons.dashboard, size: 20),
        ),
      ));
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
    });

    testWidgets('split mode with branding still fires onLeftTap/onRightTap',
        (tester) async {
      var leftTapped = false;
      var rightTapped = false;
      await tester.pumpWidget(wrap(
        ModeToggleButton(
          state: ModeToggleState.split,
          icon: const Icon(Icons.dashboard, size: 20),
          label: 'Playground',
          expandedWidth: 220,
          onLeftTap: () => leftTapped = true,
          onRightTap: () => rightTapped = true,
        ),
      ));

      final buttonFinder = find.byType(ModeToggleButton);
      final topLeft = tester.getTopLeft(buttonFinder);
      await tester.tapAt(Offset(topLeft.dx + 20, topLeft.dy + 24));
      await tester.pump();

      expect(leftTapped, isTrue);
      expect(rightTapped, isFalse);
    });
  });
}
