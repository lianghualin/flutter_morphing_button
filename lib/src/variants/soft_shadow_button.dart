import 'package:flutter/material.dart';
import '../morphing_button_base.dart';
import '../morphing_arrow_painter.dart';

/// Variant 3: Soft Shadow Rounded
///
/// Clean white card that lifts on hover. A colored shadow shifts direction
/// and hue with the cursor. A gradient bar appears at the bottom.
class SoftShadowButton extends MorphingButtonBase {
  final double shadowBlur;
  final double elevation;

  const SoftShadowButton({
    super.key,
    required super.label,
    super.onTap,
    super.onLeftTap,
    super.onRightTap,
    super.accentColor,
    super.textColor,
    super.fontSize = 14,
    super.letterSpacing = 1.5,
    super.horizontalPadding = 52,
    super.verticalPadding = 18,
    super.arrowSize = 9,
    super.arrowStrokeWidth = 2.0,
    this.shadowBlur = 28,
    this.elevation = 2,
  });

  @override
  State<SoftShadowButton> createState() => _SoftShadowButtonState();
}

class _SoftShadowButtonState extends MorphingButtonBaseState<SoftShadowButton> {
  @override
  Widget buildButton(BuildContext context) {
    final textX = lerpValue(12, -12, ratio) * presence;
    final leftFactor = presence * (1.0 - dir * 2).clamp(0.0, 1.0);
    final rightFactor = presence * (dir * 2 - 1.0).clamp(0.0, 1.0);
    final shadowX = lerpValue(-8, 8, ratio) * presence;
    // Hue: sweep ±30 around accent hue, or full spectrum when no accent
    final double hue;
    if (widget.accentColor != null) {
      final baseHue = HSLColor.fromColor(widget.accentColor!).hue;
      hue = lerpValue(baseHue - 30, baseHue + 30, ratio) % 360;
    } else {
      hue = lerpValue(20, 350, ratio);
    }
    final labelColor = widget.textColor ?? const Color(0xFF333333);

    final shadowColor =
        HSLColor.fromAHSL(0.25, hue, 0.6, 0.6).toColor();
    final barColor1 = HSLColor.fromAHSL(1, hue, 0.7, 0.65).toColor();
    final barColor2 = HSLColor.fromAHSL(1, (hue + 40) % 360, 0.7, 0.65).toColor();
    final arrowColor = HSLColor.fromAHSL(1, hue, 0.55, 0.5).toColor();

    return Transform.translate(
      offset: Offset(0, hovering ? -widget.elevation : 0),
      child: Container(
        constraints: const BoxConstraints(minWidth: 220),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (hovering)
              BoxShadow(
                color: shadowColor,
                blurRadius: widget.shadowBlur,
                offset: Offset(shadowX, 6),
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: hovering ? 4 : 12,
              offset: Offset(0, hovering ? 1 : 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bottom gradient bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: presence,
                  child: Transform.scale(
                    scaleX: 0.3 + presence * 0.7,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [barColor1, barColor2],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding,
                  vertical: widget.verticalPadding,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Left arrow slot
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerRight,
                        widthFactor: leftFactor,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: CustomPaint(
                            size: const Size(26, 26),
                            painter: MorphingArrowPainter(
                              ratio: ratio,
                              presence: presence,
                              dir: dir,
                              color: arrowColor,
                              strokeWidth: widget.arrowStrokeWidth,
                              arrowSize: widget.arrowSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Label
                    Transform.translate(
                      offset: Offset(textX, 0),
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w500,
                          letterSpacing: widget.letterSpacing,
                          color: labelColor,
                        ),
                      ),
                    ),
                    // Right arrow slot
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: rightFactor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: CustomPaint(
                            size: const Size(26, 26),
                            painter: MorphingArrowPainter(
                              ratio: ratio,
                              presence: presence,
                              dir: dir,
                              color: arrowColor,
                              strokeWidth: widget.arrowStrokeWidth,
                              arrowSize: widget.arrowSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
