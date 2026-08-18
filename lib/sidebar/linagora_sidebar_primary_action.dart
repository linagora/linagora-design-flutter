import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_button_styles.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';

/// Ready-to-use primary action for a sidebar, such as Compose, Create or New.
///
/// Products supply their own localized label, icon and callback. The shared
/// control owns the sidebar button metrics, gap and default visual treatment.
class LinagoraSidebarPrimaryAction extends StatelessWidget {
  const LinagoraSidebarPrimaryAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.style,
    this.sidebarStyle,
    this.iconSpacing = LinagoraSidebarButtonStyles.primaryActionIconSpacing,
    this.outerPadding,
    this.width,
    this.constraints,
    this.alignment,
    this.buttonKey,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Replaces [icon] when both are supplied.
  final Widget? iconWidget;

  /// Overrides the default [LinagoraSidebarButtonStyles.primaryAction] style.
  final ButtonStyle? style;
  final LinagoraSidebarStyle? sidebarStyle;
  final double iconSpacing;
  final EdgeInsetsGeometry? outerPadding;
  final double? width;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) => LinagoraButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    iconWidget: iconWidget,
    iconSpacing: iconSpacing,
    outerPadding: outerPadding,
    width: width,
    constraints: constraints,
    alignment: alignment,
    buttonKey: buttonKey,
    style:
        style ??
        LinagoraSidebarButtonStyles.primaryAction(
          context,
          sidebarStyle: sidebarStyle,
        ),
  );
}
