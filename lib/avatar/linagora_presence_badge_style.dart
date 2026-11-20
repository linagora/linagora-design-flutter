import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Tokens for [LinagoraPresenceBadge].
@immutable
class LinagoraPresenceBadgeStyle {
  final Color onlineColor;
  final Color awayColor;

  /// Matches the surface behind the avatar so the dot looks cut out.
  final Color ringColor;
  final double ringWidth;
  final double dotSize;
  final double largeDotSize;

  /// Avatars wider than this get [largeDotSize].
  final double largeAvatarThreshold;
  final Duration colorDuration;

  const LinagoraPresenceBadgeStyle({
    required this.onlineColor,
    required this.awayColor,
    required this.ringColor,
    required this.ringWidth,
    required this.dotSize,
    required this.largeDotSize,
    required this.largeAvatarThreshold,
    required this.colorDuration,
  });

  static final LinagoraPresenceBadgeStyle _material = _build(
    ringColor: Colors.white,
  );

  static final LinagoraPresenceBadgeStyle _dark = _build(
    ringColor: const Color(0xFF3F4249),
  );

  factory LinagoraPresenceBadgeStyle.material() => _material;

  factory LinagoraPresenceBadgeStyle.dark() => _dark;

  static LinagoraPresenceBadgeStyle _build({required Color ringColor}) {
    final colors = LinagoraSysColors.material();
    return LinagoraPresenceBadgeStyle(
      onlineColor: colors.success,
      awayColor: colors.warning,
      ringColor: ringColor,
      ringWidth: 2,
      dotSize: 10,
      largeDotSize: 12,
      largeAvatarThreshold: 40,
      colorDuration: const Duration(milliseconds: 150),
    );
  }

  double dotSizeFor(double avatarSize) =>
      avatarSize > largeAvatarThreshold ? largeDotSize : dotSize;

  // @codescene(disable:"Excess Number of Function Arguments") mirrors every field
  LinagoraPresenceBadgeStyle copyWith({
    Color? onlineColor,
    Color? awayColor,
    Color? ringColor,
    double? ringWidth,
    double? dotSize,
    double? largeDotSize,
    double? largeAvatarThreshold,
    Duration? colorDuration,
  }) {
    return LinagoraPresenceBadgeStyle(
      onlineColor: onlineColor ?? this.onlineColor,
      awayColor: awayColor ?? this.awayColor,
      ringColor: ringColor ?? this.ringColor,
      ringWidth: ringWidth ?? this.ringWidth,
      dotSize: dotSize ?? this.dotSize,
      largeDotSize: largeDotSize ?? this.largeDotSize,
      largeAvatarThreshold: largeAvatarThreshold ?? this.largeAvatarThreshold,
      colorDuration: colorDuration ?? this.colorDuration,
    );
  }
}
