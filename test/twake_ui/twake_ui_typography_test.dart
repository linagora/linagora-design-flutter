import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

// Source: @linagora/twake-mui 19.7.0 dist/lib/makeTypography.js.
// The React app asks for "Inter" (line 4); this package ships Inter as the
// TwakeInter family (pubspec.yaml), resolved through the package prefix.
const _family = 'packages/linagora_design_flutter/TwakeInter';

typedef _Spec = ({
  TextStyle Function() style,
  double size,
  FontWeight weight,
  double height,
  double? letterSpacing, // null = the variant sets none in makeTypography.js
});

final _variants = <String, _Spec>{
  // h1..h4 set no letterSpacing in makeTypography.js: not asserted, see report.
  'h1': (
    style: () => TwakeUiTypography.h1,
    size: 45,
    weight: FontWeight.w600,
    height: 1.087,
    letterSpacing: null,
  ), // lines 16-20
  'h2': (
    style: () => TwakeUiTypography.h2,
    size: 32,
    weight: FontWeight.w600,
    height: 1.313,
    letterSpacing: null,
  ), // lines 21-25
  'h3': (
    style: () => TwakeUiTypography.h3,
    size: 24,
    weight: FontWeight.w600,
    height: 1.167,
    letterSpacing: null,
  ), // lines 26-30
  'h4': (
    style: () => TwakeUiTypography.h4,
    size: 22,
    weight: FontWeight.w600,
    height: 1.167,
    letterSpacing: null,
  ), // lines 31-35
  'h5': (
    style: () => TwakeUiTypography.h5,
    size: 16,
    weight: FontWeight.w600,
    height: 1.313,
    letterSpacing: 0.15,
  ), // lines 36-41
  'h6': (
    style: () => TwakeUiTypography.h6,
    size: 14,
    weight: FontWeight.w500,
    height: 1.313,
    letterSpacing: 0.1,
  ), // lines 42-47
  'subtitle1': (
    style: () => TwakeUiTypography.subtitle1,
    size: 14,
    weight: FontWeight.w500,
    height: 1.358,
    letterSpacing: 0.1,
  ), // lines 48-53
  'subtitle2': (
    style: () => TwakeUiTypography.subtitle2,
    size: 14,
    weight: FontWeight.w600,
    height: 1.313,
    letterSpacing: 0.25,
  ), // lines 54-59
  'body1': (
    style: () => TwakeUiTypography.body1,
    size: 16,
    weight: FontWeight.w400,
    height: 1.313,
    letterSpacing: -0.15,
  ), // lines 60-65
  'body2': (
    style: () => TwakeUiTypography.body2,
    size: 14,
    weight: FontWeight.w500,
    height: 1.313,
    letterSpacing: 0.25,
  ), // lines 66-71
  'body3': (
    style: () => TwakeUiTypography.body3,
    size: 14,
    weight: FontWeight.w400,
    height: 1.313,
    letterSpacing: 0.25,
  ), // lines 72-77
  'button': (
    style: () => TwakeUiTypography.button,
    size: 14,
    weight: FontWeight.w500,
    height: 1.313,
    letterSpacing: 0.1,
  ), // lines 78-84
  'caption': (
    style: () => TwakeUiTypography.caption,
    size: 12,
    weight: FontWeight.w500,
    height: 1.317,
    letterSpacing: 0.5,
  ), // lines 85-90
  // lineHeight '13px' on an 11px font: height 13 / 11.
  'overline': (
    style: () => TwakeUiTypography.overline,
    size: 11,
    weight: FontWeight.w500,
    height: 13 / 11,
    letterSpacing: 0.4,
  ), // lines 91-97
};

void main() {
  for (final v in _variants.entries) {
    group(v.key, () {
      test('uses the Inter font the package ships', () {
        expect(v.value.style().fontFamily, _family);
      });

      test('has the React size, weight and line height', () {
        final style = v.value.style();
        expect(style.fontSize, v.value.size);
        expect(style.fontWeight, v.value.weight);
        expect(style.height, closeTo(v.value.height, 1e-9));
      });

      if (v.value.letterSpacing != null) {
        test('has the React letter spacing in pixels', () {
          expect(
            v.value.style().letterSpacing,
            closeTo(v.value.letterSpacing!, 1e-9),
          );
        });
      }
    });
  }
}
