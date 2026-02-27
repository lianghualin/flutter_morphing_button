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

/// Abstract base widget for hover-aware buttons.
///
/// Provides split-tap zones: [onLeftTap] fires when the left portion is tapped,
/// [onRightTap] fires when the right portion is tapped (split at [splitRatio]).
/// [onTap] fires on any tap regardless of position.
/// [enabled] controls whether the button responds to input.
abstract class HoverButtonBase extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final Color? accentColor;
  final Color? textColor;
  final bool enabled;
  final double splitRatio;

  const HoverButtonBase({
    super.key,
    this.onTap,
    this.onLeftTap,
    this.onRightTap,
    this.accentColor,
    this.textColor,
    this.enabled = true,
    this.splitRatio = 0.5,
  });
}

/// Abstract base state for [HoverButtonBase].
///
/// Wraps the child in MouseRegion + GestureDetector + LayoutBuilder.
/// Subclasses implement [buildButton] to define their visual style.
abstract class HoverButtonBaseState<T extends HoverButtonBase> extends State<T>
    with SingleTickerProviderStateMixin, HoverTracker<T> {
  double _width = 0;
  double _tapDownX = 0;

  Widget buildButton(BuildContext context);

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _tapDownX = details.localPosition.dx;
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onTap?.call();
    if (_width > 0) {
      if (_tapDownX < _width * widget.splitRatio) {
        widget.onLeftTap?.call();
      } else {
        widget.onRightTap?.call();
      }
    }
  }

  @override
  void onHoverEnter() {
    if (!widget.enabled) return;
    super.onHoverEnter();
  }

  @override
  void onHoverUpdate(PointerEvent event, double widgetWidth) {
    if (!widget.enabled) return;
    super.onHoverUpdate(event, widgetWidth);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      onHover: (event) => onHoverUpdate(event, _width),
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTap: _handleTap,
        onPanStart: widget.enabled
            ? (details) {
                onHoverEnter();
                _updateRatioFromLocal(details.localPosition.dx);
              }
            : null,
        onPanUpdate: widget.enabled
            ? (details) {
                _updateRatioFromLocal(details.localPosition.dx);
              }
            : null,
        onPanEnd: widget.enabled ? (_) => onHoverExit() : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
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
