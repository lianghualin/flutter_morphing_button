import 'package:flutter/material.dart';
import 'morphing_button_base.dart';

/// CustomPainter that draws the morphing directional arrow.
///
/// The arrow transitions smoothly:
/// - dir <= 0.5: left-pointing arrow that collapses toward center
/// - dir > 0.5: expands from center into right-pointing arrow
///
/// [ratio] controls horizontal position (0.0 = left, 1.0 = right).
/// [presence] controls opacity/visibility (0.0 = hidden, 1.0 = fully shown).
/// [dir] is derived from ratio via [dirFromRatio].
class MorphingArrowPainter extends CustomPainter {
  final double ratio;
  final double presence;
  final double dir;
  final Color color;
  final double strokeWidth;
  final double arrowSize;

  MorphingArrowPainter({
    required this.ratio,
    required this.presence,
    required this.dir,
    this.color = const Color(0xFF6366F1),
    this.strokeWidth = 2.0,
    this.arrowSize = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final arrowOpacity = presence * (dir < 0.25 || dir > 0.75 ? 1.0 : 0.15);
    if (arrowOpacity < 0.01) return;

    final paint = Paint()
      ..color = color.withValues(alpha: arrowOpacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = arrowSize;
    final chevronSize = s * 0.55;

    if (dir <= 0.5) {
      // Left arrow morphing: full arrow at dir=0, collapses at dir=0.5
      final t = dir * 2; // 0.0 → 1.0
      final lineStartX = lerpValue(s, 0, t);
      final lineEndX = lerpValue(-s, 0, t);
      final chevronX = lerpValue(-chevronSize, 0, t);
      final chevronTipX = lerpValue(-s, 0, t);
      final chevronY = lerpValue(chevronSize, 0, t);

      // Main line
      canvas.drawLine(
        Offset(cx + lineStartX, cy),
        Offset(cx + lineEndX, cy),
        paint,
      );
      // Upper chevron
      canvas.drawLine(
        Offset(cx + chevronX, cy - chevronY),
        Offset(cx + chevronTipX, cy),
        paint,
      );
      // Lower chevron
      canvas.drawLine(
        Offset(cx + chevronX, cy + chevronY),
        Offset(cx + chevronTipX, cy),
        paint,
      );
    } else {
      // Right arrow morphing: expands from center at dir=0.5 to full at dir=1.0
      final t = (dir - 0.5) * 2; // 0.0 → 1.0
      final lineStartX = lerpValue(0, -s, t);
      final lineEndX = lerpValue(0, s, t);
      final chevronX = lerpValue(0, chevronSize, t);
      final chevronTipX = lerpValue(0, s, t);
      final chevronY = lerpValue(0, chevronSize, t);

      // Main line
      canvas.drawLine(
        Offset(cx + lineStartX, cy),
        Offset(cx + lineEndX, cy),
        paint,
      );
      // Upper chevron
      canvas.drawLine(
        Offset(cx + chevronX, cy - chevronY),
        Offset(cx + chevronTipX, cy),
        paint,
      );
      // Lower chevron
      canvas.drawLine(
        Offset(cx + chevronX, cy + chevronY),
        Offset(cx + chevronTipX, cy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(MorphingArrowPainter oldDelegate) {
    return oldDelegate.ratio != ratio ||
        oldDelegate.presence != presence ||
        oldDelegate.dir != dir ||
        oldDelegate.color != color;
  }
}
