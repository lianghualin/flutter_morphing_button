import 'dart:ui';
import 'package:flutter/material.dart';
import '../morphing_button_base.dart';
import '../morphing_arrow_painter.dart';

/// Variant 1: Glassmorphism Pill
///
/// Frosted glass with indigo glow tracking.
/// Features backdrop blur, radial gradient glow that follows the cursor,
/// and subtle scale on hover.
class GlassPillButton extends MorphingButtonBase {
  const GlassPillButton({
    super.key,
    required super.label,
    super.onTap,
    super.onLeftTap,
    super.onRightTap,
    super.accentColor,
    super.textColor,
    super.fontSize = 13,
    super.letterSpacing = 2.5,
    super.horizontalPadding = 52,
    super.verticalPadding = 16,
    super.arrowSize = 10,
    super.arrowStrokeWidth = 2.0,
  });

  @override
  State<GlassPillButton> createState() => _GlassPillButtonState();
}

class _GlassPillButtonState extends MorphingButtonBaseState<GlassPillButton> {
  @override
  Widget buildButton(BuildContext context) {
    final accent = widget.accentColor ?? const Color(0xFF6366F1);
    final labelColor = widget.textColor ?? const Color(0xFF1A1A2E);
    final textX = lerpValue(10, -10, ratio) * presence;
    final leftFactor = presence * (1.0 - dir * 2).clamp(0.0, 1.0);
    final rightFactor = presence * (dir * 2 - 1.0).clamp(0.0, 1.0);

    return Transform.scale(
      scaleX: 1 + 0.025 * presence,
      child: Container(
        constraints: const BoxConstraints(minWidth: 220),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: hovering ? 0.08 : 0.04),
              blurRadius: hovering ? 32 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
                vertical: widget.verticalPadding,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow that follows cursor
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment:
                          Alignment(lerpValue(-1, 1, ratio), 0),
                      child: Opacity(
                        opacity: presence,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                accent
                                    .withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.7],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // [Left arrow] [Label] [Right arrow]
                  Row(
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
                              size: const Size(28, 28),
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
                              size: const Size(28, 28),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
