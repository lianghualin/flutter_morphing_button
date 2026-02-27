import 'package:flutter/material.dart';

class MorphingButtonThemeData {
  final Color? accentColor;
  final Color? textColor;
  final double? fontSize;
  final double? letterSpacing;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? arrowSize;
  final double? arrowStrokeWidth;

  const MorphingButtonThemeData({
    this.accentColor,
    this.textColor,
    this.fontSize,
    this.letterSpacing,
    this.horizontalPadding,
    this.verticalPadding,
    this.arrowSize,
    this.arrowStrokeWidth,
  });

  MorphingButtonThemeData merge(MorphingButtonThemeData? other) {
    if (other == null) return this;
    return MorphingButtonThemeData(
      accentColor: other.accentColor ?? accentColor,
      textColor: other.textColor ?? textColor,
      fontSize: other.fontSize ?? fontSize,
      letterSpacing: other.letterSpacing ?? letterSpacing,
      horizontalPadding: other.horizontalPadding ?? horizontalPadding,
      verticalPadding: other.verticalPadding ?? verticalPadding,
      arrowSize: other.arrowSize ?? arrowSize,
      arrowStrokeWidth: other.arrowStrokeWidth ?? arrowStrokeWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MorphingButtonThemeData) return false;
    return accentColor == other.accentColor &&
        textColor == other.textColor &&
        fontSize == other.fontSize &&
        letterSpacing == other.letterSpacing &&
        horizontalPadding == other.horizontalPadding &&
        verticalPadding == other.verticalPadding &&
        arrowSize == other.arrowSize &&
        arrowStrokeWidth == other.arrowStrokeWidth;
  }

  @override
  int get hashCode => Object.hash(
        accentColor,
        textColor,
        fontSize,
        letterSpacing,
        horizontalPadding,
        verticalPadding,
        arrowSize,
        arrowStrokeWidth,
      );
}

class MorphingButtonTheme extends InheritedWidget {
  final MorphingButtonThemeData data;

  const MorphingButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static MorphingButtonThemeData? maybeOf(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<MorphingButtonTheme>();
    return widget?.data;
  }

  static MorphingButtonThemeData of(BuildContext context) {
    return maybeOf(context) ?? const MorphingButtonThemeData();
  }

  @override
  bool updateShouldNotify(MorphingButtonTheme oldWidget) {
    return data != oldWidget.data;
  }
}
