import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'css_color_matcher.dart';

// Source: @linagora/twake-mui 19.7.0 dist/lib/makeShadows.js.
// Each level is `0px y1 blur1 spread1 c@o1, 0px y2 blur2 spread2 c@o2,
// 0px 0px 0px 0.5px outline` (lines 53-57), kept in the CSS order.
// c = Grey.900 #424244 in light, Common.black in dark (line 48).
// outline = Grey.900 @ 0.12 in light, white @ 0.08 in dark (lines 49-51).
const _grey900 = 0x424244;
const _black = 0x000000;
const _white = 0xFFFFFF;

Matcher _shadow(double dy, double blur, double spread, Matcher color) =>
    isA<BoxShadow>()
        .having((s) => s.offset, 'offset', Offset(0, dy))
        .having((s) => s.blurRadius, 'blurRadius', blur)
        .having((s) => s.spreadRadius, 'spreadRadius', spread)
        .having((s) => s.blurStyle, 'blurStyle', BlurStyle.normal)
        .having((s) => s.color, 'color', color);

/// One entry of the `elevations` table, with its outline.
List<Matcher> _level(List<num> t, int shadow, Matcher outline) => [
  _shadow(
    t[0].toDouble(),
    t[1].toDouble(),
    t[2].toDouble(),
    isCssColor(shadow, t[3].toDouble()),
  ),
  _shadow(
    t[4].toDouble(),
    t[5].toDouble(),
    t[6].toDouble(),
    isCssColor(shadow, t[7].toDouble()),
  ),
  _shadow(0, 0, 0.5, outline),
];

// The `elevations` rows, level n = row n (theme.shadows[0] is 'none').
const _rows = <int, List<num>>{
  1: [2, 4, 0, 0.08, 4, 16, 0, 0.06], // line 10
  2: [3, 5, 0, 0.09, 4, 17, 0, 0.07], // line 11
  8: [5, 8, -2, 0.13, 6, 26, 2, 0.11], // line 17
  24: [12, 16, -8, 0.24, 12, 48, 8, 0.24], // line 33
};

void main() {
  for (final brightness in Brightness.values) {
    final light = brightness == Brightness.light;
    final shadow = light ? _grey900 : _black;
    final outline = light
        ? isCssColor(_grey900, 0.12)
        : isCssColor(_white, 0.08);

    group('$brightness', () {
      test('level 0 casts no shadow', () {
        expect(TwakeUiShadows.elevation(0, brightness: brightness), isEmpty);
      });

      for (final row in _rows.entries) {
        test('level ${row.key} matches the React app', () {
          expect(
            TwakeUiShadows.elevation(row.key, brightness: brightness),
            orderedEquals(_level(row.value, shadow, outline)),
          );
        });
      }

      test('level 25 is the flat extra elevation, with no outline', () {
        // line 58: `0px 1px 4px c@0.04`
        expect(
          TwakeUiShadows.elevation(25, brightness: brightness),
          orderedEquals([_shadow(1, 4, 0, isCssColor(shadow, 0.04))]),
        );
      });
    });
  }
}
