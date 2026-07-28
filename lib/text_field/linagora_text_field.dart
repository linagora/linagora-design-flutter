import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_icon_button.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';
import 'package:linagora_design_flutter/text_field/linagora_text_field_variant.dart';

/// A Material 3 floating-label text field with the design system's
/// filled/outline configurations and error/supporting-text states.
///
/// Defaults come from the DS M3 tokens: [LinagoraSysColors.outline] border
/// (1px) and [LinagoraSysColors.error] border (2px) with a 4px radius, plus
/// [LinagoraTextTheme] typography for the label, input and hint. Every color,
/// style, width and radius is overridable for other contexts.
class LinagoraTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? supportingText;
  final String? errorText;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconPressed;

  /// Overrides [trailingIcon] with any widget (e.g. `SvgPicture.asset`,
  /// `Image.asset`) instead of the Material glyph. When set, [trailingIcon]
  /// is ignored for rendering.
  final Widget? trailingIconWidget;
  final bool obscureText;
  final bool enabled;
  final LinagoraTextFieldVariant variant;
  final ValueChanged<String>? onChanged;

  /// Placeholder text shown when the field is empty.
  final String? hintText;

  /// Style for [hintText]. Defaults to [LinagoraTextTheme] `bodyMedium`
  /// (matching the typed-input font) colored with [LinagoraSysColors.tertiary].
  final TextStyle? hintStyle;

  /// Style for the floating label in the default (non-error) state.
  /// Defaults to [LinagoraTextTheme] `bodyMedium` (matching the hint/input
  /// font) colored with [LinagoraSysColors.onSurface].
  final TextStyle? labelStyle;

  /// Style for the typed input text. Defaults to [LinagoraTextTheme]
  /// `bodyMedium` colored with [LinagoraSysColors.onSurface].
  final TextStyle? inputStyle;

  /// Border color for the default (non-error) state.
  /// Defaults to [LinagoraSysColors.outline].
  final Color? borderColor;

  /// Border, label and helper color applied when [errorText] is non-null.
  /// The error label/helper use [LinagoraTextTheme] `labelSmall`.
  /// Defaults to [LinagoraSysColors.error].
  final Color? errorBorderColor;

  /// Border width for the default (non-error) state.
  final double borderWidth;

  /// Border width applied when [errorText] is non-null.
  final double errorBorderWidth;

  /// Corner radius of the outline border.
  final double borderRadius;

  /// Optional heading shown above the field (e.g. a dialog/screen title).
  final String? title;

  /// Optional description shown below [title], above the field.
  final String? description;

  /// Overrides applied on top of the DS-built [InputDecoration]. Any non-null
  /// field here wins over the DS default (e.g. `contentPadding`, `prefixIcon`,
  /// `isDense`); unset fields keep the design-system styling.
  final InputDecoration? decoration;

  const LinagoraTextField({
    super.key,
    required this.label,
    this.controller,
    this.supportingText,
    this.errorText,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.trailingIconWidget,
    this.obscureText = false,
    this.enabled = true,
    this.variant = LinagoraTextFieldVariant.outline,
    this.onChanged,
    this.title,
    this.description,
    this.hintText,
    this.hintStyle,
    this.labelStyle,
    this.inputStyle,
    this.borderColor,
    this.errorBorderColor,
    this.borderWidth = 1,
    this.errorBorderWidth = 2,
    this.borderRadius = 4,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();

    // DS M3 color defaults; each is overridable.
    final effectiveBorderColor = borderColor ?? colors.outline;
    final effectiveErrorColor = errorBorderColor ?? colors.error;

    final defaultBorder = _border(effectiveBorderColor, borderWidth);
    final errorBorder = _border(effectiveErrorColor, errorBorderWidth);

    final textTheme = LinagoraTextTheme.material();

    // DS style/border/padding defaults as a theme. Flutter's
    // [InputDecoration.applyDefaults] fills any null field on the caller's
    // [decoration] from this — so the caller wins and we pick up new
    // InputDecoration fields for free. Content fields (labelText, hintText,
    // errorText, suffixIcon) can't live on a theme, so they're layered below.
    final dsTheme = InputDecorationTheme(
      // Hint: matches the typed-input font (M3 bodyMedium) colored with the
      // DS tertiary, so placeholder and typed text don't visibly change size.
      hintStyle:
          hintStyle ?? textTheme.bodyMedium?.copyWith(color: colors.tertiary),
      // Label: matches the hint/input font (M3 bodyMedium); error state
      // recolors it below.
      labelStyle:
          labelStyle ?? textTheme.bodyMedium?.copyWith(color: colors.onSurface),
      // On error the label/helper follow M3 labelSmall in the error color.
      errorStyle: textTheme.labelSmall?.copyWith(color: effectiveErrorColor),
      filled: variant == LinagoraTextFieldVariant.filled,
      fillColor: colors.surface,
      border: defaultBorder,
      enabledBorder: defaultBorder,
      focusedBorder: defaultBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
    );

    // Start from the caller override (or empty), apply DS style defaults, then
    // fill DS content fields only where the caller left them unset.
    final merged = (decoration ?? const InputDecoration()).applyDefaults(
      dsTheme,
    );
    final dsDecoration = merged.copyWith(
      labelText: merged.labelText ?? label,
      hintText: merged.hintText ?? hintText,
      helperText:
          merged.helperText ?? (errorText == null ? supportingText : null),
      errorText: merged.errorText ?? errorText,
      suffixIcon:
          merged.suffixIcon ??
          (trailingIcon == null && trailingIconWidget == null
              ? null
              : LinagoraIconButton(
                  icon: trailingIcon,
                  color: colors.onSurfaceVariant,
                  iconWidget: trailingIconWidget,
                  onPressed: onTrailingIconPressed,
                )),
    );

    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      // Input: M3 bodyMedium colored onSurface.
      style:
          inputStyle ?? textTheme.bodyMedium?.copyWith(color: colors.onSurface),
      decoration: dsDecoration,
    );

    return _maybeWrapWithHeader(context, field, colors);
  }

  /// Builds the variant-appropriate border with the given color and width.
  /// Outline borders honor [borderRadius]; underline borders ignore it.
  InputBorder _border(Color color, double width) {
    final side = BorderSide(color: color, width: width);
    return variant == LinagoraTextFieldVariant.outline
        ? OutlineInputBorder(
            borderSide: side,
            borderRadius: BorderRadius.circular(borderRadius),
          )
        : UnderlineInputBorder(borderSide: side);
  }

  /// Wraps [field] with the optional [title]/[description] header when set.
  Widget _maybeWrapWithHeader(
    BuildContext context,
    Widget field,
    LinagoraSysColors colors,
  ) {
    if (title == null && description == null) return field;

    // Header typography from the ambient theme so an app-provided text theme
    // wins: titleLarge for the heading, bodyMedium for the body.
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
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: LinagoraSpacing.base * 2),
        field,
      ],
    );
  }
}
