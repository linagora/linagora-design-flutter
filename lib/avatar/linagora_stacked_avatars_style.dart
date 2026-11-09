import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Tokens for [LinagoraStackedAvatars].
@immutable
class LinagoraStackedAvatarsStyle {
  final double size;

  /// How much each avatar covers the previous one.
  final double overlap;

  /// Matches the surface behind the avatars so each one looks cut out.
  final Color ringColor;
  final double ringWidth;
  final Color overflowColor;
  final TextStyle overflowTextStyle;

  const LinagoraStackedAvatarsStyle({
    required this.size,
    required this.overlap,
    required this.ringColor,
    required this.ringWidth,
    required this.overflowColor,
    required this.overflowTextStyle,
  }) : assert(overlap >= 0 && overlap < size, 'overlap must be in [0, size)');

  static final LinagoraStackedAvatarsStyle _material = _build(
    ringColor: Colors.white,
    overflowColor: const Color(0xFFF3F6F9),
    overflowTextColor: const Color(0xE5424244),
  );

  static final LinagoraStackedAvatarsStyle _dark = _build(
    ringColor: const Color(0xFF3F4249),
    overflowColor: const Color(0xFF4D5056),
    overflowTextColor: Colors.white,
  );

  factory LinagoraStackedAvatarsStyle.material() => _material;

  factory LinagoraStackedAvatarsStyle.dark() => _dark;

  static LinagoraStackedAvatarsStyle _build({
    required Color ringColor,
    required Color overflowColor,
    required Color overflowTextColor,
  }) {
    return LinagoraStackedAvatarsStyle(
      size: 32,
      overlap: 4,
      ringColor: ringColor,
      ringWidth: 2,
      overflowColor: overflowColor,
      overflowTextStyle: LinagoraTextTheme.material().labelSmall!.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: overflowTextColor,
      ),
    );
  }

  // @codescene(disable:"Excess Number of Function Arguments") mirrors every field
  LinagoraStackedAvatarsStyle copyWith({
    double? size,
    double? overlap,
    Color? ringColor,
    double? ringWidth,
    Color? overflowColor,
    TextStyle? overflowTextStyle,
  }) {
    return LinagoraStackedAvatarsStyle(
      size: size ?? this.size,
      overlap: overlap ?? this.overlap,
      ringColor: ringColor ?? this.ringColor,
      ringWidth: ringWidth ?? this.ringWidth,
      overflowColor: overflowColor ?? this.overflowColor,
      overflowTextStyle: overflowTextStyle ?? this.overflowTextStyle,
    );
  }
}
