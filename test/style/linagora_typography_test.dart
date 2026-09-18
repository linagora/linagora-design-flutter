import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

/// The four metrics that identify one entry of the scale.
typedef _Metrics = ({
  double size,
  FontWeight weight,
  double lineHeight,
  double letterSpacing,
});

/// The design metrics every entry of the scale is expected to carry.
const _expected = <LinagoraTypographyVariant, _Metrics>{
  LinagoraTypographyVariant.h3: (
    size: 24,
    weight: FontWeight.w600,
    lineHeight: 28,
    letterSpacing: 0,
  ),
  LinagoraTypographyVariant.h4: (
    size: 22,
    weight: FontWeight.w600,
    lineHeight: 25.7,
    letterSpacing: 0,
  ),
  LinagoraTypographyVariant.h5: (
    size: 16,
    weight: FontWeight.w600,
    lineHeight: 21,
    letterSpacing: 0.15,
  ),
  LinagoraTypographyVariant.h6: (
    size: 14,
    weight: FontWeight.w500,
    lineHeight: 18.4,
    letterSpacing: 0.1,
  ),
  LinagoraTypographyVariant.body1: (
    size: 16,
    weight: FontWeight.w400,
    lineHeight: 21,
    letterSpacing: -0.15,
  ),
  LinagoraTypographyVariant.body2: (
    size: 14,
    weight: FontWeight.w500,
    lineHeight: 18.4,
    letterSpacing: 0.25,
  ),
  LinagoraTypographyVariant.body3: (
    size: 14,
    weight: FontWeight.w400,
    lineHeight: 18.4,
    letterSpacing: 0.25,
  ),
  LinagoraTypographyVariant.buttonMedium: (
    size: 14,
    weight: FontWeight.w500,
    lineHeight: 20,
    letterSpacing: 0.1,
  ),
  LinagoraTypographyVariant.caption: (
    size: 12,
    weight: FontWeight.w500,
    lineHeight: 15.8,
    letterSpacing: 0.5,
  ),
};

void _expectMetrics(TextStyle style, _Metrics expected, String reason) {
  expect(
    (style.fontSize, style.fontWeight, style.letterSpacing),
    (expected.size, expected.weight, expected.letterSpacing),
    reason: reason,
  );
  expect(
    style.height! * style.fontSize!,
    closeTo(expected.lineHeight, 0.001),
    reason: reason,
  );
}

void main() {
  group('scale values', () {
    test('the table covers every entry of the scale', () {
      expect(_expected.keys, unorderedEquals(LinagoraTypographyVariant.values));
    });

    test('every entry carries its design metrics', () {
      final scale = LinagoraTypography.material();

      for (final entry in _expected.entries) {
        _expectMetrics(
          scale.resolve(entry.key),
          entry.value,
          entry.key.name,
        );
      }
    });

    test('every entry keeps the product font', () {
      final scale = LinagoraTypography.material();

      // The package prefix is folded into the family by TextTheme.apply.
      for (final variant in LinagoraTypographyVariant.values) {
        expect(
          scale.resolve(variant).fontFamily,
          'packages/linagora_design_flutter/TwakeInter',
          reason: '$variant',
        );
      }
    });

    test('h5 and body2 differ from the Material tokens they resemble', () {
      final scale = LinagoraTypography.material();
      final titleSemibold = LinagoraTextThemeExtension.material().titleSemibold;
      final bodyMedium = LinagoraTextTheme.material().bodyMedium!;

      // Same face and spacing, tighter line box — which is exactly why they
      // need tokens of their own rather than a per-call-site override.
      expect(
        (scale.h5.fontSize, scale.body2.fontSize),
        (titleSemibold.fontSize, bodyMedium.fontSize),
      );
      expect(
        (scale.h5.height, scale.body2.height),
        isNot((titleSemibold.height, bodyMedium.height)),
      );
    });

    test('buttonMedium matches the label token it shares metrics with', () {
      expect(
        LinagoraTypography.material().buttonMedium,
        LinagoraTextTheme.material().labelLarge,
      );
    });

    test('resolve covers every variant', () {
      final scale = LinagoraTypography.material();

      final styles = LinagoraTypographyVariant.values
          .map(scale.resolve)
          .toSet();
      expect(styles, hasLength(LinagoraTypographyVariant.values.length));
    });
  });

  group('theme extension', () {
    testWidgets('of() reads the scale a theme registers', (tester) async {
      const overridden = TextStyle(fontSize: 99);
      late LinagoraTypography read;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              LinagoraTypography.material()
                  .copyWith(overrides: {LinagoraTypographyVariant.h5: overridden}),
            ],
          ),
          home: Builder(
            builder: (context) {
              read = LinagoraTypography.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(read.h5, overridden);
      expect(read.body2, LinagoraTypography.material().body2);
    });

    testWidgets('of() falls back when the theme registers nothing',
        (tester) async {
      late LinagoraTypography read;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              read = LinagoraTypography.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(read.h5, LinagoraTypography.material().h5);
    });

    test('lerp moves between two scales', () {
      final from = LinagoraTypography.material();
      final to = from.copyWith(
        overrides: {LinagoraTypographyVariant.h5: const TextStyle(fontSize: 32)},
      );

      expect(from.lerp(to, 0).h5.fontSize, from.h5.fontSize);
      expect(from.lerp(to, 1).h5.fontSize, 32);
    });

    test('lerp keeps the receiver for a foreign extension', () {
      final scale = LinagoraTypography.material();

      expect(scale.lerp(null, 0.5), same(scale));
    });
  });

  group('alert integration', () {
    testWidgets('the alert sets its slots from the scale', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LinagoraAlert(title: 'Heads up', message: 'Body'),
          ),
        ),
      );

      final scale = LinagoraTypography.material();
      final title = tester.widget<Text>(find.text('Heads up')).style!;
      final message = tester.widget<Text>(find.text('Body')).style!;

      expect(title.fontSize, scale.h5.fontSize);
      expect(title.height, scale.h5.height);
      expect(message.fontSize, scale.body2.fontSize);
      expect(message.height, scale.body2.height);
    });

    testWidgets('the alert follows the variants it is given', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LinagoraAlert(
              title: 'Heads up',
              message: 'Body',
              titleVariant: LinagoraTypographyVariant.body2,
              messageVariant: LinagoraTypographyVariant.buttonMedium,
            ),
          ),
        ),
      );

      final scale = LinagoraTypography.material();
      expect(
        tester.widget<Text>(find.text('Heads up')).style!.height,
        scale.body2.height,
      );
      expect(
        tester.widget<Text>(find.text('Body')).style!.letterSpacing,
        scale.buttonMedium.letterSpacing,
      );
    });

    testWidgets('a theme-level restyle reaches the alert', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              LinagoraTypography.material().copyWith(
                overrides: {
                  LinagoraTypographyVariant.h5: const TextStyle(fontSize: 30),
                },
              ),
            ],
          ),
          home: const Scaffold(
            body: LinagoraAlert(title: 'Heads up', message: 'Body'),
          ),
        ),
      );

      expect(tester.widget<Text>(find.text('Heads up')).style!.fontSize, 30);
    });
  });
}
