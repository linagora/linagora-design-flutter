import 'dart:ui' show ColorSpace;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// Matches the colour CSS draws for `rgba(<rgb>, <alpha>)`, the way MUI's
/// `alpha(color, value)` writes it in @linagora/twake-mui.
///
/// Red, green and blue must be the exact 8-bit channels. Alpha must be the
/// CSS value or one of its nearest 8-bit steps: `Color(0xE6424244)` and
/// `Color(0xFF424244).withValues(alpha: 0.9)` both draw `rgba(66,66,68,.9)`,
/// and 0.9 sits exactly between the steps 229 and 230. Any other step fails.
Matcher isCssColor(int rgb, [double alpha = 1]) => _CssColor(rgb, alpha);

class _CssColor extends Matcher {
  const _CssColor(this.rgb, this.alpha);

  final int rgb;
  final double alpha;

  static int _byte(double channel) => (channel * 255).round();

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! Color) return false;
    return item.colorSpace == ColorSpace.sRGB &&
        _byte(item.r) == (rgb >> 16) & 0xFF &&
        _byte(item.g) == (rgb >> 8) & 0xFF &&
        _byte(item.b) == rgb & 0xFF &&
        (item.a - alpha).abs() <= 0.5 / 255 + 1e-9;
  }

  @override
  Description describe(Description description) => description.add(
    'rgba(#${rgb.toRadixString(16).padLeft(6, '0')}, $alpha)',
  );

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! Color) return mismatchDescription.add('is not a Color');
    return mismatchDescription.add(
      'is 0x${item.toARGB32().toRadixString(16).padLeft(8, '0')} '
      '(alpha ${item.a})',
    );
  }
}
