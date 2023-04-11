import 'package:flutter/material.dart';

class LinagoraKeyColors {
  final Color primary;

  final Color secondary;

  final Color tertiary;

  final Color neutral;

  final Color neutralVariant;

  final Color error;

  static final LinagoraKeyColors _materialLinagoraColors =
      LinagoraKeyColors._material();

  factory LinagoraKeyColors.material() {
    return _materialLinagoraColors;
  }

  LinagoraKeyColors._material()
      : primary = const Color(0xFF6750A4),
        secondary = const Color(0xFF625B71),
        tertiary = const Color(0xFF7D5260),
        neutral = const Color(0xFF605D62),
        neutralVariant = const Color(0xFF605D66),
        error = const Color(0xFFB3261E);
}
