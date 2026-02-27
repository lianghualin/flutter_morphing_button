import 'package:flutter/material.dart';
import '../morphing_button_base.dart';
import '../morphing_arrow_painter.dart';

/// Variant 4: Underline Minimal
///
/// Typography-first, no-frills. A thin underline sweeps in from the
/// arrow's direction. Minimal and elegant.
class UnderlineMinimalButton extends MorphingButtonBase {
  final double underlineHeight;

  const UnderlineMinimalButton({
    super.key,
    required super.label,
    super.icon,
    super.onTap,
    super.onLeftTap,
    super.onRightTap,
    super.accentColor,
    super.textColor,
    super.enabled,
    super.splitRatio,
    super.fontSize,
    super.letterSpacing = 3,
    super.horizontalPadding = 40,
    super.verticalPadding = 14,
    super.arrowSize = 7,
    super.arrowStrokeWidth = 1.5,
    this.underlineHeight = 1.5,
  });

  @override
  State<UnderlineMinimalButton> createState() =>
      _UnderlineMinimalButtonState();
}

class _UnderlineMinimalButtonState
    extends MorphingButtonBaseState<UnderlineMinimalButton> {
  @override
  Widget buildButton(BuildContext context) {
    final textX = lerpValue(8, -8, ratio) * presence;
    final leftFactor = presence * (1.0 - dir * 2).clamp(0.0, 1.0);
    final rightFactor = presence * (dir * 2 - 1.0).clamp(0.0, 1.0);
    final lineFromRight = dir <= 0.5;
    final accent = widget.accentColor ?? const Color(0xFF1A1A1A);
    final labelColor = widget.textColor ?? const Color(0xFF1A1A1A);

    return Container(
      constraints: const BoxConstraints(minWidth: 200),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Underline
          Positioned(
            left: 12,
            right: 12,
            bottom: 4,
            child: Align(
              alignment: lineFromRight
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: presence,
                child: Container(
                  height: widget.underlineHeight,
                  color: accent,
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
                      padding: const EdgeInsets.only(right: 10),
                      child: CustomPaint(
                        size: const Size(22, 22),
                        painter: MorphingArrowPainter(
                          ratio: ratio,
                          presence: presence,
                          dir: dir,
                          color: accent,
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
                      fontWeight: FontWeight.w600,
                      letterSpacing: widget.letterSpacing,
                      fontFamily: 'serif',
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
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomPaint(
                        size: const Size(22, 22),
                        painter: MorphingArrowPainter(
                          ratio: ratio,
                          presence: presence,
                          dir: dir,
                          color: accent,
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
    );
  }
}
