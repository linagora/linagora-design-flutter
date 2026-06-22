import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_style.dart';

/// [TextTheme] mapping the 15 Material slots onto the [LinagoraTextStyle]
/// 7 tokens with no Material slot live in [LinagoraTextThemeExtension].
class LinagoraTextTheme {
  LinagoraTextTheme._();

  static const String _package = 'linagora_design_flutter';
  static const String _fontFamily = 'TwakeInter';

  static final TextTheme _material = _build(LinagoraTextStyle.material());

  static TextTheme material() => _material;

  static TextTheme _build(LinagoraTextStyle tokens) => TextTheme(
        displayLarge: tokens.displayLarge,
        displayMedium: tokens.displayMedium,
        displaySmall: tokens.displaySmall,
        headlineLarge: tokens.headlineLarge,
        headlineMedium: tokens.headlineMedium,
        headlineSmall: tokens.headlineSmall,
        titleLarge: tokens.titleLarge,
        titleMedium: tokens.titleMedium,
        titleSmall: tokens.titleSmall,
        labelLarge: tokens.labelLarge,
        labelMedium: tokens.labelMedium,
        labelSmall: tokens.labelSmall,
        bodyLarge: tokens.bodyLarge,
        bodyMedium: tokens.bodyMedium,
        bodySmall: tokens.bodySmall,
      ).apply(fontFamily: _fontFamily, package: _package);
}

/// Material [TextTheme] is capped at 15 slot, the rest is
/// provided via [ThemeData.extensions]
class LinagoraTextThemeExtension
    extends ThemeExtension<LinagoraTextThemeExtension> {
  final TextStyle titleSemibold;
  final TextStyle bodyLargeBold;
  final TextStyle bodyLarge1;
  final TextStyle bodyLarge2;
  final TextStyle bodyMedium1;
  final TextStyle bodyMedium2;
  final TextStyle bodyMedium3;

  const LinagoraTextThemeExtension({
    required this.titleSemibold,
    required this.bodyLargeBold,
    required this.bodyLarge1,
    required this.bodyLarge2,
    required this.bodyMedium1,
    required this.bodyMedium2,
    required this.bodyMedium3,
  });

  static final LinagoraTextThemeExtension _material =
      _build(LinagoraTextStyle.material());

  factory LinagoraTextThemeExtension.material() => _material;

  static LinagoraTextThemeExtension _build(LinagoraTextStyle tokens) {
    TextStyle withFont(TextStyle style) => style.apply(
          fontFamily: LinagoraTextTheme._fontFamily,
          package: LinagoraTextTheme._package,
        );
    return LinagoraTextThemeExtension(
      titleSemibold: withFont(tokens.titleSemibold),
      bodyLargeBold: withFont(tokens.bodyLargeBold),
      bodyLarge1: withFont(tokens.bodyLarge1),
      bodyLarge2: withFont(tokens.bodyLarge2),
      bodyMedium1: withFont(tokens.bodyMedium1),
      bodyMedium2: withFont(tokens.bodyMedium2),
      bodyMedium3: withFont(tokens.bodyMedium3),
    );
  }

  @override
  LinagoraTextThemeExtension copyWith({
    TextStyle? titleSemibold,
    TextStyle? bodyLargeBold,
    TextStyle? bodyLarge1,
    TextStyle? bodyLarge2,
    TextStyle? bodyMedium1,
    TextStyle? bodyMedium2,
    TextStyle? bodyMedium3,
  }) {
    return LinagoraTextThemeExtension(
      titleSemibold: titleSemibold ?? this.titleSemibold,
      bodyLargeBold: bodyLargeBold ?? this.bodyLargeBold,
      bodyLarge1: bodyLarge1 ?? this.bodyLarge1,
      bodyLarge2: bodyLarge2 ?? this.bodyLarge2,
      bodyMedium1: bodyMedium1 ?? this.bodyMedium1,
      bodyMedium2: bodyMedium2 ?? this.bodyMedium2,
      bodyMedium3: bodyMedium3 ?? this.bodyMedium3,
    );
  }

  @override
  LinagoraTextThemeExtension lerp(
    covariant ThemeExtension<LinagoraTextThemeExtension>? other,
    double t,
  ) {
    if (other is! LinagoraTextThemeExtension) return this;
    return LinagoraTextThemeExtension(
      titleSemibold: TextStyle.lerp(titleSemibold, other.titleSemibold, t)!,
      bodyLargeBold: TextStyle.lerp(bodyLargeBold, other.bodyLargeBold, t)!,
      bodyLarge1: TextStyle.lerp(bodyLarge1, other.bodyLarge1, t)!,
      bodyLarge2: TextStyle.lerp(bodyLarge2, other.bodyLarge2, t)!,
      bodyMedium1: TextStyle.lerp(bodyMedium1, other.bodyMedium1, t)!,
      bodyMedium2: TextStyle.lerp(bodyMedium2, other.bodyMedium2, t)!,
      bodyMedium3: TextStyle.lerp(bodyMedium3, other.bodyMedium3, t)!,
    );
  }
}
