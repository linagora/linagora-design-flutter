import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Entries of the shared product text scale, named as the design library
/// names them.
///
/// This scale sits alongside [LinagoraTextStyle]'s Material slots rather than
/// replacing them: every entry shares its family, size, weight and letter
/// spacing with a Material token but rides on a tighter line box, so none of
/// them can be expressed as that token without a per-call-site override.
enum LinagoraTypographyVariant {
  /// 24px · SemiBold · 28px line box.
  h3,

  /// 22px · SemiBold · 25.7px line box.
  h4,

  /// 16px · SemiBold · 21px line box. Section and notice titles.
  h5,

  /// 14px · Medium · 18.4px line box.
  h6,

  /// 16px · Regular · 21px line box.
  body1,

  /// 14px · Medium · 18.4px line box. Supporting copy under a title.
  body2,

  /// 14px · Regular · 18.4px line box.
  body3,

  /// 14px · Medium · 20px line box. Button and action labels.
  buttonMedium,

  /// 12px · Medium · 15.8px line box.
  caption,
}

/// Resolves a [LinagoraTypographyVariant] to its [TextStyle].
///
/// The scale is held as one map keyed by variant rather than as a field per
/// entry, so adding a variant is an enum value plus a map entry — no
/// constructor, `copyWith` or `lerp` signature grows with the scale.
///
/// Registered as a [ThemeExtension] so a product can restyle the scale for
/// its own theme, and read through [LinagoraTypography.of] so a widget keeps
/// working in a theme that never registered it.
class LinagoraTypography extends ThemeExtension<LinagoraTypography> {
  final Map<LinagoraTypographyVariant, TextStyle> styles;

  LinagoraTypography(Map<LinagoraTypographyVariant, TextStyle> styles)
      : assert(
          styles.length == LinagoraTypographyVariant.values.length,
          'The scale must carry a style for every variant',
        ),
        styles = Map.unmodifiable(styles);

  static final LinagoraTypography _material = _build();

  factory LinagoraTypography.material() => _material;

  /// Built from the Material tokens that already carry the right family,
  /// size, weight and letter spacing, so only the line box is restated here.
  static LinagoraTypography _build() {
    final text = LinagoraTextTheme.material();
    final tokens = LinagoraTextThemeExtension.material();
    return LinagoraTypography({
      LinagoraTypographyVariant.h3:
          text.headlineSmall!.copyWith(height: 28 / 24),
      LinagoraTypographyVariant.h4: text.titleLarge!.copyWith(height: 25.7 / 22),
      LinagoraTypographyVariant.h5:
          tokens.titleSemibold.copyWith(height: 21 / 16),
      LinagoraTypographyVariant.h6:
          text.titleSmall!.copyWith(height: 18.4 / 14),
      LinagoraTypographyVariant.body1:
          tokens.bodyMedium1.copyWith(height: 21 / 16),
      LinagoraTypographyVariant.body2:
          text.bodyMedium!.copyWith(height: 18.4 / 14),
      LinagoraTypographyVariant.body3:
          tokens.bodyMedium3.copyWith(height: 18.4 / 14),
      LinagoraTypographyVariant.buttonMedium: text.labelLarge!,
      LinagoraTypographyVariant.caption:
          text.labelMedium!.copyWith(height: 15.8 / 12),
    });
  }

  /// The scale from [context]'s theme, falling back to [material] when the
  /// theme carries no extension of its own.
  static LinagoraTypography of(BuildContext context) =>
      Theme.of(context).extension<LinagoraTypography>() ??
      LinagoraTypography.material();

  /// The constructor guarantees every variant is present, so this never
  /// resolves to null.
  TextStyle resolve(LinagoraTypographyVariant variant) => styles[variant]!;

  TextStyle get h3 => resolve(LinagoraTypographyVariant.h3);

  TextStyle get h4 => resolve(LinagoraTypographyVariant.h4);

  TextStyle get h5 => resolve(LinagoraTypographyVariant.h5);

  TextStyle get h6 => resolve(LinagoraTypographyVariant.h6);

  TextStyle get body1 => resolve(LinagoraTypographyVariant.body1);

  TextStyle get body2 => resolve(LinagoraTypographyVariant.body2);

  TextStyle get body3 => resolve(LinagoraTypographyVariant.body3);

  TextStyle get buttonMedium =>
      resolve(LinagoraTypographyVariant.buttonMedium);

  TextStyle get caption => resolve(LinagoraTypographyVariant.caption);

  /// Replaces only the entries [overrides] names, keeping the rest.
  @override
  LinagoraTypography copyWith({
    Map<LinagoraTypographyVariant, TextStyle>? overrides,
  }) {
    if (overrides == null || overrides.isEmpty) return this;
    return LinagoraTypography({...styles, ...overrides});
  }

  @override
  LinagoraTypography lerp(
    covariant ThemeExtension<LinagoraTypography>? other,
    double t,
  ) {
    if (other is! LinagoraTypography) return this;
    return LinagoraTypography({
      for (final variant in LinagoraTypographyVariant.values)
        variant: TextStyle.lerp(resolve(variant), other.resolve(variant), t)!,
    });
  }
}
