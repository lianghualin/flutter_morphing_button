import 'package:flutter/material.dart';

/// Paints a bottom tab indicator line that scales by [presence].
class TabIndicatorPainter extends CustomPainter {
  final double presence;
  final Color color;
  final double height;

  TabIndicatorPainter({
    required this.presence,
    required this.color,
    this.height = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (presence < 0.01) return;
    final paint = Paint()..color = color;
    final width = size.width * presence;
    final left = (size.width - width) / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - height, width, height),
        Radius.circular(height / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(TabIndicatorPainter oldDelegate) =>
      oldDelegate.presence != presence || oldDelegate.color != color;
}

/// Morphs between a hamburger menu icon and an expand icon.
///
/// [morphProgress] 0.0 = hamburger, 1.0 = expanded/arrow.
class HamburgerMorphPainter extends CustomPainter {
  final double morphProgress;
  final Color color;
  final double strokeWidth;

  HamburgerMorphPainter({
    required this.morphProgress,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final halfW = size.width * 0.3;
    final spacing = size.height * 0.2;

    // Top line: rotates toward arrow upper arm
    final topY = cy - spacing;
    final topRotation = morphProgress * 0.7; // radians
    canvas.save();
    canvas.translate(cx, topY);
    canvas.rotate(topRotation);
    canvas.drawLine(Offset(-halfW, 0), Offset(halfW, 0), paint);
    canvas.restore();

    // Middle line: stays horizontal, shortens
    final midHalfW = halfW * (1.0 - morphProgress * 0.4);
    canvas.drawLine(
      Offset(cx - midHalfW, cy),
      Offset(cx + midHalfW, cy),
      paint,
    );

    // Bottom line: rotates toward arrow lower arm
    final botY = cy + spacing;
    final botRotation = -morphProgress * 0.7;
    canvas.save();
    canvas.translate(cx, botY);
    canvas.rotate(botRotation);
    canvas.drawLine(Offset(-halfW, 0), Offset(halfW, 0), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HamburgerMorphPainter oldDelegate) =>
      oldDelegate.morphProgress != morphProgress ||
      oldDelegate.color != color;
}
