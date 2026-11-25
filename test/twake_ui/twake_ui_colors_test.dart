import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'css_color_matcher.dart';

// Source: @linagora/twake-css 1.2.1 palette.json and @linagora/twake-mui
// 19.7.0 dist/lib/makePalette.js. Hex values are the palette.json entries
// that makePalette.js picks; `alpha(x, a)` becomes isCssColor(x, a).
const _grey900 = 0x424244; // palette.json Grey.900, line 89
const _white = 0xFFFFFF; // palette.json Common.white, line 97

/// Every colour token, by its MUI palette path.
Map<String, Color> _tokens(TwakeUiColors c) => {
  'primary.main': c.primary.main,
  'primary.dark': c.primary.dark,
  'primary.light': c.primary.light,
  'primary.contrastText': c.primary.contrastText,
  'secondary.main': c.secondary.main,
  'secondary.dark': c.secondary.dark,
  'secondary.light': c.secondary.light,
  'secondary.contrastText': c.secondary.contrastText,
  'error.main': c.error.main,
  'error.contrastText': c.error.contrastText,
  'warning.main': c.warning.main,
  'warning.contrastText': c.warning.contrastText,
  'success.main': c.success.main,
  'success.contrastText': c.success.contrastText,
  'info.main': c.info.main,
  'info.contrastText': c.info.contrastText,
  'background.default': c.background.defaultColor,
  'background.paper': c.background.paper,
  'text.primary': c.text.primary,
  'text.secondary': c.text.secondary,
  'text.disabled': c.text.disabled,
  'text.icon': c.text.icon,
  'divider': c.divider,
  'border.main': c.border.main,
  'action.hover': c.action.hover,
  'action.selected': c.action.selected,
  'action.focus': c.action.focus,
  'action.disabled': c.action.disabled,
  'action.disabledBackground': c.action.disabledBackground,
};

/// makePalette.js, light branch (lines 104-189).
final _light = <String, Matcher>{
  'primary.main': isCssColor(0x0A84FF), // Primary.600
  'primary.dark': isCssColor(0x006BD8), // Primary.700
  'primary.light': isCssColor(0xD2E9FF), // Primary.200
  'primary.contrastText': isCssColor(_white), // Primary.ContrastText #fff
  'secondary.main': isCssColor(0x7A7781), // Secondary.600
  'secondary.dark': isCssColor(0x64626A), // Secondary.700
  'secondary.light': isCssColor(0xF2F2F3), // Secondary.100
  'secondary.contrastText': isCssColor(_white),
  'error.main': isCssColor(0xFF3347), // Error.600
  'error.contrastText': isCssColor(_white),
  'warning.main': isCssColor(0xFF8F00), // Warning.600
  'warning.contrastText': isCssColor(_white),
  'success.main': isCssColor(0x00C853), // Success.600
  'success.contrastText': isCssColor(_white),
  'info.main': isCssColor(0x00BFA5), // Info.600
  'info.contrastText': isCssColor(_white), // literal '#fff', line 135
  'background.default': isCssColor(0xF3F6F9), // Grey.100
  'background.paper': isCssColor(_white), // Common.white
  'text.primary': isCssColor(_grey900, 0.9),
  'text.secondary': isCssColor(_grey900, 0.64),
  'text.disabled': isCssColor(_grey900, 0.32),
  'text.icon': isCssColor(_grey900, 0.72),
  'divider': isCssColor(_grey900, 0.12),
  'border.main': isCssColor(_grey900, 0.16),
  'action.hover': isCssColor(_grey900, 0.04),
  'action.selected': isCssColor(_grey900, 0.08),
  'action.focus': isCssColor(_grey900, 0.12),
  'action.disabled': isCssColor(_grey900, 0.24),
  'action.disabledBackground': isCssColor(_grey900, 0.12),
};

/// makePalette.js, dark branch (lines 7-102).
final _dark = <String, Matcher>{
  'primary.main': isCssColor(0x7BBDFF), // Primary.400
  'primary.dark': isCssColor(0x46A2FF), // Primary.500
  'primary.light': isCssColor(0xBFDFFF), // Primary.300
  'primary.contrastText': isCssColor(_grey900, 0.9),
  'secondary.main': isCssColor(0xC5C7CA), // Grey.400
  'secondary.dark': isCssColor(0xAAACAE), // Grey.500
  'secondary.light': isCssColor(0xE1E3E6), // Grey.300
  'secondary.contrastText': isCssColor(_grey900, 0.9),
  'error.main': isCssColor(0xFF7A87), // Error.400
  'error.contrastText': isCssColor(_grey900, 0.9),
  'warning.main': isCssColor(0xFFCA28), // Warning.400
  'warning.contrastText': isCssColor(_grey900, 0.9),
  'success.main': isCssColor(0x66E475), // Success.400
  'success.contrastText': isCssColor(_grey900, 0.9),
  'info.main': isCssColor(0x4EE2E5), // Info.400
  'info.contrastText': isCssColor(_grey900, 0.9),
  'background.default': isCssColor(0x2C3039), // Grey.A400
  'background.paper': isCssColor(0x4E5052), // Grey.800
  'text.primary': isCssColor(_white),
  'text.secondary': isCssColor(_white, 0.64),
  'text.disabled': isCssColor(_white, 0.4),
  'text.icon': isCssColor(_white),
  'divider': isCssColor(_white, 0.16),
  'border.main': isCssColor(_white, 0.24),
  'action.hover': isCssColor(_white, 0.08),
  'action.selected': isCssColor(_white, 0.16),
  'action.focus': isCssColor(_white, 0.24),
  'action.disabled': isCssColor(_white, 0.32),
  'action.disabledBackground': isCssColor(_white, 0.12),
};

/// Captures what [TwakeUiColors.of] returns under [theme].
Future<TwakeUiColors> _colorsUnder(WidgetTester tester, ThemeData theme) async {
  late TwakeUiColors found;
  await tester.pumpWidget(
    Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          found = TwakeUiColors.of(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return found;
}

void main() {
  group('the light scheme matches the React app', () {
    for (final entry in _light.entries) {
      test('light ${entry.key}', () {
        expect(_tokens(TwakeUiColors.light)[entry.key], entry.value);
      });
    }
  });

  group('the dark scheme matches the React app', () {
    for (final entry in _dark.entries) {
      test('dark ${entry.key}', () {
        expect(_tokens(TwakeUiColors.dark)[entry.key], entry.value);
      });
    }
  });

  test('the colours plug into a ThemeData as a theme extension', () {
    expect(TwakeUiColors.light, isA<ThemeExtension<TwakeUiColors>>());
    expect(TwakeUiColors.dark, isA<ThemeExtension<TwakeUiColors>>());
  });

  group('of(context)', () {
    testWidgets('returns the colours the theme carries', (tester) async {
      final custom = TwakeUiColors.dark.copyWith(
        divider: const Color(0xFF123456),
      );

      final found = await _colorsUnder(tester, ThemeData(extensions: [custom]));

      expect(found, same(custom));
    });

    testWidgets('returns the light scheme when the theme carries none', (
      tester,
    ) async {
      final found = await _colorsUnder(tester, ThemeData());

      expect(found, same(TwakeUiColors.light));
    });
  });

  group('copyWith', () {
    test('without arguments keeps every colour', () {
      expect(
        _tokens(TwakeUiColors.light.copyWith()),
        _tokens(TwakeUiColors.light),
      );
    });

    test('replaces only the colour it is given', () {
      const pink = Color(0xFFFF00FF);

      final changed = _tokens(TwakeUiColors.light.copyWith(divider: pink));

      expect(changed['divider'], pink);
      expect(
        changed..remove('divider'),
        _tokens(TwakeUiColors.light)..remove('divider'),
      );
    });

    test('replaces a whole group, such as primary', () {
      final changed = _tokens(
        TwakeUiColors.light.copyWith(primary: TwakeUiColors.dark.primary),
      );
      final light = _tokens(TwakeUiColors.light);
      final dark = _tokens(TwakeUiColors.dark);

      for (final key in changed.keys) {
        expect(
          changed[key],
          key.startsWith('primary.') ? dark[key] : light[key],
          reason: key,
        );
      }
    });
  });

  group('lerp', () {
    test('at 0 gives the start scheme', () {
      expect(
        _tokens(TwakeUiColors.light.lerp(TwakeUiColors.dark, 0)),
        _tokens(TwakeUiColors.light),
      );
    });

    test('at 1 gives the end scheme', () {
      expect(
        _tokens(TwakeUiColors.light.lerp(TwakeUiColors.dark, 1)),
        _tokens(TwakeUiColors.dark),
      );
    });

    test('halfway blends every colour with Color.lerp', () {
      final mid = _tokens(TwakeUiColors.light.lerp(TwakeUiColors.dark, 0.5));
      final light = _tokens(TwakeUiColors.light);
      final dark = _tokens(TwakeUiColors.dark);

      for (final key in light.keys) {
        expect(mid[key], Color.lerp(light[key], dark[key], 0.5), reason: key);
      }
    });

    test(
      'towards something that is not TwakeUiColors keeps the start scheme',
      () {
        expect(
          _tokens(TwakeUiColors.light.lerp(null, 0.5)),
          _tokens(TwakeUiColors.light),
        );
      },
    );
  });
}
