import 'package:flutter/material.dart';

/// A main colour with its darker and lighter shades and the text drawn on it.
class TwakeUiPalette {
  const TwakeUiPalette({
    required this.main,
    required this.dark,
    required this.light,
    required this.contrastText,
  });

  final Color main;
  final Color dark;
  final Color light;
  final Color contrastText;

  TwakeUiPalette _lerpTo(TwakeUiPalette o, double t) => TwakeUiPalette(
    main: Color.lerp(main, o.main, t)!,
    dark: Color.lerp(dark, o.dark, t)!,
    light: Color.lerp(light, o.light, t)!,
    contrastText: Color.lerp(contrastText, o.contrastText, t)!,
  );
}

/// A status colour (error, warning, success, info) and its text colour.
class TwakeUiStatusColor {
  const TwakeUiStatusColor({required this.main, required this.contrastText});

  final Color main;
  final Color contrastText;

  TwakeUiStatusColor _lerpTo(TwakeUiStatusColor o, double t) =>
      TwakeUiStatusColor(
        main: Color.lerp(main, o.main, t)!,
        contrastText: Color.lerp(contrastText, o.contrastText, t)!,
      );
}

/// Surface colours: `background.default` and `background.paper`.
class TwakeUiBackgroundColors {
  const TwakeUiBackgroundColors({
    required this.defaultColor,
    required this.paper,
  });

  final Color defaultColor;
  final Color paper;

  TwakeUiBackgroundColors _lerpTo(TwakeUiBackgroundColors o, double t) =>
      TwakeUiBackgroundColors(
        defaultColor: Color.lerp(defaultColor, o.defaultColor, t)!,
        paper: Color.lerp(paper, o.paper, t)!,
      );
}

/// Text colours: `text.primary`, `secondary`, `disabled` and `icon`.
class TwakeUiTextColors {
  const TwakeUiTextColors({
    required this.primary,
    required this.secondary,
    required this.disabled,
    required this.icon,
  });

  final Color primary;
  final Color secondary;
  final Color disabled;
  final Color icon;

  TwakeUiTextColors _lerpTo(TwakeUiTextColors o, double t) => TwakeUiTextColors(
    primary: Color.lerp(primary, o.primary, t)!,
    secondary: Color.lerp(secondary, o.secondary, t)!,
    disabled: Color.lerp(disabled, o.disabled, t)!,
    icon: Color.lerp(icon, o.icon, t)!,
  );
}

/// The `border` palette entry.
class TwakeUiBorderColors {
  const TwakeUiBorderColors({required this.main});

  final Color main;

  TwakeUiBorderColors _lerpTo(TwakeUiBorderColors o, double t) =>
      TwakeUiBorderColors(main: Color.lerp(main, o.main, t)!);
}

/// Interaction overlays: the `action` palette entry.
class TwakeUiActionColors {
  const TwakeUiActionColors({
    required this.hover,
    required this.selected,
    required this.focus,
    required this.disabled,
    required this.disabledBackground,
  });

  final Color hover;
  final Color selected;
  final Color focus;
  final Color disabled;
  final Color disabledBackground;

  TwakeUiActionColors _lerpTo(TwakeUiActionColors o, double t) =>
      TwakeUiActionColors(
        hover: Color.lerp(hover, o.hover, t)!,
        selected: Color.lerp(selected, o.selected, t)!,
        focus: Color.lerp(focus, o.focus, t)!,
        disabled: Color.lerp(disabled, o.disabled, t)!,
        disabledBackground: Color.lerp(
          disabledBackground,
          o.disabledBackground,
          t,
        )!,
      );
}

/// The Twake palette from @linagora/twake-mui 19.7.0
/// `dist/lib/makePalette.js` (hex values from @linagora/twake-css 1.2.1
/// `palette.json`), as a [ThemeExtension]. Read it with [TwakeUiColors.of].
class TwakeUiColors extends ThemeExtension<TwakeUiColors> {
  const TwakeUiColors({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.warning,
    required this.success,
    required this.info,
    required this.background,
    required this.text,
    required this.divider,
    required this.border,
    required this.action,
  });

  final TwakeUiPalette primary;
  final TwakeUiPalette secondary;
  final TwakeUiStatusColor error;
  final TwakeUiStatusColor warning;
  final TwakeUiStatusColor success;
  final TwakeUiStatusColor info;
  final TwakeUiBackgroundColors background;
  final TwakeUiTextColors text;
  final Color divider;
  final TwakeUiBorderColors border;
  final TwakeUiActionColors action;

  static const Color _grey900 = Color(0xFF424244);
  static const Color _white = Color(0xFFFFFFFF);

  static final TwakeUiColors light = TwakeUiColors(
    primary: const TwakeUiPalette(
      main: Color(0xFF0A84FF),
      dark: Color(0xFF006BD8),
      light: Color(0xFFD2E9FF),
      contrastText: _white,
    ),
    secondary: const TwakeUiPalette(
      main: Color(0xFF7A7781),
      dark: Color(0xFF64626A),
      light: Color(0xFFF2F2F3),
      contrastText: _white,
    ),
    error: const TwakeUiStatusColor(
      main: Color(0xFFFF3347),
      contrastText: _white,
    ),
    warning: const TwakeUiStatusColor(
      main: Color(0xFFFF8F00),
      contrastText: _white,
    ),
    success: const TwakeUiStatusColor(
      main: Color(0xFF00C853),
      contrastText: _white,
    ),
    info: const TwakeUiStatusColor(
      main: Color(0xFF00BFA5),
      contrastText: _white,
    ),
    background: const TwakeUiBackgroundColors(
      defaultColor: Color(0xFFF3F6F9),
      paper: _white,
    ),
    text: TwakeUiTextColors(
      primary: _grey900.withValues(alpha: 0.9),
      secondary: _grey900.withValues(alpha: 0.64),
      disabled: _grey900.withValues(alpha: 0.32),
      icon: _grey900.withValues(alpha: 0.72),
    ),
    divider: _grey900.withValues(alpha: 0.12),
    border: TwakeUiBorderColors(main: _grey900.withValues(alpha: 0.16)),
    action: TwakeUiActionColors(
      hover: _grey900.withValues(alpha: 0.04),
      selected: _grey900.withValues(alpha: 0.08),
      focus: _grey900.withValues(alpha: 0.12),
      disabled: _grey900.withValues(alpha: 0.24),
      disabledBackground: _grey900.withValues(alpha: 0.12),
    ),
  );

  static final TwakeUiColors dark = TwakeUiColors(
    primary: TwakeUiPalette(
      main: const Color(0xFF7BBDFF),
      dark: const Color(0xFF46A2FF),
      light: const Color(0xFFBFDFFF),
      contrastText: _grey900.withValues(alpha: 0.9),
    ),
    secondary: TwakeUiPalette(
      main: const Color(0xFFC5C7CA),
      dark: const Color(0xFFAAACAE),
      light: const Color(0xFFE1E3E6),
      contrastText: _grey900.withValues(alpha: 0.9),
    ),
    error: TwakeUiStatusColor(
      main: const Color(0xFFFF7A87),
      contrastText: _grey900.withValues(alpha: 0.9),
    ),
    warning: TwakeUiStatusColor(
      main: const Color(0xFFFFCA28),
      contrastText: _grey900.withValues(alpha: 0.9),
    ),
    success: TwakeUiStatusColor(
      main: const Color(0xFF66E475),
      contrastText: _grey900.withValues(alpha: 0.9),
    ),
    info: TwakeUiStatusColor(
      main: const Color(0xFF4EE2E5),
      contrastText: _grey900.withValues(alpha: 0.9),
    ),
    background: const TwakeUiBackgroundColors(
      defaultColor: Color(0xFF2C3039),
      paper: Color(0xFF4E5052),
    ),
    text: TwakeUiTextColors(
      primary: _white,
      secondary: _white.withValues(alpha: 0.64),
      disabled: _white.withValues(alpha: 0.4),
      icon: _white,
    ),
    divider: _white.withValues(alpha: 0.16),
    border: TwakeUiBorderColors(main: _white.withValues(alpha: 0.24)),
    action: TwakeUiActionColors(
      hover: _white.withValues(alpha: 0.08),
      selected: _white.withValues(alpha: 0.16),
      focus: _white.withValues(alpha: 0.24),
      disabled: _white.withValues(alpha: 0.32),
      disabledBackground: _white.withValues(alpha: 0.12),
    ),
  );

  /// The colours the theme carries, or [light] when it carries none.
  static TwakeUiColors of(BuildContext context) =>
      Theme.of(context).extension<TwakeUiColors>() ?? light;

  @override
  TwakeUiColors copyWith({
    TwakeUiPalette? primary,
    TwakeUiPalette? secondary,
    TwakeUiStatusColor? error,
    TwakeUiStatusColor? warning,
    TwakeUiStatusColor? success,
    TwakeUiStatusColor? info,
    TwakeUiBackgroundColors? background,
    TwakeUiTextColors? text,
    Color? divider,
    TwakeUiBorderColors? border,
    TwakeUiActionColors? action,
  }) => TwakeUiColors(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    error: error ?? this.error,
    warning: warning ?? this.warning,
    success: success ?? this.success,
    info: info ?? this.info,
    background: background ?? this.background,
    text: text ?? this.text,
    divider: divider ?? this.divider,
    border: border ?? this.border,
    action: action ?? this.action,
  );

  @override
  TwakeUiColors lerp(ThemeExtension<TwakeUiColors>? other, double t) {
    if (other is! TwakeUiColors) return this;
    return TwakeUiColors(
      primary: primary._lerpTo(other.primary, t),
      secondary: secondary._lerpTo(other.secondary, t),
      error: error._lerpTo(other.error, t),
      warning: warning._lerpTo(other.warning, t),
      success: success._lerpTo(other.success, t),
      info: info._lerpTo(other.info, t),
      background: background._lerpTo(other.background, t),
      text: text._lerpTo(other.text, t),
      divider: Color.lerp(divider, other.divider, t)!,
      border: border._lerpTo(other.border, t),
      action: action._lerpTo(other.action, t),
    );
  }
}
