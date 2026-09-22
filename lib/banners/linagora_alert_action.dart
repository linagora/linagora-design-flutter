import 'package:flutter/material.dart';

/// One action rendered by an alert.
///
/// Grouping the label, callback and optional icon keeps an alert from being
/// configured with only half of an action. [onPressed] is required at the call
/// site but nullable, so a disabled action must be chosen explicitly and stays
/// visible instead of silently disappearing.
@immutable
class LinagoraAlertAction {
  final String label;

  /// Called when the action is activated. Null deliberately disables it.
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Replaces [icon] when both are supplied.
  final Widget? iconWidget;

  const LinagoraAlertAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconWidget,
  }) : assert(label != '', 'Action label cannot be empty');

  bool get hasIcon => icon != null || iconWidget != null;
}
