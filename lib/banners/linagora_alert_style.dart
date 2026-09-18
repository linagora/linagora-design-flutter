import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// Severity of a [LinagoraAlert], which picks its accent colour and the
/// default leading glyph.
enum LinagoraAlertColor {
  primary,
  secondary,
  error,
  warning,
  success,
}

/// How a [LinagoraAlert] draws its container.
enum LinagoraAlertVariant {
  /// No container of its own — the alert sits directly on the surface
  /// behind it, carrying only its accent icon and text.
  standard,

  /// Accent-tinted container.
  filled,
}

/// Vertical rhythm of a [LinagoraAlert]'s text block.
enum LinagoraAlertSize {
  /// Roomier leading around the title and message.
  normal,

  /// Tighter leading, for an alert stacked among dense content.
  compact,
}

/// Vertical placement of the trailing action cluster. The leading icon and
/// the text always align to the first line, independently of this.
enum LinagoraAlertActionsAlignment {
  top,
  center,
  bottom,
}

/// Horizontal alignment of the title and message within the text block.
enum LinagoraAlertTextAlignment {
  start,
  center,
}

/// Spacing a [LinagoraAlertSize] resolves to.
class LinagoraAlertMetrics {
  /// Inset above and below the text block.
  final double textVerticalPadding;

  /// Space between the title and the message.
  final double textSpacing;

  /// Drop of the leading icon from the content's top edge, which lands it
  /// optically centred on the first line of text.
  final double iconTopPadding;

  const LinagoraAlertMetrics({
    required this.textVerticalPadding,
    required this.textSpacing,
    required this.iconTopPadding,
  });

  factory LinagoraAlertMetrics.resolve(LinagoraAlertSize size) {
    return switch (size) {
      LinagoraAlertSize.normal => const LinagoraAlertMetrics(
          textVerticalPadding: LinagoraSpacing.base,
          textSpacing: LinagoraSpacing.base,
          iconTopPadding: 10,
        ),
      LinagoraAlertSize.compact => const LinagoraAlertMetrics(
          textVerticalPadding: LinagoraSpacing.base / 2,
          textSpacing: LinagoraSpacing.base / 2,
          iconTopPadding: 6,
        ),
    };
  }
}

/// Colours a [LinagoraAlertColor] resolves to for a given [Brightness].
///
/// Exposed so a product can tint a neighbouring surface — an inline notice,
/// an attachment strip — to match the alert beside it, instead of
/// re-deriving the opacities by hand.
class LinagoraAlertPalette {
  /// Fill opacity of a [LinagoraAlertVariant.filled] container.
  static const double containerOpacity = 0.12;

  /// Fill opacity of the action button at rest.
  static const double actionOpacity = 0.04;

  /// Fill opacity of the action button while hovered, focused, or pressed.
  static const double actionHoverOpacity = 0.12;

  /// Opacity the title and message take from the text colour.
  static const double foregroundOpacity = 0.9;

  /// Opacity the dismiss glyph takes from the text colour — lighter than the
  /// text, so it reads as a control rather than as content.
  static const double closeOpacity = 0.64;

  /// Text colour on a light surface, before [foregroundOpacity].
  static const Color lightTextColor = Color(0xFF424244);

  /// Drives the icon, the action label, and every tint.
  final Color accent;

  /// Container fill. Transparent for [LinagoraAlertVariant.standard].
  final Color background;

  /// Title and message colour.
  final Color foreground;

  /// Dismiss glyph colour.
  final Color closeForeground;

  const LinagoraAlertPalette({
    required this.accent,
    required this.background,
    required this.foreground,
    required this.closeForeground,
  });

  /// Resolves [color] against [brightness], honouring [variant] for the
  /// container fill.
  ///
  /// [onSurface] supplies the text colour on a dark surface, where the light
  /// token would fall below the contrast floor.
  factory LinagoraAlertPalette.resolve(
    LinagoraAlertColor color, {
    Brightness brightness = Brightness.light,
    LinagoraAlertVariant variant = LinagoraAlertVariant.filled,
    Color? onSurface,
  }) {
    final accent = _accentOf(color, brightness);
    final text = brightness == Brightness.light
        ? lightTextColor
        : onSurface ?? LinagoraSysColors.material().onSurfaceDark;
    return LinagoraAlertPalette(
      accent: accent,
      background: variant == LinagoraAlertVariant.filled
          ? accent.withValues(alpha: containerOpacity)
          : Colors.transparent,
      foreground: text.withValues(alpha: foregroundOpacity),
      closeForeground: text.withValues(alpha: closeOpacity),
    );
  }

  /// Fill of the action button, layered over [background].
  Color get actionBackground => accent.withValues(alpha: actionOpacity);

  /// Fill of the action button while hovered, focused, or pressed.
  Color get actionHoverBackground =>
      accent.withValues(alpha: actionHoverOpacity);

  static Color _accentOf(LinagoraAlertColor color, Brightness brightness) {
    final colors = LinagoraSysColors.material();
    final isLight = brightness == Brightness.light;
    return switch (color) {
      LinagoraAlertColor.primary =>
        isLight ? colors.primary : colors.primaryDark,
      LinagoraAlertColor.secondary =>
        isLight ? colors.secondary : colors.secondaryDark,
      LinagoraAlertColor.error => isLight ? colors.error : colors.errorDark,
      LinagoraAlertColor.warning =>
        isLight ? colors.warning : colors.warningDark,
      LinagoraAlertColor.success =>
        isLight ? colors.success : colors.successDark,
    };
  }
}
