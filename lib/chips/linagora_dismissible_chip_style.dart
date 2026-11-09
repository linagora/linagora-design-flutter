import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Tokens for [LinagoraDismissibleChip].
@immutable
class LinagoraDismissibleChipStyle {
  /// Scales with the text so a large font still fits.
  final double height;
  final double radius;
  final Color color;
  final Color borderColor;
  final double borderWidth;
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
    required this.borderColor,
    required this.borderWidth,
    required this.padding,
    required this.gap,
    required this.textStyle,
    required this.iconSize,
    required this.iconColor,
    required this.dismissTargetSize,
  });

  // Fill sampled from Twake Mail stand-alone Figma (#F5F6FA); soft square, no stroke.
  static final LinagoraDismissibleChipStyle _material = _build(
    color: const Color(0xFFF5F6FA),
    borderColor: const Color(0x00000000),
    textColor: const Color(0xE5424244),
    iconColor: const Color(0xA3424244),
  );

  static final LinagoraDismissibleChipStyle _dark = _build(
    color: const Color(0x14FFFFFF),
    borderColor: const Color(0x00000000),
    textColor: Colors.white,
    iconColor: const Color(0xA3FFFFFF),
  );

  factory LinagoraDismissibleChipStyle.material() => _material;

  factory LinagoraDismissibleChipStyle.dark() => _dark;

  static LinagoraDismissibleChipStyle _build({
    required Color color,
    required Color borderColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return LinagoraDismissibleChipStyle(
      height: 32,
      // Soft square (Figma Viewing chip); not a stadium/pill.
      radius: 6,
      color: color,
      borderColor: borderColor,
      borderWidth: 0,
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
    Color? borderColor,
    double? borderWidth,
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
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      dismissTargetSize: dismissTargetSize ?? this.dismissTargetSize,
    );
  }
}
