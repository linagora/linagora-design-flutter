import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook_workspace/theme/theme_data.dart';

/// Pins what the theme resolves to for both brightnesses, so the sub-theme
/// builders stay equivalent to the single expression they were split from.
void main() {
  final colors = LinagoraSysColors.material();

  ThemeData build(Brightness brightness) {
    return TwakeThemes.buildTheme(
      _FakeContext(),
      brightness,
      colors.onPrimary,
    );
  }

  group('colour scheme', () {
    /// The slots read in a fixed order, so one expectation per brightness
    /// covers the whole pair-picking rather than a test per brightness.
    List<Color> slotsOf(ColorScheme scheme) => [
          scheme.primary,
          scheme.onPrimary,
          scheme.error,
          scheme.surface,
          scheme.outline,
          scheme.inverseSurface,
          scheme.surfaceTint,
          scheme.surfaceContainerHighest,
        ];

    final expected = <Brightness, List<Color>>{
      Brightness.light: [
        colors.primary,
        colors.onPrimary,
        colors.error,
        colors.surface,
        colors.outline,
        colors.inverseSurface,
        colors.surfaceTint,
        colors.surfaceVariant,
      ],
      Brightness.dark: [
        colors.primaryDark,
        colors.onPrimaryDark,
        colors.errorDark,
        colors.surfaceDark,
        colors.outlineDark,
        colors.inverseSurfaceDark,
        colors.surfaceTintDark,
        colors.surfaceVariantDark,
      ],
    };

    test('each brightness takes its own half of every pair', () {
      for (final entry in expected.entries) {
        expect(
          slotsOf(build(entry.key).colorScheme),
          entry.value,
          reason: '${entry.key}',
        );
      }
    });
  });

  group('typography', () {
    test('carries the product text theme and both extensions', () {
      final theme = build(Brightness.light);

      // ThemeData merges the supplied text theme with the Material default,
      // so compare the metrics that identify it rather than the instance.
      final body = theme.textTheme.bodyMedium!;
      expect(
        (body.fontSize, body.fontWeight, body.fontFamily),
        (14.0, FontWeight.w500, 'packages/linagora_design_flutter/TwakeInter'),
      );
      expect(theme.extension<LinagoraTextThemeExtension>(), isNotNull);
      expect(theme.extension<LinagoraTypography>(), isNotNull);
    });

    test('the scale reaches widgets through the theme', () {
      final scale = build(Brightness.light).extension<LinagoraTypography>()!;

      expect(scale.h5, LinagoraTypography.material().h5);
      expect(scale.body2, LinagoraTypography.material().body2);
    });
  });

  group('state-driven sub-themes', () {
    /// Selected and unselected colours for one brightness.
    final switchCases = <Brightness,
        ({Color trackOn, Color trackOff, Color thumbOn, Color thumbOff})>{
      Brightness.light: (
        trackOn: colors.primary,
        trackOff: colors.surface,
        thumbOn: colors.onPrimary,
        thumbOff: colors.outline,
      ),
      Brightness.dark: (
        trackOn: colors.primaryDark,
        trackOff: colors.surfaceDark,
        thumbOn: colors.onPrimaryDark,
        thumbOff: colors.outlineDark,
      ),
    };

    test('switch colours follow the selected state and brightness', () {
      for (final entry in switchCases.entries) {
        final theme = build(entry.key).switchTheme;
        expect(
          (
            theme.trackColor!.resolve({WidgetState.selected}),
            theme.trackColor!.resolve({}),
            theme.thumbColor!.resolve({WidgetState.selected}),
            theme.thumbColor!.resolve({}),
          ),
          (
            entry.value.trackOn,
            entry.value.trackOff,
            entry.value.thumbOn,
            entry.value.thumbOff,
          ),
          reason: '${entry.key}',
        );
      }
    });

    test('navigation bar labels change colour when selected', () {
      final navigation = build(Brightness.light).navigationBarTheme;

      expect(
        navigation.labelTextStyle!.resolve({WidgetState.selected})!.color,
        colors.primary,
      );
      expect(
        navigation.labelTextStyle!.resolve({})!.color,
        colors.tertiary,
      );
      expect(navigation.height, 64);
    });

    test('icon button styling keeps the shared icon size', () {
      final style = build(Brightness.light).iconButtonTheme.style!;

      expect(style.iconSize!.resolve({}), TwakeThemes.iconSize);
      expect(style.iconColor!.resolve({}), colors.onSurface);
    });
  });

  group('remaining sub-themes', () {
    test('bottom navigation labels use the product colours', () {
      final bar = build(Brightness.light).bottomNavigationBarTheme;

      expect(bar.selectedItemColor, colors.primary);
      expect(bar.unselectedItemColor, colors.tertiary);
      expect(bar.selectedLabelStyle!.color, colors.primary);
      expect(bar.unselectedLabelStyle!.fontSize, 11);
    });

    test('bottom sheet paints its tint in its own background', () {
      final sheet = build(Brightness.dark).bottomSheetTheme;

      expect(sheet.backgroundColor, colors.backgroundDark);
      expect(sheet.surfaceTintColor, sheet.backgroundColor);
    });

    test('app bar follows brightness for its foreground', () {
      expect(
        build(Brightness.light).appBarTheme.foregroundColor,
        colors.onBackground,
      );
      expect(
        build(Brightness.dark).appBarTheme.foregroundColor,
        colors.onBackgroundDark,
      );
    });

    test('icon theme keeps the shared size', () {
      expect(build(Brightness.light).iconTheme.size, TwakeThemes.iconSize);
    });
  });
}

/// [TwakeThemes.buildTheme] takes a context it never reads, so the tests
/// hand it a stand-in rather than pumping a widget for every case.
class _FakeContext extends Fake implements BuildContext {}
