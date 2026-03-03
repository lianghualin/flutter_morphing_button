import 'package:flutter/material.dart';
import 'hover_button_base.dart';
import 'morphing_arrow_painter.dart';
import 'nav/nav_toggle_painters.dart';

/// The visual state of a [ModeToggleButton].
///
/// - [split]: Two hover zones with directional arrows; shows hamburger icon + label.
/// - [collapsedRight]: Single zone at full width; morphed icon + label.
/// - [collapsedLeft]: Single zone at icon-only width; morphed icon, label hidden.
enum ModeToggleState { split, collapsedRight, collapsedLeft }

/// A general-purpose split/collapse toggle button.
///
/// In [ModeToggleState.split] mode, the button shows two hover zones with
/// directional arrows (left and right). Tapping either zone triggers
/// [onLeftTap] or [onRightTap].
///
/// In collapsed modes, the button becomes a single-zone button:
/// - [ModeToggleState.collapsedRight]: Keeps full width, shows morphed icon + label.
/// - [ModeToggleState.collapsedLeft]: Shrinks to icon-only width, hides label.
///
/// Tapping the collapsed button fires [onTap], which the parent typically
/// uses to return to [ModeToggleState.split].
class ModeToggleButton extends HoverButtonBase {
  final ModeToggleState state;
  final double expandedWidth;
  final double collapsedWidth;
  final Widget? icon;
  final String? label;
  final double iconSize;
  final double arrowSize;
  final double strokeWidth;
  final Duration animationDuration;

  const ModeToggleButton({
    super.key,
    this.state = ModeToggleState.split,
    this.expandedWidth = 220,
    this.collapsedWidth = 52,
    this.icon,
    this.label,
    this.iconSize = 24,
    this.arrowSize = 10,
    this.strokeWidth = 2.0,
    this.animationDuration = const Duration(milliseconds: 300),
    super.onTap,
    super.onLeftTap,
    super.onRightTap,
    super.accentColor,
    super.textColor,
    super.enabled,
    super.splitRatio,
  });

  @override
  State<ModeToggleButton> createState() => _ModeToggleButtonState();
}

class _ModeToggleButtonState
    extends HoverButtonBaseState<ModeToggleButton> {
  @override
  Widget buildButton(BuildContext context) {
    final targetMorph =
        widget.state == ModeToggleState.split ? 0.0 : 1.0;
    final targetWidth = widget.state == ModeToggleState.collapsedLeft
        ? widget.collapsedWidth
        : widget.expandedWidth;

    return TweenAnimationBuilder<double>(
      tween: Tween(end: targetMorph),
      duration: widget.animationDuration,
      builder: (context, morphProgress, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween(end: targetWidth),
          duration: widget.animationDuration,
          builder: (context, currentWidth, _) {
            return _buildContent(context, morphProgress, currentWidth);
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    double morphProgress,
    double currentWidth,
  ) {
    final accent = widget.accentColor ?? const Color(0xFF6366F1);
    final textCol =
        widget.textColor ?? Theme.of(context).colorScheme.onSurface;
    final isSplit = widget.state == ModeToggleState.split;
    final hasBranding = widget.icon != null || widget.label != null;

    // Arrows only visible in split mode
    final arrowPresence = isSplit ? presence : 0.0;
    final leftFactor =
        arrowPresence * (1.0 - dir * 2).clamp(0.0, 1.0);
    final rightFactor =
        arrowPresence * (dir * 2 - 1.0).clamp(0.0, 1.0);

    // Label fades out as width shrinks toward collapsedWidth
    final labelOpacity =
        ((currentWidth - widget.collapsedWidth - 20) / 40).clamp(0.0, 1.0);

    return SizedBox(
      width: currentWidth,
      height: 48,
      child: Stack(
        children: [
          // Hover background
          Positioned.fill(
            child: Opacity(
              opacity: presence * 0.08,
              child: Container(
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Content row — Positioned.fill + ClipRect so content is
          // clipped during width-shrink animation without layout overflow.
          Positioned.fill(
            child: ClipRect(
              child: OverflowBox(
                maxWidth: widget.expandedWidth,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize:
                        hasBranding ? MainAxisSize.max : MainAxisSize.min,
                    children: [
                      // Left arrow
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: leftFactor,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CustomPaint(
                              size: Size(widget.arrowSize * 2.8,
                                  widget.arrowSize * 2.8),
                              painter: MorphingArrowPainter(
                                ratio: ratio,
                                presence: presence,
                                dir: dir,
                                color: accent,
                                strokeWidth: widget.strokeWidth,
                                arrowSize: widget.arrowSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Branding icon
                      if (widget.icon != null)
                        IgnorePointer(child: widget.icon!),
                      // Label
                      if (widget.label != null && labelOpacity > 0.01)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Opacity(
                              opacity: labelOpacity,
                              child: Text(
                                widget.label!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textCol,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Spacer pushes hamburger right when branding is present
                      if (hasBranding) const Spacer(),
                      // Hamburger / morph icon (fades when branding replaces it)
                      if (!hasBranding || labelOpacity > 0.01)
                        Opacity(
                          opacity: hasBranding ? labelOpacity : 1.0,
                          child: CustomPaint(
                            size: Size.square(widget.iconSize),
                            painter: HamburgerMorphPainter(
                              morphProgress: morphProgress,
                              color: textCol,
                              strokeWidth: widget.strokeWidth,
                            ),
                          ),
                        ),
                      // Right arrow
                      ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: rightFactor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CustomPaint(
                              size: Size(widget.arrowSize * 2.8,
                                  widget.arrowSize * 2.8),
                              painter: MorphingArrowPainter(
                                ratio: ratio,
                                presence: presence,
                                dir: dir,
                                color: accent,
                                strokeWidth: widget.strokeWidth,
                                arrowSize: widget.arrowSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        // Collapsed branding overlay — fades in as width shrinks
        if (hasBranding && labelOpacity < 0.99)
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: (1.0 - labelOpacity).clamp(0.0, 1.0),
                child: IgnorePointer(
                  child: widget.icon ?? _buildMonogram(accent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonogram(Color accent) {
    final char = widget.label?.isNotEmpty == true
        ? widget.label![0].toUpperCase()
        : '?';
    return Container(
      width: widget.iconSize,
      height: widget.iconSize,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }
}
