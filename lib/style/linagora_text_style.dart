
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

class LinagoraTextStyle {
  final TextStyle bodyLarge1;

  final TextStyle bodyLarge2;

  final TextStyle bodyMedium1;

  final TextStyle bodyMedium2;

  final TextStyle bodyMedium3;

  static final LinagoraTextStyle _materialLinagoraTextStyle =
      LinagoraTextStyle._material();

  factory LinagoraTextStyle.material() {
    return _materialLinagoraTextStyle;
  }

  LinagoraTextStyle._material()
      : bodyLarge1 = GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.15,
        ),
        bodyLarge2 = GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium1 = GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.15,
        ),
        bodyMedium2 = GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
        bodyMedium3 = GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        );
}
