import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/list_item/linagora_person_tile_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';
import 'package:linagora_design_flutter/style/linagora_typography.dart';

/// Tokens for [LinagoraAccountSwitcher] and [LinagoraAccountMenu].
///
/// The switcher menu panel is 256 wide. [avatarMenu] widens it for the
/// profile header. The chip is 32 high, or 40 once [compact].
@immutable
class LinagoraAccountSwitcherStyle {
  final double chipHeight;
  final double chipRadius;
  final Color chipColor;
  final Color chipBorderColor;
  final Color chipHoverColor;
  final EdgeInsetsGeometry chipPadding;
  final double chipAvatarSize;
  final double chipGap;
  final TextStyle chipTextStyle;
  final double chipIconSize;
  final Color chipIconColor;

  final double menuWidth;
  final double menuMaxHeight;
  final Color menuColor;
  final double menuRadius;
  final List<BoxShadow> menuShadow;
  final EdgeInsetsGeometry menuPadding;

  /// Space between the chip and the menu.
  final double menuOffset;

  final TextStyle sectionTextStyle;
  final EdgeInsetsGeometry sectionPadding;
  final double sectionGap;

  /// Horizontal inset around each account / footer row so the selected
  /// highlight stays off the menu edge while dividers stay full-bleed.
  final EdgeInsetsGeometry itemPadding;

  final double checkIconSize;
  final Color checkIconColor;

  final EdgeInsetsGeometry headerPadding;
  final double headerAvatarSize;
  final double headerAvatarGap;
  final TextStyle headerNameTextStyle;
  final double headerEmailGap;
  final TextStyle headerEmailTextStyle;
  final double headerCopyGap;
  final double headerCopySize;
  final double headerCopyIconSize;
  final Color headerCopyColor;
  final double headerBadgeGap;

  final double footerDividerGap;
  final Color footerDividerColor;
  final double footerIconSize;
  final Color footerIconColor;

  /// Rows of the account list.
  final LinagoraPersonTileStyle tileStyle;

  /// Manage / Sign out rows: shorter than account rows, with a tighter start inset.
  final LinagoraPersonTileStyle footerTileStyle;

  const LinagoraAccountSwitcherStyle({
    required this.chipHeight,
    required this.chipRadius,
    required this.chipColor,
    required this.chipBorderColor,
    required this.chipHoverColor,
    required this.chipPadding,
    required this.chipAvatarSize,
    required this.chipGap,
    required this.chipTextStyle,
    required this.chipIconSize,
    required this.chipIconColor,
    required this.menuWidth,
    required this.menuMaxHeight,
    required this.menuColor,
    required this.menuRadius,
    required this.menuShadow,
    required this.menuPadding,
    required this.menuOffset,
    required this.sectionTextStyle,
    required this.sectionPadding,
    required this.sectionGap,
    required this.itemPadding,
    required this.checkIconSize,
    required this.checkIconColor,
    required this.headerPadding,
    required this.headerAvatarSize,
    required this.headerAvatarGap,
    required this.headerNameTextStyle,
    required this.headerEmailGap,
    required this.headerEmailTextStyle,
    required this.headerCopyGap,
    required this.headerCopySize,
    required this.headerCopyIconSize,
    required this.headerCopyColor,
    required this.headerBadgeGap,
    required this.footerDividerGap,
    required this.footerDividerColor,
    required this.footerIconSize,
    required this.footerIconColor,
    required this.tileStyle,
    required this.footerTileStyle,
  });

  static final LinagoraAccountSwitcherStyle _material = _build((
    textColor: const Color(0xE5424244),
    // Text/icon at 64% (#424244 @ 0.64).
    secondaryColor: const Color(0xA3424244),
    chipColor: const Color(0xFFF3F6F9),
    chipHoverColor: const Color(0x0A424244),
    surfaceColor: Colors.white,
    accentColor: LinagoraSysColors.material().primary,
    dividerColor:
        LinagoraSysColors.material().surfaceTint.withValues(alpha: 0.16),
    tileStyle: LinagoraPersonTileStyle.material(),
  ));

  static final LinagoraAccountSwitcherStyle _dark = _build((
    textColor: Colors.white,
    secondaryColor: const Color(0xA3FFFFFF),
    chipColor: const Color(0x14FFFFFF),
    chipHoverColor: const Color(0x14FFFFFF),
    surfaceColor: const Color(0xFF3F4249),
    accentColor: const Color(0xFF9BBEFA),
    dividerColor: const Color(0x1FFFFFFF),
    tileStyle: LinagoraPersonTileStyle.dark(),
  ));

  factory LinagoraAccountSwitcherStyle.material() => _material;

  factory LinagoraAccountSwitcherStyle.dark() => _dark;

  static LinagoraAccountSwitcherStyle _build(
    ({
      Color textColor,
      Color secondaryColor,
      Color chipColor,
      Color chipHoverColor,
      Color surfaceColor,
      Color accentColor,
      Color dividerColor,
      LinagoraPersonTileStyle tileStyle,
    }) colors,
  ) {
    final text = LinagoraTextTheme.material();
    final type = LinagoraTypography.material();
    final rowText = type.body2.copyWith(color: colors.textColor);
    return LinagoraAccountSwitcherStyle(
      chipHeight: 32,
      chipRadius: 8,
      chipColor: colors.chipColor,
      chipBorderColor: Colors.transparent,
      chipHoverColor: colors.chipHoverColor,
      chipPadding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      chipAvatarSize: 20,
      chipGap: 6,
      chipTextStyle: text.bodyMedium!.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colors.textColor,
      ),
      chipIconSize: 20,
      chipIconColor: colors.secondaryColor,
      menuWidth: 256,
      menuMaxHeight: 480,
      menuColor: colors.surfaceColor,
      menuRadius: 8,
      menuShadow: const [
        BoxShadow(
          color: Color(0x26000000),
          offset: Offset(0, 4),
          blurRadius: 8,
          spreadRadius: 3,
        ),
        BoxShadow(
          color: Color(0x4D000000),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
      // Horizontal inset lives on header / sections / itemPadding so footer
      // dividers can paint edge-to-edge.
      menuPadding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
      menuOffset: 6,
      sectionTextStyle: text.labelMedium!.copyWith(color: colors.textColor),
      // Top 4 + menu top 12 → first title at 16; bottom 8 is title→row.
      // sectionGap 0 → row→next title stays 4 (section top only).
      sectionPadding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      sectionGap: 0,
      // Keeps the selected soft-rect highlight ~16px off the menu border.
      itemPadding: const EdgeInsets.symmetric(horizontal: 16),
      checkIconSize: 24,
      checkIconColor: colors.accentColor,
      headerPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      headerAvatarSize: 32,
      headerAvatarGap: 8,
      headerNameTextStyle: type.h4.copyWith(color: colors.textColor),
      headerEmailGap: 8,
      headerEmailTextStyle: type.body2.copyWith(color: colors.secondaryColor),
      headerCopyGap: 4,
      headerCopySize: 24,
      headerCopyIconSize: 24,
      headerCopyColor: colors.secondaryColor,
      headerBadgeGap: 12,
      // Divider + breathing room before Manage / Sign out; rows stay tight.
      footerDividerGap: 16,
      footerDividerColor: colors.dividerColor,
      // Icon frame is 20 (glyph ~16.67).
      footerIconSize: 20,
      footerIconColor: colors.secondaryColor,
      // Person-tile defaults already match account rows (56 / 32 / py 8).
      // End pad 8 + a trailing box of avatarSize centres the 24 check 12 from the edge.
      tileStyle: colors.tileStyle.copyWith(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
        avatarGap: 8,
        trailingGap: 8,
        subtitleGap: 4,
        tileRadius: 8,
        nameTextStyle: rowText,
      ),
      // Footer items are 40 high (py 4); start 8 + itemPadding 16 and a 20
      // avatar slot put the manage / sign-out glyph at x24.
      footerTileStyle: colors.tileStyle.copyWith(
        minHeight: 40,
        avatarSize: 20,
        padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
        avatarGap: 8,
        trailingGap: 8,
        tileRadius: 8,
        nameTextStyle: rowText,
      ),
    );
  }

  /// The avatar-only chip of narrow layouts: taller, round, on the menu
  /// surface with the regular chip colour as its outline.
  LinagoraAccountSwitcherStyle compact() {
    return copyWith(
      chipHeight: 40,
      chipRadius: 20,
      chipAvatarSize: 24,
      chipPadding: const EdgeInsetsDirectional.only(start: 8, end: 6),
      chipGap: 4,
      chipColor: menuColor,
      chipBorderColor: chipColor,
    );
  }

  /// Wider panel for an avatar [LinagoraAccountMenu] with profile header.
  LinagoraAccountSwitcherStyle avatarMenu() {
    return copyWith(
      menuWidth: 326,
      menuRadius: 14,
      menuPadding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      // Titles at x24; sectionGap 8 + title top 4 → 12 from a row to the next title.
      sectionPadding: const EdgeInsetsDirectional.fromSTEB(24, 4, 24, 8),
      sectionGap: 8,
      // Rows at ~x19.5 so the highlight is 287 wide in a 326 panel.
      itemPadding: const EdgeInsets.symmetric(horizontal: 19.5),
      // 19.5 + 4.5 keeps footer icons at x24 after the wider row inset.
      footerTileStyle: footerTileStyle.copyWith(
        padding: const EdgeInsetsDirectional.fromSTEB(4.5, 4, 8, 4),
      ),
    );
  }

  // @codescene(disable:"Excess Number of Function Arguments") mirrors every field
  LinagoraAccountSwitcherStyle copyWith({
    double? chipHeight,
    double? chipRadius,
    Color? chipColor,
    Color? chipBorderColor,
    Color? chipHoverColor,
    EdgeInsetsGeometry? chipPadding,
    double? chipAvatarSize,
    double? chipGap,
    TextStyle? chipTextStyle,
    double? chipIconSize,
    Color? chipIconColor,
    double? menuWidth,
    double? menuMaxHeight,
    Color? menuColor,
    double? menuRadius,
    List<BoxShadow>? menuShadow,
    EdgeInsetsGeometry? menuPadding,
    double? menuOffset,
    TextStyle? sectionTextStyle,
    EdgeInsetsGeometry? sectionPadding,
    double? sectionGap,
    EdgeInsetsGeometry? itemPadding,
    double? checkIconSize,
    Color? checkIconColor,
    EdgeInsetsGeometry? headerPadding,
    double? headerAvatarSize,
    double? headerAvatarGap,
    TextStyle? headerNameTextStyle,
    double? headerEmailGap,
    TextStyle? headerEmailTextStyle,
    double? headerCopyGap,
    double? headerCopySize,
    double? headerCopyIconSize,
    Color? headerCopyColor,
    double? headerBadgeGap,
    double? footerDividerGap,
    Color? footerDividerColor,
    double? footerIconSize,
    Color? footerIconColor,
    LinagoraPersonTileStyle? tileStyle,
    LinagoraPersonTileStyle? footerTileStyle,
  }) {
    return LinagoraAccountSwitcherStyle(
      chipHeight: chipHeight ?? this.chipHeight,
      chipRadius: chipRadius ?? this.chipRadius,
      chipColor: chipColor ?? this.chipColor,
      chipBorderColor: chipBorderColor ?? this.chipBorderColor,
      chipHoverColor: chipHoverColor ?? this.chipHoverColor,
      chipPadding: chipPadding ?? this.chipPadding,
      chipAvatarSize: chipAvatarSize ?? this.chipAvatarSize,
      chipGap: chipGap ?? this.chipGap,
      chipTextStyle: chipTextStyle ?? this.chipTextStyle,
      chipIconSize: chipIconSize ?? this.chipIconSize,
      chipIconColor: chipIconColor ?? this.chipIconColor,
      menuWidth: menuWidth ?? this.menuWidth,
      menuMaxHeight: menuMaxHeight ?? this.menuMaxHeight,
      menuColor: menuColor ?? this.menuColor,
      menuRadius: menuRadius ?? this.menuRadius,
      menuShadow: menuShadow ?? this.menuShadow,
      menuPadding: menuPadding ?? this.menuPadding,
      menuOffset: menuOffset ?? this.menuOffset,
      sectionTextStyle: sectionTextStyle ?? this.sectionTextStyle,
      sectionPadding: sectionPadding ?? this.sectionPadding,
      sectionGap: sectionGap ?? this.sectionGap,
      itemPadding: itemPadding ?? this.itemPadding,
      checkIconSize: checkIconSize ?? this.checkIconSize,
      checkIconColor: checkIconColor ?? this.checkIconColor,
      headerPadding: headerPadding ?? this.headerPadding,
      headerAvatarSize: headerAvatarSize ?? this.headerAvatarSize,
      headerAvatarGap: headerAvatarGap ?? this.headerAvatarGap,
      headerNameTextStyle: headerNameTextStyle ?? this.headerNameTextStyle,
      headerEmailGap: headerEmailGap ?? this.headerEmailGap,
      headerEmailTextStyle: headerEmailTextStyle ?? this.headerEmailTextStyle,
      headerCopyGap: headerCopyGap ?? this.headerCopyGap,
      headerCopySize: headerCopySize ?? this.headerCopySize,
      headerCopyIconSize: headerCopyIconSize ?? this.headerCopyIconSize,
      headerCopyColor: headerCopyColor ?? this.headerCopyColor,
      headerBadgeGap: headerBadgeGap ?? this.headerBadgeGap,
      footerDividerGap: footerDividerGap ?? this.footerDividerGap,
      footerDividerColor: footerDividerColor ?? this.footerDividerColor,
      footerIconSize: footerIconSize ?? this.footerIconSize,
      footerIconColor: footerIconColor ?? this.footerIconColor,
      tileStyle: tileStyle ?? this.tileStyle,
      footerTileStyle: footerTileStyle ?? this.footerTileStyle,
    );
  }
}
