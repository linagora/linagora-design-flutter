import 'package:flutter/material.dart';

class LinagoraRefColors {
  final MaterialColor primary;

  final MaterialColor secondary;

  final MaterialColor tertiary;

  final MaterialColor neutral;

  final MaterialColor neutralVariant;

  final MaterialColor error;

  static final LinagoraRefColors _materialLinagoraColors =
      LinagoraRefColors._material();

  factory LinagoraRefColors.material() {
    return _materialLinagoraColors;
  }

  LinagoraRefColors._material()
      : primary = const MaterialColor(
          0xFF46A2FF,
          <int, Color>{
            0: Color(0xFF000000),
            10: Color(0xFF0157AD),
            20: Color(0xFF006BD8),
            30: Color(0xFF007CF9),
            40: Color(0xFF0A84FF),
            50: Color(0xFF46A2FF),
            60: Color(0xFF7BBDFF),
            70: Color(0xFFAAD4FE),
            80: Color(0xFFBFDFFF),
            90: Color(0xFFD2E9FF),
            95: Color(0xFFE3F1FF),
            99: Color(0xFFF7FBFF),
            100: Color(0xFFFFFFFF),
          },
        ),
        secondary = const MaterialColor(
          0xFF85B5EC,
          <int, Color>{
            0: Color(0xFF000000),
            10: Color(0xFF243B55),
            20: Color(0xFF436E9F),
            30: Color(0xFF5085C4),
            40: Color(0xFF5C9CE6),
            50: Color(0xFF85B5EC),
            60: Color(0xFF96BCE8),
            70: Color(0xFFB5D1F1),
            80: Color(0xFFD1E0F2),
            90: Color(0xFFE8F0FA),
            95: Color(0xFFF1F5FA),
            99: Color(0xFFFFFBFE),
            100: Color(0xFFFFFFFF),
          },
        ),
        tertiary = const MaterialColor(
          0xFFCFD8E2,
          <int, Color>{
            0: Color(0xFF000000),
            10: Color(0xFF37383A),
            20: Color(0xFF71767C),
            30: Color(0xFF99A0A9),
            40: Color(0xFFB8C1CC),
            50: Color(0xFFCFD8E2),
            60: Color(0xFFD8E1EB),
            70: Color(0xFFE5ECF3),
            80: Color(0xFFEEF6FE),
            90: Color(0xFFFCFCFC),
            95: Color(0xFFFFFFFF),
            99: Color(0xFFFFFBFA),
            100: Color(0xFFFFFFFF),
          },
        ),
        neutral = const MaterialColor(
          0xFF787579,
          <int, Color>{
            0: Color(0xFF000000),
            10: Color(0xFF1C1B1F),
            20: Color(0xFF313033),
            30: Color(0xFF484649),
            40: Color(0xFF605D62),
            50: Color(0xFF787579),
            60: Color(0xFF939094),
            70: Color(0xFFAEAAAE),
            80: Color(0xFFC9C5CA),
            90: Color(0xFFE6E1E5),
            95: Color(0xFFF4EFF4),
            99: Color(0xFFFFFBFE),
            100: Color(0xFFFFFFFF),
          },
        ),
        neutralVariant = const MaterialColor(
          0xFF79747E,
          <int, Color>{
            0: Color(0xFF000000),
            10: Color(0xFF1D1A22),
            20: Color(0xFF322F37),
            30: Color(0xFF49454F),
            40: Color(0xFF605D66),
            50: Color(0xFF79747E),
            60: Color(0xFF938F99),
            70: Color(0xFFAEA9B4),
            80: Color(0xFFCAC4D0),
            90: Color(0xFFE7E0EC),
            95: Color(0xFFF5EEFA),
            99: Color(0xFFFFFBFE),
            100: Color(0xFFFFFFFF),
          },
        ),
        error = const MaterialColor(
          0xFF46A2FF,
          <int, Color>{
            0: Color(0xFF000000),
            10: Color(0xFF7A1E27),
            20: Color(0xFFB52C39),
            30: Color(0xFFD32C3C),
            40: Color(0xFFFF3347),
            50: Color(0xFFFF4D5E),
            60: Color(0xFFFF7A87),
            70: Color(0xFFFF939D),
            80: Color(0xFFFFB4BB),
            90: Color(0xFFFFD2D7),
            95: Color(0xFFFCEEEE),
            99: Color(0xFFFFFBF9),
            100: Color(0xFFFFFFFF),
          },
        );
}
