import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

// unit: makeTheme.js sets no `spacing`, so MUI's default spacing(1) = 8 px.
// xs..xl: @linagora/twake-css 1.2.1 MIGRATION.md lines 58-63
// (spacing(1)=8, (2)=16, (3)=24, (4)=32, (6)=48).
// xxl, xxxl: agreed API only (spacing(8), spacing(12)), no source line.
void main() {
  test('the unit is the MUI 8 px grid', () => expect(TwakeUiSpacing.unit, 8));
  test('xs is 8 px', () => expect(TwakeUiSpacing.xs, 8));
  test('s is 16 px', () => expect(TwakeUiSpacing.s, 16));
  test('m is 24 px', () => expect(TwakeUiSpacing.m, 24));
  test('l is 32 px', () => expect(TwakeUiSpacing.l, 32));
  test('xl is 48 px', () => expect(TwakeUiSpacing.xl, 48));
  test('xxl is 64 px', () => expect(TwakeUiSpacing.xxl, 64));
  test('xxxl is 96 px', () => expect(TwakeUiSpacing.xxxl, 96));
}
