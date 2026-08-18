import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _itemOverride = LinagoraSidebarItemStyleOverride(
  itemMinHeight: 44,
  itemBorderRadius: 12,
  itemIconSize: 18,
  itemHorizontalPadding: 10,
  chevronSize: 14,
  itemSpacing: 6,
  hoverBackground: Color(0xFF100001),
  selectedBackground: Color(0xFF100002),
  badgeBackground: Color(0xFF100003),
  badgeHeight: 20,
  badgeHorizontalPadding: 7,
  badgeForeground: Color(0xFF100004),
  foreground: Color(0xFF100005),
  activeForeground: Color(0xFF100006),
  trailingForeground: Color(0xFF100007),
  actionActiveBackground: Color(0xFF100008),
  actionIconPadding: 5,
  disabledOpacity: 0.5,
);

const _sectionOverride = LinagoraSidebarSectionStyleOverride(
  headerMinHeight: 32,
  headerForeground: Color(0xFF200001),
);

const _storageOverride = LinagoraSidebarStorageStyleOverride(
  progressHeight: 5,
  foreground: Color(0xFF300001),
  iconForeground: Color(0xFF300002),
  versionForeground: Color(0xFF300003),
  progressColor: Color(0xFF300004),
  progressWarningColor: Color(0xFF300005),
  progressFullColor: Color(0xFF300006),
  progressTrackColor: Color(0xFF300007),
  upsellBorderColor: Color(0xFF300008),
  upsellForeground: Color(0xFF300009),
);

const _popoverOverride = LinagoraSidebarPopoverStyleOverride(
  background: Color(0xFF400001),
  shadow: Color(0xFF400002),
  destructiveBackground: Color(0xFF400003),
  confirmForeground: Color(0xFF400004),
);

void main() {
  test('applies item style overrides', _itemOverrides);
  test('applies section style overrides', _sectionOverrides);
  test('applies storage style overrides', _storageOverrides);
  test('applies popover style overrides', _popoverOverrides);
  test('preserves typography through an override', _preservesTypography);
  test('keeps the stock trailing ink tokens', _trailingInkTokens);
  testWidgets('provides a sidebar style to descendant widgets', _themeScope);
}

void _itemOverrides() {
  final overridden = LinagoraSidebarStyle.light().copyWith(item: _itemOverride);

  expect(overridden.itemMinHeight, _itemOverride.itemMinHeight);
  expect(overridden.itemBorderRadius, _itemOverride.itemBorderRadius);
  expect(overridden.itemIconSize, _itemOverride.itemIconSize);
  expect(overridden.itemHorizontalPadding, _itemOverride.itemHorizontalPadding);
  expect(overridden.chevronSize, _itemOverride.chevronSize);
  expect(overridden.itemSpacing, _itemOverride.itemSpacing);
  expect(overridden.hoverBackground, _itemOverride.hoverBackground);
  expect(overridden.selectedBackground, _itemOverride.selectedBackground);
  expect(overridden.badgeBackground, _itemOverride.badgeBackground);
  expect(overridden.badgeHeight, _itemOverride.badgeHeight);
  expect(
    overridden.badgeHorizontalPadding,
    _itemOverride.badgeHorizontalPadding,
  );
  expect(overridden.badgeForeground, _itemOverride.badgeForeground);
  expect(overridden.foreground, _itemOverride.foreground);
  expect(overridden.activeForeground, _itemOverride.activeForeground);
  expect(overridden.trailingForeground, _itemOverride.trailingForeground);
  expect(
    overridden.actionActiveBackground,
    _itemOverride.actionActiveBackground,
  );
  expect(overridden.actionIconPadding, _itemOverride.actionIconPadding);
  expect(overridden.disabledOpacity, _itemOverride.disabledOpacity);
}

void _sectionOverrides() {
  final overridden = LinagoraSidebarStyle.light().copyWith(
    section: _sectionOverride,
  );

  expect(overridden.sectionHeaderMinHeight, _sectionOverride.headerMinHeight);
  expect(overridden.sectionHeaderForeground, _sectionOverride.headerForeground);
}

void _storageOverrides() {
  final overridden = LinagoraSidebarStyle.light().copyWith(
    storage: _storageOverride,
  );

  expect(overridden.progressHeight, _storageOverride.progressHeight);
  expect(overridden.storageForeground, _storageOverride.foreground);
  expect(overridden.storageIconForeground, _storageOverride.iconForeground);
  expect(
    overridden.storageVersionForeground,
    _storageOverride.versionForeground,
  );
  expect(overridden.progressColor, _storageOverride.progressColor);
  expect(
    overridden.progressWarningColor,
    _storageOverride.progressWarningColor,
  );
  expect(overridden.progressFullColor, _storageOverride.progressFullColor);
  expect(overridden.progressTrackColor, _storageOverride.progressTrackColor);
  expect(overridden.upsellBorderColor, _storageOverride.upsellBorderColor);
  expect(overridden.upsellForeground, _storageOverride.upsellForeground);
}

void _popoverOverrides() {
  final overridden = LinagoraSidebarStyle.light().copyWith(
    popover: _popoverOverride,
  );

  expect(overridden.popoverBackground, _popoverOverride.background);
  expect(overridden.popoverShadowColor, _popoverOverride.shadow);
  expect(
    overridden.destructiveBackground,
    _popoverOverride.destructiveBackground,
  );
  expect(overridden.confirmForeground, _popoverOverride.confirmForeground);
}

void _preservesTypography() {
  final base = LinagoraSidebarStyle.light();
  final overridden = base.copyWith(item: _itemOverride);

  expect(overridden.labelTextStyle, same(base.labelTextStyle));
  expect(overridden.badgeTextStyle, same(base.badgeTextStyle));
}

void _trailingInkTokens() {
  expect(
    LinagoraSidebarStyle.light().trailingForeground,
    const Color(0xA3424242),
  );
  expect(
    LinagoraSidebarStyle.dark().trailingForeground,
    const Color(0xA3FFFFFF),
  );
}

Future<void> _themeScope(WidgetTester tester) async {
  const foreground = Color(0xFF0055AA);
  final style = LinagoraSidebarStyle.light().copyWith(
    item: const LinagoraSidebarItemStyleOverride(foreground: foreground),
  );

  await tester.pumpWidget(
    MaterialApp(
      home: LinagoraSidebarTheme(
        data: style,
        child: const Scaffold(
          body: SizedBox(
            width: 204,
            child: LinagoraSidebarItem(label: 'Inbox'),
          ),
        ),
      ),
    ),
  );

  expect(tester.widget<Text>(find.text('Inbox')).style?.color, foreground);
}
