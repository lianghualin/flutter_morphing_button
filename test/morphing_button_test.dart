import 'package:flutter_test/flutter_test.dart';
import 'package:morphing_button/morphing_button.dart';

void main() {
  test('MorphingButtonBase subclasses can be instantiated', () {
    const glass = GlassPillButton(label: 'Test');
    const outline = OutlineFillButton(label: 'Test');
    const soft = SoftShadowButton(label: 'Test');
    const underline = UnderlineMinimalButton(label: 'Test');

    expect(glass.label, 'Test');
    expect(outline.label, 'Test');
    expect(soft.label, 'Test');
    expect(underline.label, 'Test');
  });

  test('Configurable parameters use correct defaults', () {
    const glass = GlassPillButton(label: 'G');
    expect(glass.fontSize, 13);
    expect(glass.letterSpacing, 2.5);
    expect(glass.horizontalPadding, 52);
    expect(glass.arrowSize, 10);
    expect(glass.arrowStrokeWidth, 2.0);

    const outline = OutlineFillButton(label: 'O');
    expect(outline.borderRadius, 0);
    expect(outline.borderWidth, 2);
    expect(outline.fillOpacity, 0.92);
    expect(outline.fontSize, 13);

    const soft = SoftShadowButton(label: 'S');
    expect(soft.shadowBlur, 28);
    expect(soft.elevation, 2);
    expect(soft.fontSize, 14);

    const underline = UnderlineMinimalButton(label: 'U');
    expect(underline.underlineHeight, 1.5);
    expect(underline.letterSpacing, 3);
    expect(underline.arrowSize, 7);
  });

  test('Configurable parameters accept custom values', () {
    const outline = OutlineFillButton(
      label: 'Custom',
      borderRadius: 12,
      borderWidth: 3,
      fillOpacity: 0.8,
      fontSize: 18,
      letterSpacing: 4,
      horizontalPadding: 60,
      verticalPadding: 20,
      arrowSize: 12,
      arrowStrokeWidth: 3.0,
    );
    expect(outline.borderRadius, 12);
    expect(outline.borderWidth, 3);
    expect(outline.fillOpacity, 0.8);
    expect(outline.fontSize, 18);
    expect(outline.arrowSize, 12);
  });

  test('lerpValue interpolates correctly', () {
    expect(lerpValue(0, 10, 0.0), 0.0);
    expect(lerpValue(0, 10, 0.5), 5.0);
    expect(lerpValue(0, 10, 1.0), 10.0);
  });

  test('dirFromRatio returns correct zones', () {
    expect(dirFromRatio(0.0), 0.0);
    expect(dirFromRatio(0.34), 0.0);
    expect(dirFromRatio(0.5), closeTo(0.5, 0.01));
    expect(dirFromRatio(0.66), 1.0);
    expect(dirFromRatio(1.0), 1.0);
  });
}
