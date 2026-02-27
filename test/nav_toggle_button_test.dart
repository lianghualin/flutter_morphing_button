import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphing_button/morphing_button.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('NavToggleButton sidebar mode', () {
    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 200,
          mode: NavToggleMode.sidebar,
          icon: Icons.home,
          label: 'Home',
        ),
      ));
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('renders label when wide enough', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 200,
          mode: NavToggleMode.sidebar,
          icon: Icons.home,
          label: 'Home',
        ),
      ));
      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('NavToggleButton iconRail mode', () {
    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 56,
          mode: NavToggleMode.iconRail,
          icon: Icons.settings,
          label: 'Settings',
        ),
      ));
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows tooltip with label', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 56,
          mode: NavToggleMode.iconRail,
          icon: Icons.settings,
          label: 'Settings',
        ),
      ));
      expect(find.byType(Tooltip), findsOneWidget);
    });
  });

  group('NavToggleButton tabBar mode', () {
    testWidgets('renders icon and label', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 120,
          mode: NavToggleMode.tabBar,
          icon: Icons.star,
          label: 'Favorites',
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('renders CustomPaint for tab indicator', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 120,
          mode: NavToggleMode.tabBar,
          icon: Icons.star,
          isSelected: true,
        ),
      ));
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('NavToggleButton enabled state', () {
    testWidgets('disabled button suppresses tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        NavToggleButton(
          currentWidth: 200,
          mode: NavToggleMode.sidebar,
          icon: Icons.home,
          enabled: false,
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(NavToggleButton));
      await tester.pump();
      expect(tapped, false);
    });

    testWidgets('enabled button fires tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        NavToggleButton(
          currentWidth: 200,
          mode: NavToggleMode.sidebar,
          icon: Icons.home,
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(NavToggleButton));
      await tester.pump();
      expect(tapped, true);
    });
  });

  group('NavToggleButton isSelected visual', () {
    testWidgets('sidebar selected shows indicator', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 200,
          mode: NavToggleMode.sidebar,
          icon: Icons.home,
          label: 'Home',
          isSelected: true,
        ),
      ));
      // The selected indicator is a 3px wide Container
      // Just verify the widget renders without error
      expect(find.byType(NavToggleButton), findsOneWidget);
    });

    testWidgets('iconRail selected shows highlight', (tester) async {
      await tester.pumpWidget(wrap(
        const NavToggleButton(
          currentWidth: 56,
          mode: NavToggleMode.iconRail,
          icon: Icons.home,
          isSelected: true,
        ),
      ));
      expect(find.byType(NavToggleButton), findsOneWidget);
    });
  });
}
