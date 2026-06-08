
import 'package:flutter/painting.dart';

class LinagoraTextStyle {
  // Display

  /// 57px · Bold (w700).
  final TextStyle displayLarge;

  /// 45px · SemiBold (w600).
  final TextStyle displayMedium;

  /// 36px · SemiBold (w600).
  final TextStyle displaySmall;

  // Headline

  /// 32px · SemiBold (w600).
  final TextStyle headlineLarge;

  /// 28px · SemiBold (w600).
  final TextStyle headlineMedium;

  /// 24px · SemiBold (w600).
  final TextStyle headlineSmall;

  // Title

  /// 22px · SemiBold (w600).
  final TextStyle titleLarge;

  /// 16px · Medium (w500).
  final TextStyle titleMedium;

  /// 16px · SemiBold (w600). Same size as [titleMedium], heavier weight.
  final TextStyle titleSemibold;

  /// 14px · Medium (w500).
  final TextStyle titleSmall;

  // Label

  /// 14px · Medium (w500).
  final TextStyle labelLarge;

  /// 12px · Medium (w500).
  final TextStyle labelMedium;

  /// 11px · Medium (w500).
  final TextStyle labelSmall;

  // Body — the numeric suffixes are a Figma import legacy and only vary the
  // weight at a shared font size as of now

  /// 17px · Medium (w500). Default body large (Figma token `M3/body/large`).
  final TextStyle bodyLarge;

  /// 17px · Bold (w700).
  final TextStyle bodyLargeBold;

  /// 17px · SemiBold (w600).
  final TextStyle bodyLarge1;

  /// 17px · Regular (w400).
  final TextStyle bodyLarge2;

  /// 16px · Regular (w400).
  final TextStyle bodyMedium1;

  /// 14px · SemiBold (w600).
  final TextStyle bodyMedium2;

  /// 14px · Medium (w500). Default body medium (Figma token `M3/body/medium`).
  final TextStyle bodyMedium;

  /// 14px · Regular (w400).
  final TextStyle bodyMedium3;

  /// 12px · Medium (w500).
  final TextStyle bodySmall;

  static final LinagoraTextStyle _materialLinagoraTextStyle =
      LinagoraTextStyle._material();

  factory LinagoraTextStyle.material() {
    return _materialLinagoraTextStyle;
  }

  LinagoraTextStyle._material()
      : displayLarge = const TextStyle(
          fontSize: 57,
          height: 64 / 57,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        displayMedium = const TextStyle(
          fontSize: 45,
          height: 52 / 45,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        displaySmall = const TextStyle(
          fontSize: 36,
          height: 44 / 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineLarge = const TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineMedium = const TextStyle(
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineSmall = const TextStyle(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleLarge = const TextStyle(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleMedium = const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSemibold = const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleSmall = const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelLarge = const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium = const TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall = const TextStyle(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        bodyLarge = const TextStyle(
          fontSize: 17,
          height: 24 / 17,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.15,
        ),
        bodyLargeBold = const TextStyle(
          fontSize: 17,
          height: 24 / 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.15,
        ),
        bodyLarge1 = const TextStyle(
          fontSize: 17,
          height: 24 / 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.15,
        ),
        bodyLarge2 = const TextStyle(
          fontSize: 17,
          height: 24 / 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium1 = const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium2 = const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
        bodyMedium = const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
        bodyMedium3 = const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall = const TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        );
}
