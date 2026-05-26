import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacings.dart';

class LinagoraButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LinagoraButtonSize size;
  final LinagoraButtonVariant variant;

  const LinagoraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = LinagoraButtonSize.s,
    this.variant = LinagoraButtonVariant.filled,
  });

  @override
  Widget build(BuildContext context) {
    final style = _buildStyle(context);
    final child = _buildChild();

    return switch (variant) {
      LinagoraButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          style: style,
          child: child,
        ),
      LinagoraButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        ),
    };
  }

  Widget _buildChild() {
    if (icon == null) {
      return Text(label);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(width: LinagoraSpacings.s8),
        Text(label),
      ],
    );
  }

  ButtonStyle _buildStyle(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    var style = ButtonStyle(
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      iconSize: const WidgetStatePropertyAll(20),
      side: variant == LinagoraButtonVariant.outlined
          ? WidgetStatePropertyAll(BorderSide(color: primary))
          : null,
    );

    if (size == LinagoraButtonSize.xs) {
      style = style.copyWith(
        minimumSize: const WidgetStatePropertyAll(Size(0, 32)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: LinagoraSpacings.s12,
            vertical: LinagoraSpacings.s6,
          ),
        ),
      );
    }

    return style;
  }
}
