import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphing_button/morphing_button.dart';

void main() {
  group('MorphingButtonThemeData', () {
    test('defaults are all null', () {
      const data = MorphingButtonThemeData();
      expect(data.accentColor, isNull);
      expect(data.textColor, isNull);
      expect(data.fontSize, isNull);
      expect(data.letterSpacing, isNull);
      expect(data.horizontalPadding, isNull);
      expect(data.verticalPadding, isNull);
      expect(data.arrowSize, isNull);
      expect(data.arrowStrokeWidth, isNull);
    });

    test('merge returns this when other is null', () {
      const data = MorphingButtonThemeData(fontSize: 16);
      final merged = data.merge(null);
      expect(identical(merged, data), true);
    });

    test('merge overrides non-null fields', () {
      const base = MorphingButtonThemeData(
        fontSize: 16,
        accentColor: Colors.red,
      );
      const override = MorphingButtonThemeData(
        fontSize: 20,
        letterSpacing: 3,
      );
      final merged = base.merge(override);
      expect(merged.fontSize, 20);
      expect(merged.accentColor, Colors.red);
      expect(merged.letterSpacing, 3);
    });

    test('equality', () {
      const a = MorphingButtonThemeData(fontSize: 16, arrowSize: 10);
      const b = MorphingButtonThemeData(fontSize: 16, arrowSize: 10);
      const c = MorphingButtonThemeData(fontSize: 18, arrowSize: 10);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, b.hashCode);
    });
  });

  group('MorphingButtonTheme', () {
    testWidgets('of returns empty data when no theme in tree', (tester) async {
      late MorphingButtonThemeData capturedData;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedData = MorphingButtonTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(capturedData.fontSize, isNull);
      expect(capturedData.accentColor, isNull);
    });

    testWidgets('maybeOf returns null when no theme in tree', (tester) async {
      MorphingButtonThemeData? capturedData;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedData = MorphingButtonTheme.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(capturedData, isNull);
    });

    testWidgets('of returns theme data when present', (tester) async {
      late MorphingButtonThemeData capturedData;
      await tester.pumpWidget(
        MaterialApp(
          home: MorphingButtonTheme(
            data: const MorphingButtonThemeData(fontSize: 20, arrowSize: 12),
            child: Builder(
              builder: (context) {
                capturedData = MorphingButtonTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(capturedData.fontSize, 20);
      expect(capturedData.arrowSize, 12);
    });

    testWidgets('updateShouldNotify triggers on data change', (tester) async {
      final buildCounts = <int>[];

      Widget buildTree(MorphingButtonThemeData data) {
        return MaterialApp(
          home: MorphingButtonTheme(
            data: data,
            child: _ThemeDependentWidget(
              onBuild: () => buildCounts.add(1),
            ),
          ),
        );
      }

      await tester.pumpWidget(
          buildTree(const MorphingButtonThemeData(fontSize: 14)));
      final countAfterFirst = buildCounts.length;

      // Same data — should not notify dependents
      await tester.pumpWidget(
          buildTree(const MorphingButtonThemeData(fontSize: 14)));
      final countAfterSame = buildCounts.length;

      // Different data — should notify dependents
      await tester.pumpWidget(
          buildTree(const MorphingButtonThemeData(fontSize: 18)));
      final countAfterDiff = buildCounts.length;

      // Same data should not cause extra builds beyond what pumpWidget does
      expect(countAfterSame, countAfterFirst);
      // Different data should trigger a rebuild
      expect(countAfterDiff, greaterThan(countAfterSame));
    });
  });
}

/// A widget that depends on MorphingButtonTheme and calls [onBuild]
/// only when didChangeDependencies fires (i.e., when the theme changes).
class _ThemeDependentWidget extends StatefulWidget {
  final VoidCallback onBuild;

  const _ThemeDependentWidget({required this.onBuild});

  @override
  State<_ThemeDependentWidget> createState() => _ThemeDependentWidgetState();
}

class _ThemeDependentWidgetState extends State<_ThemeDependentWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MorphingButtonTheme.of(context);
    widget.onBuild();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
