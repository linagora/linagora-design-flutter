import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_control.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Design tokens for the shared left menu.
///
/// Resolved from the ambient [Theme] brightness by [of], so applications get
/// the right light and dark values without registering anything in their
/// [ThemeData]. Sidebar widgets take a `style` to override the whole set.
class LinagoraSidebarStyle {
  /// Brightness this token set was derived for.
  ///
  /// Widgets must use this instead of the ambient [Theme] when a sidebar
  /// style is injected beneath a differently themed parent.
  final Brightness brightness;

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

  /// Persistent wash for an action whose product menu or popover is open.
  ///
  /// Null keeps custom styles created before sidebar actions compatible; the
  /// selected-row wash is a visually equivalent fallback.
  final Color? actionActiveBackground;

  /// Inset around a glyph in the compact, round sidebar action target.
  final double actionIconPadding;

  /// Section header foreground. Null derives it from [foreground] — see
  /// [resolvedSectionHeaderForeground], which is what widgets read.
  final Color? sectionHeaderForeground;

  /// The storage quota bar height. It is intentionally thinner than a row
  /// divider so the quota reads as status rather than a section boundary.
  final double progressHeight;

  /// Storage title and quota-caption foreground. Null keeps legacy custom
  /// styles working by deriving the secondary text step from [foreground].
  final Color? storageForeground;

  /// The storage glyph foreground. The Figma icon token is stronger than the
  /// storage title and caption, especially in dark mode.
  final Color? storageIconForeground;

  /// The small build/version line beneath the storage caption.
  final Color? storageVersionForeground;

  /// Filled and unfilled storage quota colours.
  final Color? progressColor;
  final Color? progressWarningColor;
  final Color? progressFullColor;
  final Color? progressTrackColor;

  /// Outline and foreground used by a generic sidebar promotional action.
  final Color? upsellBorderColor;
  final Color? upsellForeground;

  /// Generic confirmation popover surface tokens.
  final Color? popoverBackground;
  final Color? popoverShadowColor;

  /// Fill of a destructive confirm button, and the label colour both confirm
  /// variants paint with.
  final Color? destructiveBackground;
  final Color? confirmForeground;

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
    this.brightness = Brightness.light,
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
    this.actionActiveBackground,
    this.actionIconPadding = LinagoraSpacing.base / 2,
    this.sectionHeaderMinHeight = LinagoraSidebarControl.tapTarget,
    this.sectionHeaderForeground,
    this.progressHeight = 3,
    this.storageForeground,
    this.storageIconForeground,
    this.storageVersionForeground,
    this.progressColor,
    this.progressWarningColor,
    this.progressFullColor,
    this.progressTrackColor,
    this.upsellBorderColor,
    this.upsellForeground,
    this.popoverBackground,
    this.popoverShadowColor,
    this.destructiveBackground,
    this.confirmForeground,
    this.disabledOpacity = 0.38,
  }) : assert(
         itemMinHeight > 0 &&
             itemBorderRadius >= 0 &&
             itemIconSize >= 0 &&
             itemHorizontalPadding >= 0 &&
             chevronSize >= 0 &&
             itemSpacing >= 0,
         'Sidebar item dimensions cannot be negative',
       ),
       assert(
         sectionHeaderMinHeight > 0 &&
             badgeHeight > 0 &&
             badgeHorizontalPadding >= 0 &&
             actionIconPadding >= 0 &&
             progressHeight > 0,
         'Sidebar control dimensions must be positive',
       ),
       assert(
         disabledOpacity >= 0 && disabledOpacity <= 1,
         'Sidebar disabled opacity must be between zero and one',
       ),
       assert(
         progressHeight > 0 && progressHeight < double.infinity,
         'Storage progress height must be finite and greater than zero',
       );

  /// Creates a style from this one with related override groups applied.
  ///
  /// Keep related overrides together so a product can change a narrow concern
  /// without rebuilding its whole sidebar palette:
  ///
  /// ```dart
  /// final style = LinagoraSidebarStyle.light().copyWith(
  ///   item: const LinagoraSidebarItemStyleOverride(
  ///     itemSpacing: 12,
  ///     foreground: Color(0xFF0055AA),
  ///   ),
  /// );
  /// ```
  LinagoraSidebarStyle copyWith({
    LinagoraSidebarItemStyleOverride? item,
    LinagoraSidebarSectionStyleOverride? section,
    LinagoraSidebarStorageStyleOverride? storage,
    LinagoraSidebarPopoverStyleOverride? popover,
  }) {
    final builder = _LinagoraSidebarStyleBuilder(this);
    builder.applyItem(item);
    builder.applySection(section);
    builder.applyStorage(storage);
    builder.applyPopover(popover);
    return builder.build();
  }

  static final LinagoraSidebarStyle _light = _build(
    brightness: Brightness.light,
    overlay: (base: const Color(0xFF1D192B), hover: 0.04, selected: 0.08),
    ink: (
      // Primary text at 90%, shared by the label and the badge count.
      normal: const Color(0xFF424244).withValues(alpha: 0.9),
      active: const Color(0xFF0A84FF),
      trailing: const Color(0xA3424242),
    ),
    sectionHeaderForeground: const Color(0xFF424244).withValues(alpha: 0.64),
    progressColors: (
      warning: LinagoraSysColors.material().warning,
      full: LinagoraSysColors.material().error,
    ),
  );

  /// Dark inverts the overlay — a near-black wash is invisible on it — and
  /// doubles the opacity to reach the same contrast steps.
  static final LinagoraSidebarStyle _dark = _build(
    brightness: Brightness.dark,
    overlay: (base: const Color(0xFFFFFFFF), hover: 0.08, selected: 0.16),
    ink: (
      normal: const Color(0xFFFFFFFF),
      active: const Color(0xFF91BFFF),
      trailing: const Color(0xA3FFFFFF),
    ),
    progressColors: (
      warning: LinagoraSysColors.material().warningDark,
      full: LinagoraSysColors.material().errorDark,
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

  /// Secondary text colour shared by the storage label and quota caption.
  Color get resolvedStorageForeground =>
      storageForeground ?? foreground.withValues(alpha: _sectionHeaderOpacity);

  /// The icon uses the full sidebar foreground, while the nearby storage text
  /// uses [resolvedStorageForeground].
  Color get resolvedStorageIconForeground =>
      storageIconForeground ?? foreground;

  /// The version uses a steel-grey token in the stock themes. Custom styles
  /// that predate storage fall back to their secondary foreground.
  Color get resolvedStorageVersionForeground =>
      storageVersionForeground ?? resolvedStorageForeground;

  /// Storage progress falls back to the active item colour, keeping injected
  /// pre-storage styles usable without duplicating their colour palette.
  Color get resolvedProgressColor => progressColor ?? activeForeground;

  /// Warning and full states retain the material semantic colours for custom
  /// styles that predate storage, while stock styles supply their own tokens.
  Color get resolvedProgressWarningColor =>
      progressWarningColor ?? LinagoraSysColors.material().warning;

  Color get resolvedProgressFullColor =>
      progressFullColor ?? LinagoraSysColors.material().error;

  Color get resolvedProgressTrackColor =>
      progressTrackColor ?? selectedBackground;

  Color get resolvedActionActiveBackground =>
      actionActiveBackground ?? selectedBackground;

  Color get resolvedUpsellBorderColor => upsellBorderColor ?? activeForeground;

  Color get resolvedUpsellForeground => upsellForeground ?? activeForeground;

  Color get resolvedPopoverBackground => popoverBackground ?? Colors.white;

  Color get resolvedPopoverShadowColor =>
      popoverShadowColor ?? Colors.black.withValues(alpha: 0.24);

  /// Falls back to the quota-full red, the palette's single alarm colour, for
  /// custom styles that predate this token.
  Color get resolvedDestructiveBackground =>
      destructiveBackground ?? resolvedProgressFullColor;

  Color get resolvedConfirmForeground => confirmForeground ?? Colors.white;

  /// The style matching the ambient [Theme] brightness.
  static LinagoraSidebarStyle of(BuildContext context) =>
      LinagoraSidebarTheme.maybeOf(context) ??
      (Theme.of(context).brightness == Brightness.dark
          ? LinagoraSidebarStyle.dark()
          : LinagoraSidebarStyle.light());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinagoraSidebarStyle && _values == other._values;

  @override
  int get hashCode => _values.hashCode;

  _SidebarStyleValues get _values => (
    brightness: brightness,
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
    actionActiveBackground: resolvedActionActiveBackground,
    actionIconPadding: actionIconPadding,
    // Resolved, so a style that names the derived colour explicitly compares
    // equal to one that leaves it to be derived.
    sectionHeaderForeground: resolvedSectionHeaderForeground,
    labelTextStyle: labelTextStyle,
    badgeTextStyle: badgeTextStyle,
    progressHeight: progressHeight,
    storageForeground: resolvedStorageForeground,
    storageIconForeground: resolvedStorageIconForeground,
    storageVersionForeground: resolvedStorageVersionForeground,
    progressColor: resolvedProgressColor,
    progressWarningColor: resolvedProgressWarningColor,
    progressFullColor: resolvedProgressFullColor,
    progressTrackColor: resolvedProgressTrackColor,
    upsellBorderColor: resolvedUpsellBorderColor,
    upsellForeground: resolvedUpsellForeground,
    popoverBackground: resolvedPopoverBackground,
    popoverShadowColor: resolvedPopoverShadowColor,
    destructiveBackground: resolvedDestructiveBackground,
    confirmForeground: resolvedConfirmForeground,
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
    required Brightness brightness,
    required _Overlay overlay,
    required _Ink ink,
    Color? sectionHeaderForeground,
    required _ProgressColors progressColors,
  }) {
    final selected = overlay.base.withValues(alpha: overlay.selected);
    return LinagoraSidebarStyle(
      brightness: brightness,
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
      actionActiveBackground: selected,
      storageVersionForeground: const Color(0xFF818C99),
      progressColor: ink.active,
      progressWarningColor: progressColors.warning,
      progressFullColor: progressColors.full,
      progressTrackColor: selected,
      upsellBorderColor: ink.active,
      upsellForeground: ink.active,
      popoverBackground: brightness == Brightness.dark
          ? const Color(0xFF2B2930)
          : Colors.white,
      popoverShadowColor: Colors.black.withValues(alpha: 0.24),
      destructiveBackground: progressColors.full,
      confirmForeground: Colors.white,
    );
  }
}

/// Related overrides for a sidebar item's layout, colours and disabled state.
///
/// Null leaves that token unchanged. Construct [LinagoraSidebarStyle]
/// directly when an optional colour must be reset to its derived fallback.
@immutable
class LinagoraSidebarItemStyleOverride {
  const LinagoraSidebarItemStyleOverride({
    this.itemMinHeight,
    this.itemBorderRadius,
    this.itemIconSize,
    this.itemHorizontalPadding,
    this.chevronSize,
    this.itemSpacing,
    this.hoverBackground,
    this.selectedBackground,
    this.badgeBackground,
    this.badgeHeight,
    this.badgeHorizontalPadding,
    this.badgeForeground,
    this.foreground,
    this.activeForeground,
    this.trailingForeground,
    this.actionActiveBackground,
    this.actionIconPadding,
    this.disabledOpacity,
  });

  final double? itemMinHeight;
  final double? itemBorderRadius;
  final double? itemIconSize;
  final double? itemHorizontalPadding;
  final double? chevronSize;
  final double? itemSpacing;
  final Color? hoverBackground;
  final Color? selectedBackground;
  final Color? badgeBackground;
  final double? badgeHeight;
  final double? badgeHorizontalPadding;
  final Color? badgeForeground;
  final Color? foreground;
  final Color? activeForeground;
  final Color? trailingForeground;
  final Color? actionActiveBackground;
  final double? actionIconPadding;
  final double? disabledOpacity;
}

/// Related overrides for a sidebar section header.
@immutable
class LinagoraSidebarSectionStyleOverride {
  const LinagoraSidebarSectionStyleOverride({
    this.headerMinHeight,
    this.headerForeground,
  });

  final double? headerMinHeight;
  final Color? headerForeground;
}

/// Related overrides for storage and promotional footer content.
@immutable
class LinagoraSidebarStorageStyleOverride {
  const LinagoraSidebarStorageStyleOverride({
    this.progressHeight,
    this.foreground,
    this.iconForeground,
    this.versionForeground,
    this.progressColor,
    this.progressWarningColor,
    this.progressFullColor,
    this.progressTrackColor,
    this.upsellBorderColor,
    this.upsellForeground,
  });

  final double? progressHeight;
  final Color? foreground;
  final Color? iconForeground;
  final Color? versionForeground;
  final Color? progressColor;
  final Color? progressWarningColor;
  final Color? progressFullColor;
  final Color? progressTrackColor;
  final Color? upsellBorderColor;
  final Color? upsellForeground;
}

/// Related overrides for sidebar confirmation popovers.
@immutable
class LinagoraSidebarPopoverStyleOverride {
  const LinagoraSidebarPopoverStyleOverride({
    this.background,
    this.shadow,
    this.destructiveBackground,
    this.confirmForeground,
  });

  final Color? background;
  final Color? shadow;
  final Color? destructiveBackground;
  final Color? confirmForeground;
}

class _LinagoraSidebarStyleBuilder {
  _LinagoraSidebarStyleBuilder(LinagoraSidebarStyle style)
    : _labelTextStyle = style.labelTextStyle,
      _badgeTextStyle = style.badgeTextStyle,
      _item = _LinagoraSidebarItemStyleBuilder(style),
      _section = _LinagoraSidebarSectionStyleBuilder(style),
      _storage = _LinagoraSidebarStorageStyleBuilder(style),
      _popover = _LinagoraSidebarPopoverStyleBuilder(style);

  final TextStyle _labelTextStyle;
  final TextStyle _badgeTextStyle;
  final _LinagoraSidebarItemStyleBuilder _item;
  final _LinagoraSidebarSectionStyleBuilder _section;
  final _LinagoraSidebarStorageStyleBuilder _storage;
  final _LinagoraSidebarPopoverStyleBuilder _popover;

  void applyItem(LinagoraSidebarItemStyleOverride? override) =>
      _item.apply(override);

  void applySection(LinagoraSidebarSectionStyleOverride? override) =>
      _section.apply(override);

  void applyStorage(LinagoraSidebarStorageStyleOverride? override) =>
      _storage.apply(override);

  void applyPopover(LinagoraSidebarPopoverStyleOverride? override) =>
      _popover.apply(override);

  LinagoraSidebarStyle build() => LinagoraSidebarStyle(
    brightness: _item.brightness,
    itemMinHeight: _item.minHeight,
    itemBorderRadius: _item.borderRadius,
    itemIconSize: _item.iconSize,
    itemHorizontalPadding: _item.horizontalPadding,
    chevronSize: _item.chevronSize,
    itemSpacing: _item.spacing,
    hoverBackground: _item.hoverBackground,
    selectedBackground: _item.selectedBackground,
    badgeBackground: _item.badgeBackground,
    badgeHeight: _item.badgeHeight,
    badgeHorizontalPadding: _item.badgeHorizontalPadding,
    badgeForeground: _item.badgeForeground,
    foreground: _item.foreground,
    activeForeground: _item.activeForeground,
    trailingForeground: _item.trailingForeground,
    labelTextStyle: _labelTextStyle,
    badgeTextStyle: _badgeTextStyle,
    actionActiveBackground: _item.actionActiveBackground,
    actionIconPadding: _item.actionIconPadding,
    sectionHeaderMinHeight: _section.headerMinHeight,
    sectionHeaderForeground: _section.headerForeground,
    progressHeight: _storage.progressHeight,
    storageForeground: _storage.foreground,
    storageIconForeground: _storage.iconForeground,
    storageVersionForeground: _storage.versionForeground,
    progressColor: _storage.progressColor,
    progressWarningColor: _storage.progressWarningColor,
    progressFullColor: _storage.progressFullColor,
    progressTrackColor: _storage.progressTrackColor,
    upsellBorderColor: _storage.upsellBorderColor,
    upsellForeground: _storage.upsellForeground,
    popoverBackground: _popover.background,
    popoverShadowColor: _popover.shadow,
    destructiveBackground: _popover.destructiveBackground,
    confirmForeground: _popover.confirmForeground,
    disabledOpacity: _item.disabledOpacity,
  );
}

class _LinagoraSidebarItemStyleBuilder {
  _LinagoraSidebarItemStyleBuilder(LinagoraSidebarStyle style)
    : brightness = style.brightness,
      minHeight = style.itemMinHeight,
      borderRadius = style.itemBorderRadius,
      iconSize = style.itemIconSize,
      horizontalPadding = style.itemHorizontalPadding,
      chevronSize = style.chevronSize,
      spacing = style.itemSpacing,
      hoverBackground = style.hoverBackground,
      selectedBackground = style.selectedBackground,
      badgeBackground = style.badgeBackground,
      badgeHeight = style.badgeHeight,
      badgeHorizontalPadding = style.badgeHorizontalPadding,
      badgeForeground = style.badgeForeground,
      foreground = style.foreground,
      activeForeground = style.activeForeground,
      trailingForeground = style.trailingForeground,
      actionActiveBackground = style.actionActiveBackground,
      actionIconPadding = style.actionIconPadding,
      disabledOpacity = style.disabledOpacity;

  final Brightness brightness;
  double minHeight;
  double borderRadius;
  double iconSize;
  double horizontalPadding;
  double chevronSize;
  double spacing;
  Color hoverBackground;
  Color selectedBackground;
  Color badgeBackground;
  double badgeHeight;
  double badgeHorizontalPadding;
  Color badgeForeground;
  Color foreground;
  Color activeForeground;
  Color trailingForeground;
  Color? actionActiveBackground;
  double actionIconPadding;
  double disabledOpacity;

  void apply(LinagoraSidebarItemStyleOverride? override) {
    if (override == null) return;
    minHeight = override.itemMinHeight ?? minHeight;
    borderRadius = override.itemBorderRadius ?? borderRadius;
    iconSize = override.itemIconSize ?? iconSize;
    horizontalPadding = override.itemHorizontalPadding ?? horizontalPadding;
    chevronSize = override.chevronSize ?? chevronSize;
    spacing = override.itemSpacing ?? spacing;
    hoverBackground = override.hoverBackground ?? hoverBackground;
    selectedBackground = override.selectedBackground ?? selectedBackground;
    badgeBackground = override.badgeBackground ?? badgeBackground;
    badgeHeight = override.badgeHeight ?? badgeHeight;
    badgeHorizontalPadding =
        override.badgeHorizontalPadding ?? badgeHorizontalPadding;
    badgeForeground = override.badgeForeground ?? badgeForeground;
    foreground = override.foreground ?? foreground;
    activeForeground = override.activeForeground ?? activeForeground;
    trailingForeground = override.trailingForeground ?? trailingForeground;
    actionActiveBackground =
        override.actionActiveBackground ?? actionActiveBackground;
    actionIconPadding = override.actionIconPadding ?? actionIconPadding;
    disabledOpacity = override.disabledOpacity ?? disabledOpacity;
  }
}

class _LinagoraSidebarSectionStyleBuilder {
  _LinagoraSidebarSectionStyleBuilder(LinagoraSidebarStyle style)
    : headerMinHeight = style.sectionHeaderMinHeight,
      headerForeground = style.sectionHeaderForeground;

  double headerMinHeight;
  Color? headerForeground;

  void apply(LinagoraSidebarSectionStyleOverride? override) {
    if (override == null) return;
    headerMinHeight = override.headerMinHeight ?? headerMinHeight;
    headerForeground = override.headerForeground ?? headerForeground;
  }
}

class _LinagoraSidebarStorageStyleBuilder {
  _LinagoraSidebarStorageStyleBuilder(LinagoraSidebarStyle style)
    : progressHeight = style.progressHeight,
      foreground = style.storageForeground,
      iconForeground = style.storageIconForeground,
      versionForeground = style.storageVersionForeground,
      progressColor = style.progressColor,
      progressWarningColor = style.progressWarningColor,
      progressFullColor = style.progressFullColor,
      progressTrackColor = style.progressTrackColor,
      upsellBorderColor = style.upsellBorderColor,
      upsellForeground = style.upsellForeground;

  double progressHeight;
  Color? foreground;
  Color? iconForeground;
  Color? versionForeground;
  Color? progressColor;
  Color? progressWarningColor;
  Color? progressFullColor;
  Color? progressTrackColor;
  Color? upsellBorderColor;
  Color? upsellForeground;

  void apply(LinagoraSidebarStorageStyleOverride? override) {
    if (override == null) return;
    progressHeight = override.progressHeight ?? progressHeight;
    foreground = override.foreground ?? foreground;
    iconForeground = override.iconForeground ?? iconForeground;
    versionForeground = override.versionForeground ?? versionForeground;
    progressColor = override.progressColor ?? progressColor;
    progressWarningColor =
        override.progressWarningColor ?? progressWarningColor;
    progressFullColor = override.progressFullColor ?? progressFullColor;
    progressTrackColor = override.progressTrackColor ?? progressTrackColor;
    upsellBorderColor = override.upsellBorderColor ?? upsellBorderColor;
    upsellForeground = override.upsellForeground ?? upsellForeground;
  }
}

class _LinagoraSidebarPopoverStyleBuilder {
  _LinagoraSidebarPopoverStyleBuilder(LinagoraSidebarStyle style)
    : background = style.popoverBackground,
      shadow = style.popoverShadowColor,
      destructiveBackground = style.destructiveBackground,
      confirmForeground = style.confirmForeground;

  Color? background;
  Color? shadow;
  Color? destructiveBackground;
  Color? confirmForeground;

  void apply(LinagoraSidebarPopoverStyleOverride? override) {
    if (override == null) return;
    background = override.background ?? background;
    shadow = override.shadow ?? shadow;
    destructiveBackground =
        override.destructiveBackground ?? destructiveBackground;
    confirmForeground = override.confirmForeground ?? confirmForeground;
  }
}

/// Makes one [LinagoraSidebarStyle] available to every sidebar widget below.
class LinagoraSidebarTheme extends InheritedTheme {
  const LinagoraSidebarTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final LinagoraSidebarStyle data;

  static LinagoraSidebarStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LinagoraSidebarTheme>()?.data;

  @override
  bool updateShouldNotify(LinagoraSidebarTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      LinagoraSidebarTheme(data: data, child: child);
}

/// The wash the row fills are made of: one colour at two opacities.
typedef _Overlay = ({Color base, double hover, double selected});

/// The row's three ink colours.
typedef _Ink = ({Color normal, Color active, Color trailing});

typedef _ProgressColors = ({Color warning, Color full});

typedef _SidebarStyleValues = ({
  Brightness brightness,
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
  Color actionActiveBackground,
  double actionIconPadding,
  // Non-null: [_values] stores the resolved colour, never the raw field.
  Color sectionHeaderForeground,
  TextStyle labelTextStyle,
  TextStyle badgeTextStyle,
  double progressHeight,
  Color storageForeground,
  Color storageIconForeground,
  Color storageVersionForeground,
  Color progressColor,
  Color progressWarningColor,
  Color progressFullColor,
  Color progressTrackColor,
  Color upsellBorderColor,
  Color upsellForeground,
  Color popoverBackground,
  Color popoverShadowColor,
  Color destructiveBackground,
  Color confirmForeground,
  double disabledOpacity,
});
