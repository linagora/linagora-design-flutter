import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_control.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

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

  /// Minimum height of a section header.
  final double sectionHeaderMinHeight;

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

  /// Section header foreground. Null derives it from [foreground] — see
  /// [resolvedSectionHeaderForeground], which is what widgets read.
  final Color? sectionHeaderForeground;

  /// Applied to the whole row content while disabled, so every slot dims by
  /// the same amount.
  final double disabledOpacity;

  /// Row label, mailbox and folder alike: 14 · w500 · 18.4px line · 0.25
  /// letter spacing. Carries no colour — the row inks it from its state.
  final TextStyle labelTextStyle;

  /// Badge counter, and the default for text in the trailing slot:
  /// 11 · w500 · 16px line · 0.5 letter spacing.
  final TextStyle badgeTextStyle;

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
    required this.labelTextStyle,
    required this.badgeTextStyle,
    this.sectionHeaderMinHeight = LinagoraSidebarControl.tapTarget,
    this.sectionHeaderForeground,
    this.disabledOpacity = 0.38,
  });

  static final LinagoraSidebarStyle _light = _build(
    overlay: (base: const Color(0xFF1D192B), hover: 0.04, selected: 0.08),
    ink: (
      // Primary text at 90%, shared by the label and the badge count.
      normal: const Color(0xFF424244).withValues(alpha: 0.9),
      active: const Color(0xFF0A84FF),
      trailing: const Color(0xFF737576),
    ),
    sectionHeaderForeground: const Color(0xFF424244).withValues(alpha: 0.64),
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

  /// How far a section header's caption sits behind a row label. Applied to
  /// [foreground] whenever a style leaves [sectionHeaderForeground] unset, so
  /// the step exists in exactly one place.
  static const double _sectionHeaderOpacity = 0.64;

  /// The colour a section header actually paints with: [sectionHeaderForeground]
  /// when a style names one, otherwise the step back from [foreground].
  Color get resolvedSectionHeaderForeground =>
      sectionHeaderForeground ??
      foreground.withValues(alpha: _sectionHeaderOpacity);

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
    sectionHeaderMinHeight: sectionHeaderMinHeight,
    hoverBackground: hoverBackground,
    selectedBackground: selectedBackground,
    badgeBackground: badgeBackground,
    badgeHeight: badgeHeight,
    badgeHorizontalPadding: badgeHorizontalPadding,
    badgeForeground: badgeForeground,
    foreground: foreground,
    activeForeground: activeForeground,
    trailingForeground: trailingForeground,
    // Resolved, so a style that names the derived colour explicitly compares
    // equal to one that leaves it to be derived.
    sectionHeaderForeground: resolvedSectionHeaderForeground,
    labelTextStyle: labelTextStyle,
    badgeTextStyle: badgeTextStyle,
    disabledOpacity: disabledOpacity,
  );

  /// Lays text out on its glyphs, dropping the leading a fixed line height
  /// adds around them.
  ///
  /// Flutter splits that leading in proportion to the font's ascent and
  /// descent, which leaves the text low in its box. Sidebar labels are single
  /// lines centred by their row, so the leading only pushes them off centre.
  static const TextHeightBehavior middleAligned = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  /// The shared `bodyMedium` token on the sidebar's tighter 18.4px line.
  static final TextStyle _labelTextStyle = LinagoraTextTheme.material()
      .bodyMedium!
      .copyWith(height: 18.4 / 14);

  static final TextStyle _badgeTextStyle =
      LinagoraTextTheme.material().labelSmall!;

  /// Cap height of TwakeInter (`OS/2.sCapHeight`), and so a digit's ink, as a
  /// share of the font size.
  ///
  /// The badge centres that ink rather than the paragraph around it, which
  /// reaches lower. Another face costs a fraction of a pixel.
  static const double badgeCapHeightRatio = 1490 / 2048;

  static LinagoraSidebarStyle _build({
    required _Overlay overlay,
    required _Ink ink,
    Color? sectionHeaderForeground,
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
      // Off the 8px scale: it is what hugs `999+` to a 39px pill.
      badgeHorizontalPadding: 4.5,
      badgeForeground: ink.normal,
      foreground: ink.normal,
      activeForeground: ink.active,
      trailingForeground: ink.trailing,
      sectionHeaderForeground: sectionHeaderForeground,
      labelTextStyle: _labelTextStyle,
      badgeTextStyle: _badgeTextStyle,
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
  double sectionHeaderMinHeight,
  Color hoverBackground,
  Color selectedBackground,
  Color badgeBackground,
  double badgeHeight,
  double badgeHorizontalPadding,
  Color badgeForeground,
  Color foreground,
  Color activeForeground,
  Color trailingForeground,
  // Non-null: [_values] stores the resolved colour, never the raw field.
  Color sectionHeaderForeground,
  TextStyle labelTextStyle,
  TextStyle badgeTextStyle,
  double disabledOpacity,
});
