import 'package:flutter/material.dart';
import 'nav_toggle_base.dart';
import 'nav_toggle_painters.dart';

/// A concrete navigation toggle button with 3-mode rendering.
///
/// - **Sidebar**: Full-width item with icon + label. Label fades when narrow.
/// - **IconRail**: Icon-only with tooltip and selection highlight.
/// - **TabBar**: Icon + optional label with bottom tab indicator.
class NavToggleButton extends NavToggleBase {
  const NavToggleButton({
    super.key,
    required super.currentWidth,
    required super.mode,
    required super.icon,
    super.isSelected,
    super.label,
    super.iconSize,
    super.iconMorphProgress,
    super.onTap,
    super.accentColor,
    super.textColor,
    super.enabled,
  });

  @override
  State<NavToggleButton> createState() => _NavToggleButtonState();
}

class _NavToggleButtonState extends NavToggleBaseState<NavToggleButton> {
  Widget _buildIcon(Color color) {
    if (widget.iconMorphProgress != null) {
      return CustomPaint(
        size: Size.square(widget.iconSize),
        painter: HamburgerMorphPainter(
          morphProgress: widget.iconMorphProgress!,
          color: color,
          strokeWidth: 2.0,
        ),
      );
    }
    return Icon(widget.icon, size: widget.iconSize, color: color);
  }

  @override
  Widget buildButton(BuildContext context) {
    switch (widget.mode) {
      case NavToggleMode.sidebar:
        return _buildSidebar(context);
      case NavToggleMode.iconRail:
        return _buildIconRail(context);
      case NavToggleMode.tabBar:
        return _buildTabBar(context);
    }
  }

  Widget _buildSidebar(BuildContext context) {
    final accent = widget.accentColor ?? Theme.of(context).colorScheme.primary;
    final textCol = widget.textColor ?? Theme.of(context).colorScheme.onSurface;
    final showLabel = !isSingleZone && widget.label != null;
    final labelOpacity =
        showLabel ? ((widget.currentWidth - singleZoneThreshold) / 40).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: widget.currentWidth,
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
          // Selected indicator
          if (widget.isSelected)
            Positioned(
              left: 0,
              top: 8,
              bottom: 8,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
          // Right-edge indicator (visible when selected or hovered)
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: Center(
              child: CustomPaint(
                size: const Size(4, 16),
                painter: SidebarEdgeIndicatorPainter(
                  presence: widget.isSelected ? 1.0 : presence,
                  color: accent,
                ),
              ),
            ),
          ),
          // Icon + label row
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIcon(widget.isSelected ? accent : textCol),
                  if (showLabel) ...[
                    const SizedBox(width: 12),
                    Flexible(
                      child: Opacity(
                        opacity: labelOpacity,
                        child: Text(
                          widget.label!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: widget.isSelected ? accent : textCol,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconRail(BuildContext context) {
    final accent = widget.accentColor ?? Theme.of(context).colorScheme.primary;
    final textCol = widget.textColor ?? Theme.of(context).colorScheme.onSurface;

    final bgAlpha = widget.isSelected ? 0.12 : presence * 0.08;
    final iconWidget = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: bgAlpha),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: _buildIcon(widget.isSelected ? accent : textCol),
      ),
    );

    if (widget.label != null) {
      return Tooltip(message: widget.label!, child: iconWidget);
    }
    return iconWidget;
  }

  Widget _buildTabBar(BuildContext context) {
    final accent = widget.accentColor ?? Theme.of(context).colorScheme.primary;
    final textCol = widget.textColor ?? Theme.of(context).colorScheme.onSurface;
    final showLabel = widget.label != null;
    final indicatorPresence = widget.isSelected ? 1.0 : presence;

    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Icon + label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(widget.isSelected ? accent : textCol),
                if (showLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: widget.isSelected ? accent : textCol,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Bottom indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 3),
              painter: TabIndicatorPainter(
                presence: indicatorPresence,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
