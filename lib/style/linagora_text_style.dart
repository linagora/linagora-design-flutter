
import 'package:flutter/painting.dart';

class LinagoraTextStyle {
  // Display
  final TextStyle displayLarge;

  final TextStyle displayMedium;

  final TextStyle displaySmall;

  // Headline
  final TextStyle headlineLarge;

  final TextStyle headlineMedium;

  final TextStyle headlineSmall;

  // Title
  final TextStyle titleLarge;

  final TextStyle titleMedium;

  final TextStyle titleSemibold;

  final TextStyle titleSmall;

  // Label
  final TextStyle labelLarge;

  final TextStyle labelMedium;

  final TextStyle labelSmall;

  // Body
  final TextStyle bodyLarge;

  final TextStyle bodyLargeBold;

  final TextStyle bodyLarge1;

  final TextStyle bodyLarge2;

  final TextStyle bodyMedium1;

  final TextStyle bodyMedium2;

  final TextStyle bodyMedium;

  final TextStyle bodyMedium3;

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
