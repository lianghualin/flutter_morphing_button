import 'package:flutter/material.dart';
import '../hover_button_base.dart';

/// Display mode for navigation toggle buttons.
enum NavToggleMode { sidebar, iconRail, tabBar }

/// Abstract base widget for navigation toggle buttons.
///
/// Extends [HoverButtonBase] with navigation-specific fields:
/// [currentWidth] is driven by the scaffold/layout, [mode] determines rendering,
/// [isSelected] highlights the active item.
abstract class NavToggleBase extends HoverButtonBase {
  final double currentWidth;
  final NavToggleMode mode;
  final bool isSelected;
  final IconData icon;
  final String? label;
  final double iconSize;
  final double? iconMorphProgress;

  const NavToggleBase({
    super.key,
    required this.currentWidth,
    required this.mode,
    required this.icon,
    this.isSelected = false,
    this.label,
    this.iconSize = 24,
    this.iconMorphProgress,
    super.onTap,
    super.onLeftTap,
    super.onRightTap,
    super.accentColor,
    super.textColor,
    super.enabled,
    super.splitRatio,
  });
}

/// Abstract base state for [NavToggleBase] widgets.
abstract class NavToggleBaseState<T extends NavToggleBase>
    extends HoverButtonBaseState<T> {
  /// Width threshold below which label is hidden and single-zone tap applies.
  double get singleZoneThreshold => 121.0;

  /// Whether the button is too narrow to show a label.
  bool get isSingleZone => widget.currentWidth < singleZoneThreshold;
}
