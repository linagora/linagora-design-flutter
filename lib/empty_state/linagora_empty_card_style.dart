import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Tokens for [LinagoraEmptyCard].
///
/// The card is short and bordered. The action is a filled pill (blue on light,
/// soft blue on dark) with a contrasting label.
@immutable
class LinagoraEmptyCardStyle {
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final double radius;

  /// Space around the illustration.
  final EdgeInsetsGeometry illustrationPadding;

  /// Gap between the illustration and the title.
  final double illustrationGap;

  /// Gap between the title and the message.
  final double messageGap;

  /// Extra inset of the message, on top of [padding].
  final EdgeInsetsGeometry messagePadding;

  /// Space above the action (the card [padding] already insets the bottom).
  final EdgeInsetsGeometry actionPadding;

  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;

  /// Floor for the action button height (hug / min 48).
  final double actionHeight;

  /// Inner padding of the action pill (`32` × `14`).
  final EdgeInsetsGeometry actionButtonPadding;

  /// Leading icon of the action (`20`).
  final double actionIconSize;

  /// Fill of an enabled action.
  final Color actionBackgroundColor;

  /// Label colour of an enabled action.
  final Color actionForegroundColor;

  /// Fill of a disabled action (`onPressed` null).
  final Color actionDisabledBackgroundColor;

  /// Label colour of a disabled action (`onPressed` null).
  final Color actionDisabledForegroundColor;

  const LinagoraEmptyCardStyle({
    required this.padding,
    required this.backgroundColor,
    required this.borderColor,
    required this.radius,
    required this.illustrationPadding,
    required this.illustrationGap,
    required this.messageGap,
    required this.messagePadding,
    required this.actionPadding,
    required this.titleTextStyle,
    required this.messageTextStyle,
    required this.actionHeight,
    required this.actionButtonPadding,
    required this.actionIconSize,
    required this.actionBackgroundColor,
    required this.actionForegroundColor,
    required this.actionDisabledBackgroundColor,
    required this.actionDisabledForegroundColor,
  });

  static final LinagoraEmptyCardStyle _material = _build((
    backgroundColor: Colors.white,
    borderColor: const Color(0x29424242),
    titleColor: const Color(0xE5424244),
    messageColor: const Color(0xA3424244),
    actionBackgroundColor: const Color(0xFF0A84FF),
    actionForegroundColor: Colors.white,
    actionDisabledBackgroundColor: const Color(0x610A84FF),
    actionDisabledForegroundColor: const Color(0x61FFFFFF),
  ));

  static final LinagoraEmptyCardStyle _dark = _build((
    backgroundColor: const Color(0xFF3E424A),
    borderColor: const Color(0x29FFFFFF),
    titleColor: Colors.white,
    messageColor: const Color(0xA3FFFFFF),
    actionBackgroundColor: const Color(0xFF91BFFF),
    actionForegroundColor: const Color(0xFF424244),
    actionDisabledBackgroundColor: const Color(0x6191BFFF),
    actionDisabledForegroundColor: const Color(0x61424244),
  ));

  factory LinagoraEmptyCardStyle.material() => _material;

  factory LinagoraEmptyCardStyle.dark() => _dark;

  static LinagoraEmptyCardStyle _build(
    ({
      Color backgroundColor,
      Color borderColor,
      Color titleColor,
      Color messageColor,
      Color actionBackgroundColor,
      Color actionForegroundColor,
      Color actionDisabledBackgroundColor,
      Color actionDisabledForegroundColor,
    }) colors,
  ) {
    final text = LinagoraTextTheme.material();
    return LinagoraEmptyCardStyle(
      // Empty card: 16 inset from the border, 16 radius, 8 content gap.
      padding: const EdgeInsets.all(16),
      backgroundColor: colors.backgroundColor,
      borderColor: colors.borderColor,
      radius: 16,
      illustrationPadding: EdgeInsets.zero,
      illustrationGap: 8,
      messageGap: 8,
      messagePadding: EdgeInsets.zero,
      actionPadding: const EdgeInsets.only(top: 8),
      // Title: Inter 500 / 16 / 24 / 0.15. Message: Inter 500 / 14 / 20 / 0.25.
      titleTextStyle: text.titleMedium!.copyWith(color: colors.titleColor),
      messageTextStyle: text.bodyMedium!.copyWith(color: colors.messageColor),
      actionHeight: 48,
      actionButtonPadding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 14,
      ),
      actionIconSize: 20,
      actionBackgroundColor: colors.actionBackgroundColor,
      actionForegroundColor: colors.actionForegroundColor,
      actionDisabledBackgroundColor: colors.actionDisabledBackgroundColor,
      actionDisabledForegroundColor: colors.actionDisabledForegroundColor,
    );
  }

  // @codescene(disable:"Excess Number of Function Arguments") mirrors every field
  LinagoraEmptyCardStyle copyWith({
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? borderColor,
    double? radius,
    EdgeInsetsGeometry? illustrationPadding,
    double? illustrationGap,
    double? messageGap,
    EdgeInsetsGeometry? messagePadding,
    EdgeInsetsGeometry? actionPadding,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    double? actionHeight,
    EdgeInsetsGeometry? actionButtonPadding,
    double? actionIconSize,
    Color? actionBackgroundColor,
    Color? actionForegroundColor,
    Color? actionDisabledBackgroundColor,
    Color? actionDisabledForegroundColor,
  }) {
    return LinagoraEmptyCardStyle(
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      radius: radius ?? this.radius,
      illustrationPadding: illustrationPadding ?? this.illustrationPadding,
      illustrationGap: illustrationGap ?? this.illustrationGap,
      messageGap: messageGap ?? this.messageGap,
      messagePadding: messagePadding ?? this.messagePadding,
      actionPadding: actionPadding ?? this.actionPadding,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
      actionHeight: actionHeight ?? this.actionHeight,
      actionButtonPadding: actionButtonPadding ?? this.actionButtonPadding,
      actionIconSize: actionIconSize ?? this.actionIconSize,
      actionBackgroundColor:
          actionBackgroundColor ?? this.actionBackgroundColor,
      actionForegroundColor:
          actionForegroundColor ?? this.actionForegroundColor,
      actionDisabledBackgroundColor: actionDisabledBackgroundColor ??
          this.actionDisabledBackgroundColor,
      actionDisabledForegroundColor: actionDisabledForegroundColor ??
          this.actionDisabledForegroundColor,
    );
  }
}
