import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

class LinagoraButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LinagoraButtonSize size;
  final LinagoraButtonVariant variant;

  /// Visual properties that override the variant and size defaults.
  final ButtonStyle? style;

  /// Space between [icon] and [label].
  final double iconSpacing;

  const LinagoraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = LinagoraButtonSize.m,
    this.variant = LinagoraButtonVariant.filled,
    this.style,
    this.iconSpacing = LinagoraSpacing.base,
  }) : assert(iconSpacing >= 0, 'Icon spacing cannot be negative');

  @override
  Widget build(BuildContext context) {
    final defaultStyle = _buildStyle(context);
    // Caller values take precedence over the defaults.
    final buttonStyle = style?.merge(defaultStyle) ?? defaultStyle;
    final child = _buildChild();

    return switch (variant) {
      LinagoraButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        ),
      LinagoraButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        ),
      LinagoraButtonVariant.text => TextButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        ),
    };
  }

  Widget _buildChild() {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    if (icon == null) {
      return text;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        SizedBox(width: iconSpacing),
        Flexible(child: text),
      ],
    );
  }

  ButtonStyle _buildStyle(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ButtonStyle(
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      iconSize: const WidgetStatePropertyAll(20),
      side: variant == LinagoraButtonVariant.outlined
          ? WidgetStatePropertyAll(BorderSide(color: primary))
          : null,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: WidgetStatePropertyAll(
        switch (size) {
          LinagoraButtonSize.xs => const Size(0, 32),
          LinagoraButtonSize.m => const Size(0, 48),
        },
      ),
      padding: WidgetStatePropertyAll(
        switch (size) {
          LinagoraButtonSize.xs => const EdgeInsets.symmetric(
              horizontal: LinagoraSpacing.base * 1.5,
              vertical: 6,
            ),
          LinagoraButtonSize.m => const EdgeInsets.symmetric(
              horizontal: LinagoraSpacing.base * 3,
              vertical: LinagoraSpacing.base * 1.5,
            ),
        },
      ),
    );
  }
}
