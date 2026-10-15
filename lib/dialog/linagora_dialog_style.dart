import 'package:flutter/material.dart';

/// Design tokens for [LinagoraDialog].
///
/// Values come from the Figma `🔷 dialog` component (size=medium,
/// viewport=desktop), which only exists in light. [LinagoraDialog] takes a
/// `style` to override the whole set; use [copyWith] to change a few tokens.
@immutable
class LinagoraDialogStyle {
  static const String _package = 'linagora_design_flutter';
  static const String _fontFamily = 'TwakeInter';
  static const Color _primary = Color(0xFF0A84FF);
  static const Color _textColor = Color(0xE6424244);

  /// Scrim behind the dialog: `🔷 backdrop`, #1C1B1F at 40%.
  static const Color barrierColor = Color(0x661C1B1F);

  final Color surfaceColor;
  final double surfaceRadius;
  final List<BoxShadow> surfaceShadow;
  final double maxWidth;

  final EdgeInsetsGeometry headerPadding;

  /// Gap between the header's back button, title and close button.
  final double headerGap;
  final EdgeInsetsGeometry contentPadding;

  /// Gap between the message and the extra content.
  final double contentGap;

  /// Footer padding when the actions follow the content.
  final EdgeInsetsGeometry footerPadding;

  /// Footer padding when the actions sit under a divider
  /// (`fixed actions=true`).
  final EdgeInsetsGeometry fixedFooterPadding;
  final double actionGap;
  final Color dividerColor;

  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;
  final TextStyle actionTextStyle;

  final double iconButtonSize;
  final double iconSize;
  final Color iconColor;

  final double actionHeight;
  final EdgeInsetsGeometry actionPadding;
  final Color primaryActionColor;
  final Color primaryActionHoverColor;
  final Color destructiveActionColor;
  final Color onActionColor;

  const LinagoraDialogStyle({
    required this.surfaceColor,
    required this.surfaceRadius,
    required this.surfaceShadow,
    required this.maxWidth,
    required this.headerPadding,
    required this.headerGap,
    required this.contentPadding,
    required this.contentGap,
    required this.footerPadding,
    required this.fixedFooterPadding,
    required this.actionGap,
    required this.dividerColor,
    required this.titleTextStyle,
    required this.messageTextStyle,
    required this.actionTextStyle,
    required this.iconButtonSize,
    required this.iconSize,
    required this.iconColor,
    required this.actionHeight,
    required this.actionPadding,
    required this.primaryActionColor,
    required this.primaryActionHoverColor,
    required this.destructiveActionColor,
    required this.onActionColor,
  });

  static TextStyle _text(
    double size,
    double lineHeight,
    FontWeight weight,
    double letterSpacing,
    Color color,
  ) =>
      TextStyle(
        fontFamily: _fontFamily,
        package: _package,
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        color: color,
      );

  static final LinagoraDialogStyle _material = LinagoraDialogStyle(
    surfaceColor: Colors.white,
    surfaceRadius: 8,
    surfaceShadow: const [
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
    maxWidth: 544,
    headerPadding: const EdgeInsetsDirectional.symmetric(
      horizontal: 32,
      vertical: 8,
    ),
    headerGap: 4,
    contentPadding: const EdgeInsetsDirectional.symmetric(
      horizontal: 32,
      vertical: 24,
    ),
    contentGap: 16,
    footerPadding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 24),
    fixedFooterPadding: const EdgeInsetsDirectional.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
    actionGap: 8,
    dividerColor: const Color(0x1F1D192B),
    titleTextStyle: _text(22, 25.7, FontWeight.w600, 0, _textColor),
    messageTextStyle: _text(16, 21, FontWeight.w400, -0.15, _textColor),
    actionTextStyle: _text(14, 20, FontWeight.w500, 0.1, _primary),
    iconButtonSize: 40,
    iconSize: 24,
    iconColor: const Color(0xA3424244),
    actionHeight: 40,
    actionPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    primaryActionColor: _primary,
    primaryActionHoverColor: const Color(0xFF006BD8),
    destructiveActionColor: const Color(0xFFFF3347),
    onActionColor: Colors.white,
  );

  factory LinagoraDialogStyle.material() => _material;

  LinagoraDialogStyle copyWith({
    Color? surfaceColor,
    double? surfaceRadius,
    List<BoxShadow>? surfaceShadow,
    double? maxWidth,
    EdgeInsetsGeometry? headerPadding,
    double? headerGap,
    EdgeInsetsGeometry? contentPadding,
    double? contentGap,
    EdgeInsetsGeometry? footerPadding,
    EdgeInsetsGeometry? fixedFooterPadding,
    double? actionGap,
    Color? dividerColor,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    TextStyle? actionTextStyle,
    double? iconButtonSize,
    double? iconSize,
    Color? iconColor,
    double? actionHeight,
    EdgeInsetsGeometry? actionPadding,
    Color? primaryActionColor,
    Color? primaryActionHoverColor,
    Color? destructiveActionColor,
    Color? onActionColor,
  }) =>
      LinagoraDialogStyle(
        surfaceColor: surfaceColor ?? this.surfaceColor,
        surfaceRadius: surfaceRadius ?? this.surfaceRadius,
        surfaceShadow: surfaceShadow ?? this.surfaceShadow,
        maxWidth: maxWidth ?? this.maxWidth,
        headerPadding: headerPadding ?? this.headerPadding,
        headerGap: headerGap ?? this.headerGap,
        contentPadding: contentPadding ?? this.contentPadding,
        contentGap: contentGap ?? this.contentGap,
        footerPadding: footerPadding ?? this.footerPadding,
        fixedFooterPadding: fixedFooterPadding ?? this.fixedFooterPadding,
        actionGap: actionGap ?? this.actionGap,
        dividerColor: dividerColor ?? this.dividerColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        messageTextStyle: messageTextStyle ?? this.messageTextStyle,
        actionTextStyle: actionTextStyle ?? this.actionTextStyle,
        iconButtonSize: iconButtonSize ?? this.iconButtonSize,
        iconSize: iconSize ?? this.iconSize,
        iconColor: iconColor ?? this.iconColor,
        actionHeight: actionHeight ?? this.actionHeight,
        actionPadding: actionPadding ?? this.actionPadding,
        primaryActionColor: primaryActionColor ?? this.primaryActionColor,
        primaryActionHoverColor:
            primaryActionHoverColor ?? this.primaryActionHoverColor,
        destructiveActionColor:
            destructiveActionColor ?? this.destructiveActionColor,
        onActionColor: onActionColor ?? this.onActionColor,
      );
}
