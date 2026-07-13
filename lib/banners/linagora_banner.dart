import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';

/// A full-width notification banner (e.g. "device out of sync") with a
/// leading icon, a message, and — when [actionLabel]/[onActionPressed] are
/// set — a trailing action button shown together with a dismiss (X) icon.
///
/// Adapts between the web layout (icon + message + trailing controls on one
/// row) and the mobile layout (icon + wrapping message, trailing controls
/// below) based on the available width rather than shipping as two
/// separate widgets.
class LinagoraBanner extends StatelessWidget {
  final String message;
  final IconData icon;

  /// Label for the trailing action button. Must be provided together with
  /// [onActionPressed] to show the button.
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  /// Shown as a trailing close (X) icon next to the action button.
  final VoidCallback? onDismiss;

  /// Minimum banner height. Defaults to `null`, letting the banner size
  /// itself to its content. When set, the banner is at least this tall but
  /// still grows beyond it if the message wraps to multiple lines, so
  /// content is never clipped.
  final double? height;

  const LinagoraBanner({
    super.key,
    required this.message,
    this.icon = Icons.error,
    this.actionLabel,
    this.onActionPressed,
    this.onDismiss,
    this.height,
  });

  bool get _hasAction => actionLabel != null && onActionPressed != null;

  bool get _hasDismiss => onDismiss != null;

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height ?? 0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          border: LinagoraDividerStyle.material().borderDecoration,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: LinagoraSpacing.base * 1.5,
          vertical: LinagoraSpacing.base / 2,
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildMessage(context, colors),
            ),
            if (_hasDismiss) _buildTrailing(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context, LinagoraSysColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: colors.error),
        const SizedBox(width: LinagoraSpacing.base),
        Flexible(
          child: Text(
            message,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.tertiary,
                ),
          ),
        ),
        const SizedBox(width: LinagoraSpacing.base),
        if (_hasAction)
          LinagoraButton(
            label: actionLabel!,
            onPressed: onActionPressed,
            size: LinagoraButtonSize.xs,
          ),
      ],
    );
  }

  Widget _buildTrailing(LinagoraSysColors colors) {
    return Padding(
      padding: const EdgeInsets.only(
        left: LinagoraSpacing.base,
      ),
      child: IconButton(
        icon: const Icon(Icons.close),
        iconSize: 24,
        color: colors.tertiary,
        tooltip: 'Dismiss',
        onPressed: onDismiss,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
