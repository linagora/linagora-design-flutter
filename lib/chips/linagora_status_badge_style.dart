import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Tokens for [LinagoraStatusBadge].
@immutable
class LinagoraStatusBadgeStyle {
  final Color color;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;

  const LinagoraStatusBadgeStyle({
    required this.color,
    required this.padding,
    required this.textStyle,
  });

  static final LinagoraStatusBadgeStyle _material = _build(
    color: const Color(0x140A84FF),
    textColor: const Color(0xFF0A84FF),
  );

  static final LinagoraStatusBadgeStyle _dark = _build(
    color: const Color(0x299BBEFA),
    textColor: const Color(0xFF9BBEFA),
  );

  factory LinagoraStatusBadgeStyle.material() => _material;

  factory LinagoraStatusBadgeStyle.dark() => _dark;

  static LinagoraStatusBadgeStyle _build({
    required Color color,
    required Color textColor,
  }) {
    return LinagoraStatusBadgeStyle(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      textStyle: LinagoraTextTheme.material().labelMedium!.copyWith(
        color: textColor,
      ),
    );
  }

  LinagoraStatusBadgeStyle copyWith({
    Color? color,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return LinagoraStatusBadgeStyle(
      color: color ?? this.color,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
