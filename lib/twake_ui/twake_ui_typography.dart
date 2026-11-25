import 'package:flutter/painting.dart';

/// Text styles from @linagora/twake-mui 19.7.0 `dist/lib/makeTypography.js`.
/// Inter is the package's `TwakeInter` family; letter spacing is in pixels;
/// h1 to h4 set none, as in the source. [body3] is kept from the source.
abstract final class TwakeUiTypography {
  static const String _family = 'packages/linagora_design_flutter/TwakeInter';

  static const TextStyle h1 = TextStyle(
    fontFamily: _family,
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.087,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: _family,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.313,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: _family,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.167,
  );
  static const TextStyle h4 = TextStyle(
    fontFamily: _family,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.167,
  );
  static const TextStyle h5 = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.313,
    letterSpacing: 0.15,
  );
  static const TextStyle h6 = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.313,
    letterSpacing: 0.1,
  );
  static const TextStyle subtitle1 = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.358,
    letterSpacing: 0.1,
  );
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.313,
    letterSpacing: 0.25,
  );
  static const TextStyle body1 = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.313,
    letterSpacing: -0.15,
  );
  static const TextStyle body2 = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.313,
    letterSpacing: 0.25,
  );
  static const TextStyle body3 = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.313,
    letterSpacing: 0.25,
  );
  static const TextStyle button = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.313,
    letterSpacing: 0.1,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.317,
    letterSpacing: 0.5,
  );
  static const TextStyle overline = TextStyle(
    fontFamily: _family,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 13 / 11,
    letterSpacing: 0.4,
  );
}
