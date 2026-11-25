import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

// Source: @linagora/twake-mui 19.7.0 dist/lib/radius.js (lines 3-6) and
// makeTheme.js shape.borderRadius (line 10).
void main() {
  test('sm is 4 px', () => expect(TwakeUiRadius.sm, 4));
  test('md is 8 px', () => expect(TwakeUiRadius.md, 8));
  test('lg is 12 px', () => expect(TwakeUiRadius.lg, 12));
  test('pill is 100 px', () => expect(TwakeUiRadius.pill, 100));
  test(
    'base, the MUI theme shape radius, is 6 px',
    () => expect(TwakeUiRadius.base, 6),
  );
}
