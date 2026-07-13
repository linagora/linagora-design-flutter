import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/text_field/linagora_text_field_variant.dart';

/// A Material 3 floating-label text field with the design system's
/// filled/outline configurations and error/supporting-text states.
class LinagoraTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? supportingText;
  final String? errorText;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconPressed;
  final bool obscureText;
  final bool enabled;
  final LinagoraTextFieldVariant variant;
  final ValueChanged<String>? onChanged;

  /// Optional heading shown above the field (e.g. a dialog/screen title).
  final String? title;

  /// Optional description shown below [title], above the field.
  final String? description;

  const LinagoraTextField({
    super.key,
    required this.label,
    this.controller,
    this.supportingText,
    this.errorText,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.obscureText = false,
    this.enabled = true,
    this.variant = LinagoraTextFieldVariant.outline,
    this.onChanged,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();

    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.onSurface,
          ),
      decoration: InputDecoration(
        labelText: label,
        helperText: errorText == null ? supportingText : null,
        errorText: errorText,
        filled: variant == LinagoraTextFieldVariant.filled,
        fillColor: colors.surface,
        suffixIcon: trailingIcon == null
            ? null
            : IconButton(
                icon: Icon(trailingIcon),
                onPressed: onTrailingIconPressed,
              ),
        border: variant == LinagoraTextFieldVariant.outline
            ? const OutlineInputBorder()
            : const UnderlineInputBorder(),
      ),
    );

    if (title == null && description == null) return field;

    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: textTheme.titleLarge?.copyWith(color: colors.onSurface),
          ),
        if (description != null) ...[
          const SizedBox(height: LinagoraSpacing.base),
          Text(
            description!,
            style:
                textTheme.labelLarge?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: LinagoraSpacing.base * 2),
        field,
      ],
    );
  }
}
