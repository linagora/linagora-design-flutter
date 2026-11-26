import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Tokens for [LinagoraSegmentedTabs].
///
/// The track is at least 32 high and grows with the text scale. Use
/// [copyWith] to change a few tokens.
@immutable
class LinagoraSegmentedTabsStyle {
  final double height;
  final Color trackColor;
  final EdgeInsetsGeometry trackPadding;

  /// Width of each segment when the tabs are not expanded.
  final double segmentWidth;
  final EdgeInsetsGeometry segmentPadding;

  final Color selectedColor;
  final List<BoxShadow> selectedShadow;
  final Color focusColor;
  final double focusWidth;

  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final TextStyle hoveredTextStyle;
  final TextStyle disabledTextStyle;

  final double iconSize;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  final Duration animationDuration;

  const LinagoraSegmentedTabsStyle({
    required this.height,
    required this.trackColor,
    required this.trackPadding,
    required this.segmentWidth,
    required this.segmentPadding,
    required this.selectedColor,
    required this.selectedShadow,
    required this.focusColor,
    required this.focusWidth,
    required this.selectedTextStyle,
    required this.unselectedTextStyle,
    required this.hoveredTextStyle,
    required this.disabledTextStyle,
    required this.iconSize,
    required this.badgeColor,
    required this.badgeTextStyle,
    required this.animationDuration,
  });

  /// subtitle2: Inter 600 / 14 / 18.4 / 0.25.
  static TextStyle _text(Color color) =>
      LinagoraTextThemeExtension.material().bodyMedium2.copyWith(
            color: color,
            height: 18.4 / 14,
          );

  // M3 Elevation Light/1 (selected thumb).
  static const List<BoxShadow> _selectedShadow = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 1),
      blurRadius: 80,
    ),
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 1,
    ),
  ];

  static final LinagoraSegmentedTabsStyle _material = _build((
    // Track: Background/contrast `#1D212A` @ 4.8%.
    trackColor: const Color(0x0C1D212A),
    // Selected thumb: Background/paper.
    selectedColor: Colors.white,
    // Selected label: Primary/main. Text/secondary @ 64% unselected,
    // 90% hovered, 38% disabled.
    selectedTextColor: const Color(0xFF0A84FF),
    unselectedTextColor: const Color(0xA3424244),
    hoveredTextColor: const Color(0xE6424244),
    disabledTextColor: const Color(0x61424244),
    focusColor: const Color(0xFF0A84FF),
  ));

  static final LinagoraSegmentedTabsStyle _dark = _build((
    trackColor: const Color(0x14FFFFFF),
    // Selected thumb: Background/paper.
    selectedColor: const Color(0xFF3E424A),
    // Selected label: Primary/main. Unselected: Text/secondary @ 64%.
    selectedTextColor: const Color(0xFF91BFFF),
    unselectedTextColor: const Color(0xA3FFFFFF),
    hoveredTextColor: const Color(0xE6FFFFFF),
    disabledTextColor: const Color(0x61FFFFFF),
    focusColor: const Color(0xFF91BFFF),
  ));

  factory LinagoraSegmentedTabsStyle.material() => _material;

  factory LinagoraSegmentedTabsStyle.dark() => _dark;

  static LinagoraSegmentedTabsStyle _build(
    ({
      Color trackColor,
      Color selectedColor,
      Color selectedTextColor,
      Color unselectedTextColor,
      Color hoveredTextColor,
      Color disabledTextColor,
      Color focusColor,
    }) colors,
  ) {
    return LinagoraSegmentedTabsStyle(
      height: 32,
      trackColor: colors.trackColor,
      trackPadding: EdgeInsets.zero,
      segmentWidth: 160,
      segmentPadding: const EdgeInsets.symmetric(horizontal: 16),
      selectedColor: colors.selectedColor,
      selectedShadow: _selectedShadow,
      focusColor: colors.focusColor,
      focusWidth: 2,
      selectedTextStyle: _text(colors.selectedTextColor),
      unselectedTextStyle: _text(colors.unselectedTextColor),
      hoveredTextStyle: _text(colors.hoveredTextColor),
      disabledTextStyle: _text(colors.disabledTextColor),
      iconSize: 20,
      // Count badge: Primary/main fill, white count.
      badgeColor: colors.focusColor,
      badgeTextStyle: _text(Colors.white).copyWith(fontSize: 11, height: 1),
      animationDuration: const Duration(milliseconds: 150),
    );
  }

  // @codescene(disable:"Excess Number of Function Arguments") mirrors every field
  LinagoraSegmentedTabsStyle copyWith({
    double? height,
    Color? trackColor,
    EdgeInsetsGeometry? trackPadding,
    double? segmentWidth,
    EdgeInsetsGeometry? segmentPadding,
    Color? selectedColor,
    List<BoxShadow>? selectedShadow,
    Color? focusColor,
    double? focusWidth,
    TextStyle? selectedTextStyle,
    TextStyle? unselectedTextStyle,
    TextStyle? hoveredTextStyle,
    TextStyle? disabledTextStyle,
    double? iconSize,
    Color? badgeColor,
    TextStyle? badgeTextStyle,
    Duration? animationDuration,
  }) =>
      LinagoraSegmentedTabsStyle(
        height: height ?? this.height,
        trackColor: trackColor ?? this.trackColor,
        trackPadding: trackPadding ?? this.trackPadding,
        segmentWidth: segmentWidth ?? this.segmentWidth,
        segmentPadding: segmentPadding ?? this.segmentPadding,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedShadow: selectedShadow ?? this.selectedShadow,
        focusColor: focusColor ?? this.focusColor,
        focusWidth: focusWidth ?? this.focusWidth,
        selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
        unselectedTextStyle: unselectedTextStyle ?? this.unselectedTextStyle,
        hoveredTextStyle: hoveredTextStyle ?? this.hoveredTextStyle,
        disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
        iconSize: iconSize ?? this.iconSize,
        badgeColor: badgeColor ?? this.badgeColor,
        badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
        animationDuration: animationDuration ?? this.animationDuration,
      );
}
