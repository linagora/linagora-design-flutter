import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';
import 'package:linagora_design_flutter/style/linagora_typography.dart';

/// Tokens for [LinagoraPersonTile] and [LinagoraTileGroup].
@immutable
class LinagoraPersonTileStyle {
  final double minHeight;
  final EdgeInsetsDirectional padding;

  /// Space after the trailing action, which replaces the end [padding].
  final double actionEndPadding;
  final double avatarSize;
  final double avatarGap;
  final double trailingGap;

  final TextStyle nameTextStyle;
  final TextStyle subtitleTextStyle;
  final double subtitleGap;

  final double actionButtonSize;
  final double actionIconSize;
  final Color actionIconColor;

  final Color selectedColor;
  final Color hoverColor;
  final double tileRadius;

  final TextStyle headerTextStyle;
  final double headerGap;
  final double groupRadius;
  final Color groupBorderColor;
  final Color groupFillColor;

  const LinagoraPersonTileStyle({
    required this.minHeight,
    required this.padding,
    required this.actionEndPadding,
    required this.avatarSize,
    required this.avatarGap,
    required this.trailingGap,
    required this.nameTextStyle,
    required this.subtitleTextStyle,
    required this.subtitleGap,
    required this.actionButtonSize,
    required this.actionIconSize,
    required this.actionIconColor,
    required this.selectedColor,
    required this.hoverColor,
    required this.tileRadius,
    required this.headerTextStyle,
    required this.headerGap,
    required this.groupRadius,
    required this.groupBorderColor,
    required this.groupFillColor,
  });

  static final LinagoraPersonTileStyle _material = _build((
    textColor: const Color(0xE5424244),
    secondaryTextColor: const Color(0xA3424244),
    actionIconColor: const Color(0xFF7A7781),
    selectedColor: const Color(0x140A84FF),
    hoverColor: const Color(0x0A424244),
    groupBorderColor: const Color(0x29424244),
    groupFillColor: const Color(0x0A424244),
  ));

  static final LinagoraPersonTileStyle _dark = _build((
    textColor: Colors.white,
    secondaryTextColor: const Color(0xA3FFFFFF),
    actionIconColor: const Color(0xA3FFFFFF),
    selectedColor: const Color(0x299BBEFA),
    hoverColor: const Color(0x14FFFFFF),
    groupBorderColor: const Color(0x1FFFFFFF),
    groupFillColor: const Color(0x0AFFFFFF),
  ));

  factory LinagoraPersonTileStyle.material() => _material;

  factory LinagoraPersonTileStyle.dark() => _dark;

  static LinagoraPersonTileStyle _build(
    ({
      Color textColor,
      Color secondaryTextColor,
      Color actionIconColor,
      Color selectedColor,
      Color hoverColor,
      Color groupBorderColor,
      Color groupFillColor,
    }) colors,
  ) {
    final text = LinagoraTextTheme.material();
    final type = LinagoraTypography.material();
    return LinagoraPersonTileStyle(
      minHeight: 56,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      actionEndPadding: 8,
      avatarSize: 32,
      avatarGap: 16,
      trailingGap: 16,
      nameTextStyle: type.body1.copyWith(color: colors.textColor),
      subtitleTextStyle:
          text.labelMedium!.copyWith(color: colors.secondaryTextColor),
      subtitleGap: 1,
      actionButtonSize: 32,
      actionIconSize: 24,
      actionIconColor: colors.actionIconColor,
      selectedColor: colors.selectedColor,
      hoverColor: colors.hoverColor,
      tileRadius: 12,
      headerTextStyle: type.h6.copyWith(color: colors.textColor),
      headerGap: 12,
      groupRadius: 12,
      groupBorderColor: colors.groupBorderColor,
      groupFillColor: colors.groupFillColor,
    );
  }

  // @codescene(disable:"Excess Number of Function Arguments") mirrors every field
  LinagoraPersonTileStyle copyWith({
    double? minHeight,
    EdgeInsetsDirectional? padding,
    double? actionEndPadding,
    double? avatarSize,
    double? avatarGap,
    double? trailingGap,
    TextStyle? nameTextStyle,
    TextStyle? subtitleTextStyle,
    double? subtitleGap,
    double? actionButtonSize,
    double? actionIconSize,
    Color? actionIconColor,
    Color? selectedColor,
    Color? hoverColor,
    double? tileRadius,
    TextStyle? headerTextStyle,
    double? headerGap,
    double? groupRadius,
    Color? groupBorderColor,
    Color? groupFillColor,
  }) {
    return LinagoraPersonTileStyle(
      minHeight: minHeight ?? this.minHeight,
      padding: padding ?? this.padding,
      actionEndPadding: actionEndPadding ?? this.actionEndPadding,
      avatarSize: avatarSize ?? this.avatarSize,
      avatarGap: avatarGap ?? this.avatarGap,
      trailingGap: trailingGap ?? this.trailingGap,
      nameTextStyle: nameTextStyle ?? this.nameTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      subtitleGap: subtitleGap ?? this.subtitleGap,
      actionButtonSize: actionButtonSize ?? this.actionButtonSize,
      actionIconSize: actionIconSize ?? this.actionIconSize,
      actionIconColor: actionIconColor ?? this.actionIconColor,
      selectedColor: selectedColor ?? this.selectedColor,
      hoverColor: hoverColor ?? this.hoverColor,
      tileRadius: tileRadius ?? this.tileRadius,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      headerGap: headerGap ?? this.headerGap,
      groupRadius: groupRadius ?? this.groupRadius,
      groupBorderColor: groupBorderColor ?? this.groupBorderColor,
      groupFillColor: groupFillColor ?? this.groupFillColor,
    );
  }
}
