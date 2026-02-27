import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphing_button/morphing_button.dart';

class _TestHoverButton extends HoverButtonBase {
  const _TestHoverButton({
    super.onTap,
    super.onLeftTap,
    super.onRightTap,
    super.enabled,
    super.splitRatio,
  });

  @override
  State<_TestHoverButton> createState() => _TestHoverButtonState();
}

class _TestHoverButtonState extends HoverButtonBaseState<_TestHoverButton> {
  @override
  Widget buildButton(BuildContext context) {
    return const SizedBox(width: 200, height: 48);
  }
}

void main() {
  test('lerpValue interpolates correctly', () {
    expect(lerpValue(0, 10, 0.0), 0.0);
    expect(lerpValue(0, 10, 0.5), 5.0);
    expect(lerpValue(0, 10, 1.0), 10.0);
    expect(lerpValue(-5, 5, 0.5), 0.0);
  });

  test('dirFromRatio returns correct zones', () {
    expect(dirFromRatio(0.0), 0.0);
    expect(dirFromRatio(0.34), 0.0);
    expect(dirFromRatio(0.35), 0.0);
    expect(dirFromRatio(0.5), closeTo(0.5, 0.01));
    expect(dirFromRatio(0.65), closeTo(1.0, 0.01));
    expect(dirFromRatio(0.66), 1.0);
    expect(dirFromRatio(1.0), 1.0);
  });

  testWidgets('disabled button suppresses taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: _TestHoverButton(
              enabled: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(_TestHoverButton));
    await tester.pump();
    expect(tapped, false);
  });

  testWidgets('enabled button fires taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: _TestHoverButton(
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(_TestHoverButton));
    await tester.pump();
    expect(tapped, true);
  });

  testWidgets('splitRatio routes left/right taps correctly', (tester) async {
    var leftTaps = 0;
    var rightTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: _TestHoverButton(
              splitRatio: 0.3,
              onLeftTap: () => leftTaps++,
              onRightTap: () => rightTaps++,
            ),
          ),
        ),
      ),
    );

    // Pump twice: first renders, second executes post-frame callback to set _width
    await tester.pump();
    await tester.pump();

    // Get the widget's position
    final finder = find.byType(_TestHoverButton);
    final topLeft = tester.getTopLeft(finder);

    // Tap in the left zone (x=20 of a 200px widget, < 200*0.3=60)
    await tester.tapAt(topLeft + const Offset(20, 24));
    await tester.pump();
    expect(leftTaps, 1);
    expect(rightTaps, 0);

    // Tap in the right zone (x=150 of a 200px widget, > 200*0.3=60)
    await tester.tapAt(topLeft + const Offset(150, 24));
    await tester.pump();
    expect(leftTaps, 1);
    expect(rightTaps, 1);
  });
}
