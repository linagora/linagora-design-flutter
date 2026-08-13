import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// Design tokens for the shared left menu.
///
/// Resolved from the ambient [Theme] brightness by [of], so applications get
/// the right light and dark values without registering anything in their
/// [ThemeData]. Sidebar widgets take a `style` to override the whole set.
class LinagoraSidebarStyle {
  final double itemMinHeight;
  final double itemBorderRadius;
  final double itemIconSize;
  final double itemHorizontalPadding;

  /// The expand/collapse chevron is smaller than the leading glyph.
  final double chevronSize;

  /// Gap between the leading glyph, the label and the trailing slot.
  final double itemSpacing;

  final Color hoverBackground;
  final Color selectedBackground;

  /// Translucent, so a badge on an active row reads stronger than one on a
  /// default row.
  final Color badgeBackground;

  final double badgeHeight;
  final double badgeHorizontalPadding;

  /// Badge label. Kept in the style so a custom one controls the whole badge.
  final Color badgeForeground;

  /// Label and leading glyph on a default row.
  final Color foreground;

  /// Label and leading glyph on the active row.
  final Color activeForeground;

  /// Trailing controls — the chevron, row actions and overflow icon — which
  /// sit a step back from the label.
  final Color trailingForeground;

  /// Applied to the whole row content while disabled, so every slot dims by
  /// the same amount.
  final double disabledOpacity;

  const LinagoraSidebarStyle({
    required this.itemMinHeight,
    required this.itemBorderRadius,
    required this.itemIconSize,
    required this.itemHorizontalPadding,
    required this.chevronSize,
    required this.itemSpacing,
    required this.hoverBackground,
    required this.selectedBackground,
    required this.badgeBackground,
    required this.badgeHeight,
    required this.badgeHorizontalPadding,
    required this.badgeForeground,
    required this.foreground,
    required this.activeForeground,
    required this.trailingForeground,
    this.disabledOpacity = 0.38,
  });

  static final LinagoraSidebarStyle _light = _build(
    overlay: (base: const Color(0xFF1D192B), hover: 0.04, selected: 0.08),
    ink: (
      normal: const Color(0xFF49494B),
      active: const Color(0xFF0A84FF),
      trailing: const Color(0xFF737576),
    ),
  );

  /// Dark inverts the overlay — a near-black wash is invisible on it — and
  /// doubles the opacity to reach the same contrast steps.
  static final LinagoraSidebarStyle _dark = _build(
    overlay: (base: const Color(0xFFFFFFFF), hover: 0.08, selected: 0.16),
    ink: (
      normal: const Color(0xFFFFFFFF),
      active: const Color(0xFF91BFFF),
      trailing: const Color(0xFFB0B3B5),
    ),
  );

  factory LinagoraSidebarStyle.light() => _light;

  factory LinagoraSidebarStyle.dark() => _dark;

  /// The style matching the ambient [Theme] brightness.
  static LinagoraSidebarStyle of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? LinagoraSidebarStyle.dark()
          : LinagoraSidebarStyle.light();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinagoraSidebarStyle && _values == other._values;

  @override
  int get hashCode => _values.hashCode;

  _SidebarStyleValues get _values => (
    itemMinHeight: itemMinHeight,
    itemBorderRadius: itemBorderRadius,
    itemIconSize: itemIconSize,
    itemHorizontalPadding: itemHorizontalPadding,
    chevronSize: chevronSize,
    itemSpacing: itemSpacing,
    hoverBackground: hoverBackground,
    selectedBackground: selectedBackground,
    badgeBackground: badgeBackground,
    badgeHeight: badgeHeight,
    badgeHorizontalPadding: badgeHorizontalPadding,
    badgeForeground: badgeForeground,
    foreground: foreground,
    activeForeground: activeForeground,
    trailingForeground: trailingForeground,
    disabledOpacity: disabledOpacity,
  );

  static LinagoraSidebarStyle _build({
    required _Overlay overlay,
    required _Ink ink,
  }) {
    final selected = overlay.base.withValues(alpha: overlay.selected);
    return LinagoraSidebarStyle(
      itemMinHeight: 36,
      itemBorderRadius: LinagoraSpacing.base,
      itemIconSize: LinagoraSpacing.base * 2,
      itemHorizontalPadding: LinagoraSpacing.base,
      chevronSize: 10,
      itemSpacing: LinagoraSpacing.base,
      hoverBackground: overlay.base.withValues(alpha: overlay.hover),
      selectedBackground: selected,
      badgeBackground: selected,
      badgeHeight: LinagoraSpacing.base * 2,
      badgeHorizontalPadding: LinagoraSpacing.base * 0.75,
      badgeForeground: ink.normal,
      foreground: ink.normal,
      activeForeground: ink.active,
      trailingForeground: ink.trailing,
    );
  }
}

/// The wash the row fills are made of: one colour at two opacities.
typedef _Overlay = ({Color base, double hover, double selected});

/// The row's three ink colours.
typedef _Ink = ({Color normal, Color active, Color trailing});

typedef _SidebarStyleValues = ({
  double itemMinHeight,
  double itemBorderRadius,
  double itemIconSize,
  double itemHorizontalPadding,
  double chevronSize,
  double itemSpacing,
  Color hoverBackground,
  Color selectedBackground,
  Color badgeBackground,
  double badgeHeight,
  double badgeHorizontalPadding,
  Color badgeForeground,
  Color foreground,
  Color activeForeground,
  Color trailingForeground,
  double disabledOpacity,
});
