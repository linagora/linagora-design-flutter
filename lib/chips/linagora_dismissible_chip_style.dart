import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Tokens for [LinagoraDismissibleChip].
@immutable
class LinagoraDismissibleChipStyle {
  /// Scales with the text so a large font still fits.
  final double height;
  final double radius;
  final Color color;
  final EdgeInsetsGeometry padding;

  /// Gap between the leading widget and the label.
  final double gap;
  final TextStyle textStyle;
  final double iconSize;
  final Color iconColor;

  /// Hit box of the close button. Larger than [height] so it meets the
  /// Android 48dp tap target while the chip stays short.
  final double dismissTargetSize;

  const LinagoraDismissibleChipStyle({
    required this.height,
    required this.radius,
    required this.color,
    required this.padding,
    required this.gap,
    required this.textStyle,
    required this.iconSize,
    required this.iconColor,
    required this.dismissTargetSize,
  });

  static final LinagoraDismissibleChipStyle _material = _build(
    color: const Color(0xFFF3F6F9),
    textColor: const Color(0xE5424244),
    iconColor: const Color(0xA3424244),
  );

  static final LinagoraDismissibleChipStyle _dark = _build(
    color: const Color(0x14FFFFFF),
    textColor: Colors.white,
    iconColor: const Color(0xA3FFFFFF),
  );

  factory LinagoraDismissibleChipStyle.material() => _material;

  factory LinagoraDismissibleChipStyle.dark() => _dark;

  static LinagoraDismissibleChipStyle _build({
    required Color color,
    required Color textColor,
    required Color iconColor,
  }) {
    return LinagoraDismissibleChipStyle(
      height: 32,
      radius: 8,
      color: color,
      padding: const EdgeInsetsDirectional.only(start: 8),
      gap: 6,
      textStyle: LinagoraTextTheme.material().bodyMedium!.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: textColor,
      ),
      iconSize: 18,
      iconColor: iconColor,
      dismissTargetSize: 48,
    );
  }

  // @codescene(disable:"Excess Number of Function Arguments") mirrors every field
  LinagoraDismissibleChipStyle copyWith({
    double? height,
    double? radius,
    Color? color,
    EdgeInsetsGeometry? padding,
    double? gap,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    double? dismissTargetSize,
  }) {
    return LinagoraDismissibleChipStyle(
      height: height ?? this.height,
      radius: radius ?? this.radius,
      color: color ?? this.color,
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      dismissTargetSize: dismissTargetSize ?? this.dismissTargetSize,
    );
  }
}
