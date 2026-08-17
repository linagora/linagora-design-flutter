import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Ready-made [ButtonStyle]s for sidebar navigation actions.
abstract final class LinagoraSidebarButtonStyles {
  /// The primary sidebar action — Compose, Create, or New.
  static ButtonStyle primaryAction(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sidebar = LinagoraSidebarStyle.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark ? sidebar.activeForeground : colorScheme.primary;
    final foreground = isDark ? _darkForeground : colorScheme.onPrimary;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? colorScheme.onSurface.withValues(alpha: _disabledContainerOpacity)
            : background,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? colorScheme.onSurface.withValues(alpha: _disabledContentOpacity)
            : foreground,
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return null;
        if (states.contains(WidgetState.pressed)) {
          return foreground.withValues(alpha: _pressedOverlayOpacity);
        }
        if (states.contains(WidgetState.hovered)) {
          return foreground.withValues(alpha: _hoverOverlayOpacity);
        }
        if (states.contains(WidgetState.focused)) {
          return foreground.withValues(alpha: _pressedOverlayOpacity);
        }
        return null;
      }),
      iconSize: const WidgetStatePropertyAll(_iconSize),
      minimumSize: const WidgetStatePropertyAll(Size(0, _minHeight)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: LinagoraSpacing.base * 2,
          vertical: LinagoraSpacing.base,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      textStyle: WidgetStatePropertyAll(_primaryActionTextStyle()),
    );
  }

  /// Gap between the glyph and label of a [primaryAction] [LinagoraButton].
  static const double primaryActionIconSpacing = 7;

  static const double _minHeight = 40;
  static const double _borderRadius = 12;
  static const double _iconSize = 12;
  static const Color _darkForeground = Color(0xE61D212A);
  static const double _disabledContainerOpacity = 0.12;
  static const double _disabledContentOpacity = 0.38;
  static const double _hoverOverlayOpacity = 0.08;
  static const double _pressedOverlayOpacity = 0.12;
  static const double _lineHeight = 18.4;

  static TextStyle? _primaryActionTextStyle() {
    final base = LinagoraTextTheme.material().bodyMedium;
    final fontSize = base?.fontSize;
    if (fontSize == null) return base;
    return base?.copyWith(height: _lineHeight / fontSize);
  }
}
