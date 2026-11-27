import 'package:flutter/material.dart';

/// Elevation shadows from @linagora/twake-mui 19.7.0
/// `dist/lib/makeShadows.js`, in the same layer order as the CSS.
abstract final class TwakeUiShadows {
  // [y1, blur1, spread1, opacity1, y2, blur2, spread2, opacity2], levels 1-24.
  static const List<List<double>> _elevations = [
    [2, 4, 0, 0.08, 4, 16, 0, 0.06],
    [3, 5, 0, 0.09, 4, 17, 0, 0.07],
    [3, 5, -1, 0.09, 5, 19, 1, 0.08],
    [3, 6, -1, 0.1, 5, 20, 1, 0.08],
    [4, 6, -1, 0.11, 5, 22, 1, 0.09],
    [4, 7, -2, 0.11, 6, 23, 2, 0.1],
    [5, 7, -2, 0.12, 6, 24, 2, 0.11],
    [5, 8, -2, 0.13, 6, 26, 2, 0.11],
    [5, 8, -3, 0.14, 7, 27, 3, 0.12],
    [6, 9, -3, 0.14, 7, 29, 3, 0.13],
    [6, 9, -3, 0.15, 7, 30, 3, 0.14],
    [7, 10, -4, 0.16, 8, 31, 4, 0.15],
    [7, 10, -4, 0.16, 8, 33, 4, 0.15],
    [8, 11, -5, 0.17, 9, 34, 5, 0.16],
    [8, 11, -5, 0.18, 9, 35, 5, 0.17],
    [9, 12, -5, 0.18, 9, 37, 5, 0.18],
    [9, 12, -6, 0.19, 10, 38, 6, 0.19],
    [9, 13, -6, 0.2, 10, 40, 6, 0.19],
    [10, 13, -6, 0.21, 10, 41, 6, 0.2],
    [10, 14, -7, 0.21, 11, 42, 7, 0.21],
    [11, 14, -7, 0.22, 11, 44, 7, 0.22],
    [11, 15, -7, 0.23, 11, 45, 7, 0.22],
    [12, 15, -8, 0.23, 12, 47, 8, 0.23],
    [12, 16, -8, 0.24, 12, 48, 8, 0.24],
  ];

  /// The shadows of MUI `theme.shadows[level]`: 0 is none, 1 to 24 are two
  /// layers plus a hairline outline, 25 is the flat extra elevation.
  static List<BoxShadow> elevation(
    int level, {
    required Brightness brightness,
  }) {
    assert(level >= 0 && level <= 25, 'level must be between 0 and 25');
    final light = brightness == Brightness.light;
    final color = light ? const Color(0xFF424244) : const Color(0xFF000000);
    if (level == 0) return const [];
    if (level == 25) {
      return [
        BoxShadow(
          color: color.withValues(alpha: 0.04),
          offset: const Offset(0, 1),
          blurRadius: 4,
        ),
      ];
    }
    final e = _elevations[level - 1];
    return [
      BoxShadow(
        color: color.withValues(alpha: e[3]),
        offset: Offset(0, e[0]),
        blurRadius: e[1],
        spreadRadius: e[2],
      ),
      BoxShadow(
        color: color.withValues(alpha: e[7]),
        offset: Offset(0, e[4]),
        blurRadius: e[5],
        spreadRadius: e[6],
      ),
      BoxShadow(
        color: light
            ? color.withValues(alpha: 0.12)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        spreadRadius: 0.5,
      ),
    ];
  }
}
