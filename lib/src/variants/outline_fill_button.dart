import 'package:flutter/material.dart';
import '../morphing_button_base.dart';
import '../morphing_arrow_painter.dart';

/// Variant 2: Bordered Outline with Color Fill
///
/// Border-only at rest. On hover, color floods in from the arrow's direction.
/// The accent color shifts between purple (left) and teal (right).
class OutlineFillButton extends MorphingButtonBase {
  final double borderRadius;
  final double borderWidth;
  final double fillOpacity;

  const OutlineFillButton({
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
    super.letterSpacing,
    super.horizontalPadding,
    super.verticalPadding,
    super.arrowSize,
    super.arrowStrokeWidth,
    this.borderRadius = 0,
    this.borderWidth = 2,
    this.fillOpacity = 0.92,
  });

  @override
  State<OutlineFillButton> createState() => _OutlineFillButtonState();
}

class _OutlineFillButtonState
    extends MorphingButtonBaseState<OutlineFillButton> {
  @override
  Widget buildButton(BuildContext context) {
    final textX = lerpValue(8, -8, ratio) * presence;
    final leftFactor = presence * (1.0 - dir * 2).clamp(0.0, 1.0);
    final rightFactor = presence * (dir * 2 - 1.0).clamp(0.0, 1.0);

    // Accent color: use provided color, or shift purple↔teal with cursor
    final Color accent;
    if (widget.accentColor != null) {
      final hsl = HSLColor.fromColor(widget.accentColor!);
      final lightness = lerpValue(hsl.lightness - 0.05, hsl.lightness + 0.05, dir);
      accent = hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
    } else {
      accent = dir > 0.5
          ? HSLColor.fromAHSL(1, lerpValue(160, 170, dir), 0.7, 0.4).toColor()
          : HSLColor.fromAHSL(1, lerpValue(250, 260, dir), 0.6, 0.55).toColor();
    }

    final fillFromLeft = dir <= 0.5;

    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      decoration: BoxDecoration(
        border: Border.all(color: accent, width: widget.borderWidth),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Color fill wipe
            Positioned.fill(
              child: Align(
                alignment:
                    fillFromLeft ? Alignment.centerLeft : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: presence,
                  heightFactor: 1.0,
                  child: Opacity(
                    opacity: presence * widget.fillOpacity,
                    child: Container(color: accent),
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
                          size: const Size(24, 24),
                          painter: MorphingArrowPainter(
                            ratio: ratio,
                            presence: presence,
                            dir: dir,
                            color: Colors.white,
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
                        fontWeight: FontWeight.w700,
                        letterSpacing: widget.letterSpacing,
                        fontFamily: 'monospace',
                        color: presence > 0.5 ? Colors.white : (widget.textColor ?? const Color(0xFF222222)),
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
                          size: const Size(24, 24),
                          painter: MorphingArrowPainter(
                            ratio: ratio,
                            presence: presence,
                            dir: dir,
                            color: Colors.white,
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
    );
  }
}
