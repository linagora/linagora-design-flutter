import 'package:flutter/material.dart';

/// Merges caller-supplied [InputDecoration] overrides over a base decoration.
extension InputDecorationMerge on InputDecoration {
  /// Layers [over] on top of this base decoration. Each field is taken from
  /// [over] when non-null, otherwise kept from the base, so callers override
  /// only what they need without losing the base (design-system) defaults.
  ///
  /// Returns the base unchanged when [over] is null.
  InputDecoration mergeWith(InputDecoration? over) {
    if (over == null) return this;
    return copyWith(
      icon: over.icon,
      label: over.label,
      labelText: over.labelText ?? labelText,
      labelStyle: over.labelStyle ?? labelStyle,
      floatingLabelStyle: over.floatingLabelStyle,
      helperText: over.helperText ?? helperText,
      helperStyle: over.helperStyle,
      helperMaxLines: over.helperMaxLines,
      hintText: over.hintText ?? hintText,
      hintStyle: over.hintStyle ?? hintStyle,
      hintMaxLines: over.hintMaxLines,
      errorText: over.errorText ?? errorText,
      errorStyle: over.errorStyle ?? errorStyle,
      errorMaxLines: over.errorMaxLines,
      floatingLabelBehavior: over.floatingLabelBehavior,
      isDense: over.isDense,
      contentPadding: over.contentPadding,
      prefixIcon: over.prefixIcon,
      prefix: over.prefix,
      prefixText: over.prefixText,
      prefixStyle: over.prefixStyle,
      suffixIcon: over.suffixIcon ?? suffixIcon,
      suffix: over.suffix,
      suffixText: over.suffixText,
      suffixStyle: over.suffixStyle,
      counterText: over.counterText,
      counterStyle: over.counterStyle,
      filled: over.filled ?? filled,
      fillColor: over.fillColor ?? fillColor,
      focusColor: over.focusColor,
      hoverColor: over.hoverColor,
      errorBorder: over.errorBorder ?? errorBorder,
      focusedBorder: over.focusedBorder ?? focusedBorder,
      focusedErrorBorder: over.focusedErrorBorder ?? focusedErrorBorder,
      disabledBorder: over.disabledBorder,
      enabledBorder: over.enabledBorder ?? enabledBorder,
      border: over.border ?? border,
      enabled: over.enabled,
      semanticCounterText: over.semanticCounterText,
      alignLabelWithHint: over.alignLabelWithHint,
      constraints: over.constraints,
    );
  }
}
