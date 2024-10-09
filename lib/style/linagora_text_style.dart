
import 'package:flutter/painting.dart';

class LinagoraTextStyle {
  final TextStyle bodyLarge1;

  final TextStyle bodyLarge2;

  final TextStyle bodyMedium;

  final TextStyle bodyMedium1;

  final TextStyle bodyMedium2;

  final TextStyle bodyMedium3;

  static final LinagoraTextStyle _materialLinagoraTextStyle =
      LinagoraTextStyle._material();

  factory LinagoraTextStyle.material() {
    return _materialLinagoraTextStyle;
  }

  LinagoraTextStyle._material()
      : bodyLarge1 = const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.15,
        ),
        bodyLarge2 = const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
        bodyMedium1 = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium2 = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
        bodyMedium3 = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        );
}
