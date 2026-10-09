import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_layout.dart';

/// Design tokens for the file transfer dialog and its rows.
///
/// Values come from the Figma "Attaching file" frames (web 9929-5510, mobile
/// 12004-18682), which only exist in light. Widgets take a `style` to override
/// the whole set; use [copyWith] to change a few tokens.
@immutable
class LinagoraFileTransferStyle {
  static const String _package = 'linagora_design_flutter';
  static const String _fontFamily = 'TwakeInter';
  static const Color _primary = Color(0xFF0A84FF);
  static const Color _titleColor = Color(0xE6424244);
  static const Color _secondaryText = Color(0xFF737373);

  final Color surfaceColor;
  final double surfaceRadius;
  final List<BoxShadow> surfaceShadow;
  final double maxWidth;

  /// The list scrolls once the rows outgrow this height.
  final double maxListHeight;

  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry descriptionPadding;
  final EdgeInsetsGeometry rowPadding;
  final EdgeInsetsGeometry cancelPadding;
  /// Padding around the footer Cancel, separate from the header's.
  final EdgeInsetsGeometry footerPadding;

  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;

  /// Merged over [bodyTextStyle] for the emphasised run of the description.
  final TextStyle emphasisTextStyle;
  final TextStyle statusTextStyle;

  /// Wide enough for the longest terminal label ("Cancelled"), so labels
  /// swapping in and out do not move the bar.
  final double statusLabelWidth;
  final TextStyle fileNameTextStyle;
  final TextStyle cancelTextStyle;

  final double chipWidth;
  final double chipRadius;
  final EdgeInsetsGeometry chipPadding;
  final Color chipBackgroundColor;
  final Color chipBorderColor;

  final double barHeight;
  final double barRadius;
  final Color barTrackColor;
  final Color barColor;
  final Duration progressAnimationDuration;

  /// Inset of the bar under the row in the compact layout.
  final EdgeInsetsGeometry compactBarPadding;

  /// Vertical gap between the row and its bar in the compact layout.
  final double compactBarGap;

  /// Gap between the chip and the status label (wide).
  final double itemGap;
  /// Gap after the status label: before the bar (wide) or the close (compact).
  final double labelTrailingGap;
  /// Gap between the wide bar and the row close.
  final double barEndGap;
  final double closeButtonSize;
  final double rowCloseIconSize;
  final double headerCloseIconSize;
  /// Tint of the row and header ✕, which the asset would otherwise draw blue-grey.
  final Color closeIconColor;

  const LinagoraFileTransferStyle({
    required this.surfaceColor,
    required this.surfaceRadius,
    required this.surfaceShadow,
    required this.maxWidth,
    required this.maxListHeight,
    required this.headerPadding,
    required this.descriptionPadding,
    required this.rowPadding,
    required this.cancelPadding,
    required this.footerPadding,
    required this.titleTextStyle,
    required this.bodyTextStyle,
    required this.emphasisTextStyle,
    required this.statusTextStyle,
    required this.statusLabelWidth,
    required this.fileNameTextStyle,
    required this.cancelTextStyle,
    required this.chipWidth,
    required this.chipRadius,
    required this.chipPadding,
    required this.chipBackgroundColor,
    required this.chipBorderColor,
    required this.barHeight,
    required this.barRadius,
    required this.barTrackColor,
    required this.barColor,
    required this.progressAnimationDuration,
    required this.compactBarPadding,
    required this.compactBarGap,
    required this.itemGap,
    required this.labelTrailingGap,
    required this.barEndGap,
    required this.closeButtonSize,
    required this.rowCloseIconSize,
    required this.headerCloseIconSize,
    required this.closeIconColor,
  });

  static const TextStyle _baseText = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
  );

  static TextStyle _text(
    double size,
    double lineHeight,
    FontWeight weight,
    Color color,
  ) =>
      _baseText.copyWith(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        color: color,
      );

  static final TextStyle _body = _text(16, 20, FontWeight.w500, _secondaryText);

  static final TextStyle _label = _text(
    14,
    20,
    FontWeight.w500,
    const Color(0xFF1C1B1F),
  ).copyWith(letterSpacing: 0.1);

  static final LinagoraFileTransferStyle _wide = LinagoraFileTransferStyle(
    surfaceColor: Colors.white,
    surfaceRadius: 6,
    surfaceShadow: const [
      BoxShadow(
        color: Color(0x3D424244),
        offset: Offset(0, 12),
        blurRadius: 16,
        spreadRadius: -8,
      ),
      BoxShadow(
        color: Color(0x3D424244),
        offset: Offset(0, 12),
        blurRadius: 48,
        spreadRadius: 8,
      ),
      BoxShadow(color: Color(0x1F424244), spreadRadius: 0.5),
    ],
    maxWidth: 527,
    maxListHeight: 264,
    headerPadding: const EdgeInsetsDirectional.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    descriptionPadding: const EdgeInsetsDirectional.only(
      start: 16,
      end: 24,
      bottom: 8,
    ),
    rowPadding: const EdgeInsetsDirectional.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    cancelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    footerPadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
    titleTextStyle: _text(24, 28, FontWeight.w600, _titleColor),
    bodyTextStyle: _body,
    emphasisTextStyle: const TextStyle(color: Color(0xFF0C0C0C)),
    statusTextStyle: _body,
    statusLabelWidth: 88,
    fileNameTextStyle: _label,
    cancelTextStyle: _label.copyWith(color: _primary),
    chipWidth: 191,
    chipRadius: 8,
    chipPadding: const EdgeInsets.all(8),
    chipBackgroundColor: Colors.white,
    chipBorderColor: const Color(0xFFE5ECF3),
    barHeight: 6,
    barRadius: 26,
    barTrackColor: const Color(0xFFD9D9D9),
    barColor: _primary,
    progressAnimationDuration: const Duration(milliseconds: 250),
    compactBarPadding: const EdgeInsetsDirectional.only(start: 8),
    compactBarGap: 8,
    itemGap: 30,
    labelTrailingGap: 0,
    barEndGap: 9,
    closeButtonSize: 40,
    rowCloseIconSize: 16,
    headerCloseIconSize: 24,
    closeIconColor: const Color(0xA3424244),
  );

  /// Mobile sheet: rounder surface, smaller title and status label.
  static final LinagoraFileTransferStyle _compact = _wide.copyWith(
    surfaceRadius: 14,
    titleTextStyle: _text(16, 21, FontWeight.w600, _titleColor)
        .copyWith(letterSpacing: 0.15),
    statusTextStyle: _text(13, 16, FontWeight.w400, _secondaryText),
    statusLabelWidth: 64,
    headerPadding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
    descriptionPadding: const EdgeInsetsDirectional.only(start: 16, end: 24),
    footerPadding: const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 8),
    labelTrailingGap: 6,
  );

  factory LinagoraFileTransferStyle.wide() => _wide;

  factory LinagoraFileTransferStyle.compact() => _compact;

  factory LinagoraFileTransferStyle.forLayout(
    LinagoraFileTransferLayout layout,
  ) =>
      layout == LinagoraFileTransferLayout.wide ? _wide : _compact;

  LinagoraFileTransferStyle copyWith({
    Color? surfaceColor,
    double? surfaceRadius,
    List<BoxShadow>? surfaceShadow,
    double? maxWidth,
    double? maxListHeight,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? descriptionPadding,
    EdgeInsetsGeometry? rowPadding,
    EdgeInsetsGeometry? cancelPadding,
    EdgeInsetsGeometry? footerPadding,
    TextStyle? titleTextStyle,
    TextStyle? bodyTextStyle,
    TextStyle? emphasisTextStyle,
    TextStyle? statusTextStyle,
    double? statusLabelWidth,
    TextStyle? fileNameTextStyle,
    TextStyle? cancelTextStyle,
    double? chipWidth,
    double? chipRadius,
    EdgeInsetsGeometry? chipPadding,
    Color? chipBackgroundColor,
    Color? chipBorderColor,
    double? barHeight,
    double? barRadius,
    Color? barTrackColor,
    Color? barColor,
    Duration? progressAnimationDuration,
    EdgeInsetsGeometry? compactBarPadding,
    double? compactBarGap,
    double? itemGap,
    double? labelTrailingGap,
    double? barEndGap,
    double? closeButtonSize,
    double? rowCloseIconSize,
    double? headerCloseIconSize,
    Color? closeIconColor,
  }) =>
      LinagoraFileTransferStyle(
        surfaceColor: surfaceColor ?? this.surfaceColor,
        surfaceRadius: surfaceRadius ?? this.surfaceRadius,
        surfaceShadow: surfaceShadow ?? this.surfaceShadow,
        maxWidth: maxWidth ?? this.maxWidth,
        maxListHeight: maxListHeight ?? this.maxListHeight,
        headerPadding: headerPadding ?? this.headerPadding,
        descriptionPadding: descriptionPadding ?? this.descriptionPadding,
        rowPadding: rowPadding ?? this.rowPadding,
        cancelPadding: cancelPadding ?? this.cancelPadding,
        footerPadding: footerPadding ?? this.footerPadding,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
        emphasisTextStyle: emphasisTextStyle ?? this.emphasisTextStyle,
        statusTextStyle: statusTextStyle ?? this.statusTextStyle,
        statusLabelWidth: statusLabelWidth ?? this.statusLabelWidth,
        fileNameTextStyle: fileNameTextStyle ?? this.fileNameTextStyle,
        cancelTextStyle: cancelTextStyle ?? this.cancelTextStyle,
        chipWidth: chipWidth ?? this.chipWidth,
        chipRadius: chipRadius ?? this.chipRadius,
        chipPadding: chipPadding ?? this.chipPadding,
        chipBackgroundColor: chipBackgroundColor ?? this.chipBackgroundColor,
        chipBorderColor: chipBorderColor ?? this.chipBorderColor,
        barHeight: barHeight ?? this.barHeight,
        barRadius: barRadius ?? this.barRadius,
        barTrackColor: barTrackColor ?? this.barTrackColor,
        barColor: barColor ?? this.barColor,
        progressAnimationDuration:
            progressAnimationDuration ?? this.progressAnimationDuration,
        compactBarPadding: compactBarPadding ?? this.compactBarPadding,
        compactBarGap: compactBarGap ?? this.compactBarGap,
        itemGap: itemGap ?? this.itemGap,
        labelTrailingGap: labelTrailingGap ?? this.labelTrailingGap,
        barEndGap: barEndGap ?? this.barEndGap,
        closeButtonSize: closeButtonSize ?? this.closeButtonSize,
        rowCloseIconSize: rowCloseIconSize ?? this.rowCloseIconSize,
        headerCloseIconSize: headerCloseIconSize ?? this.headerCloseIconSize,
        closeIconColor: closeIconColor ?? this.closeIconColor,
      );

  List<Object> get _props => [
        surfaceColor,
        surfaceRadius,
        Object.hashAll(surfaceShadow),
        maxWidth,
        maxListHeight,
        headerPadding,
        descriptionPadding,
        rowPadding,
        cancelPadding,
        footerPadding,
        titleTextStyle,
        bodyTextStyle,
        emphasisTextStyle,
        statusTextStyle,
        statusLabelWidth,
        fileNameTextStyle,
        cancelTextStyle,
        chipWidth,
        chipRadius,
        chipPadding,
        chipBackgroundColor,
        chipBorderColor,
        barHeight,
        barRadius,
        barTrackColor,
        barColor,
        progressAnimationDuration,
        compactBarPadding,
        compactBarGap,
        itemGap,
        labelTrailingGap,
        barEndGap,
        closeButtonSize,
        rowCloseIconSize,
        headerCloseIconSize,
        closeIconColor,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinagoraFileTransferStyle &&
          listEquals(_props, other._props);

  @override
  int get hashCode => Object.hashAll(_props);
}
