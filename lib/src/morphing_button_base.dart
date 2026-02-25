import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

double lerpValue(double a, double b, double t) {
  return a + (b - a) * t;
}

double dirFromRatio(double r) {
  if (r < 0.35) return 0.0;
  if (r > 0.65) return 1.0;
  return (r - 0.35) / 0.3;
}

/// Mixin that provides hover-tracking with smooth animation.
///
/// Tracks cursor X position as a ratio (0.0–1.0) across the widget,
/// and a presence value (0.0–1.0) for hover enter/exit.
/// Both values are interpolated smoothly each frame via a Ticker.
mixin HoverTracker<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late final Ticker _ticker;

  double _rawRatio = 0.5;
  double _animatedRatio = 0.5;
  double _animatedPresence = 0.0;
  bool _hovering = false;

  double get ratio => _animatedRatio;
  double get presence => _animatedPresence;
  double get dir => dirFromRatio(_animatedRatio);
  bool get hovering => _hovering;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final targetRatio = _hovering ? _rawRatio : 0.5;
    final targetPresence = _hovering ? 1.0 : 0.0;

    final newRatio = lerpValue(_animatedRatio, targetRatio, 0.045);
    final newPresence = lerpValue(_animatedPresence, targetPresence, 0.04);

    if ((newRatio - _animatedRatio).abs() > 0.0001 ||
        (newPresence - _animatedPresence).abs() > 0.0001) {
      setState(() {
        _animatedRatio = newRatio;
        _animatedPresence = newPresence;
      });
    }
  }

  void onHoverUpdate(PointerEvent event, double widgetWidth) {
    if (widgetWidth > 0) {
      _rawRatio = (event.localPosition.dx / widgetWidth).clamp(0.0, 1.0);
    }
  }

  void onHoverEnter() {
    _hovering = true;
  }

  void onHoverExit() {
    _hovering = false;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

/// Abstract base widget for morphing buttons.
abstract class MorphingButtonBase extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final double fontSize;
  final double letterSpacing;
  final double horizontalPadding;
  final double verticalPadding;
  final double arrowSize;
  final double arrowStrokeWidth;

  const MorphingButtonBase({
    super.key,
    required this.label,
    this.onTap,
    this.fontSize = 13,
    this.letterSpacing = 2,
    this.horizontalPadding = 48,
    this.verticalPadding = 16,
    this.arrowSize = 8,
    this.arrowStrokeWidth = 2.5,
  });
}

/// Abstract base state for morphing buttons.
/// Subclasses implement [buildButton] to define their visual style.
abstract class MorphingButtonBaseState<T extends MorphingButtonBase>
    extends State<T> with SingleTickerProviderStateMixin, HoverTracker<T> {
  double _width = 0;

  Widget buildButton(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      onHover: (event) => onHoverUpdate(event, _width),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        // Support touch: track horizontal drag across the button
        onPanStart: (details) {
          onHoverEnter();
          _updateRatioFromLocal(details.localPosition.dx);
        },
        onPanUpdate: (details) {
          _updateRatioFromLocal(details.localPosition.dx);
        },
        onPanEnd: (_) => onHoverExit(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // We need to measure after layout; use a post-frame callback
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null && box.hasSize) {
                _width = box.size.width;
              }
            });
            return buildButton(context);
          },
        ),
      ),
    );
  }

  void _updateRatioFromLocal(double dx) {
    if (_width > 0) {
      _rawRatio = (dx / _width).clamp(0.0, 1.0);
    }
  }
}
