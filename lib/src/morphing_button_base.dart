export 'hover_button_base.dart';

import 'package:flutter/material.dart';
import 'hover_button_base.dart';

/// Abstract base widget for morphing buttons.
///
/// Extends [HoverButtonBase] with label, icon, and typography/layout fields
/// specific to the morphing button family.
abstract class MorphingButtonBase extends HoverButtonBase {
  final String label;
  final Widget? icon;
  final double fontSize;
  final double letterSpacing;
  final double horizontalPadding;
  final double verticalPadding;
  final double arrowSize;
  final double arrowStrokeWidth;

  const MorphingButtonBase({
    super.key,
    required this.label,
    this.icon,
    super.onTap,
    super.onLeftTap,
    super.onRightTap,
    super.accentColor,
    super.textColor,
    super.enabled,
    super.splitRatio,
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
    extends HoverButtonBaseState<T> {}
