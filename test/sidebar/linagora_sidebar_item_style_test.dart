import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_item_test_utils.dart';

void main() {
  testWidgets('sizes the badge as a 16px pill, not a block', _badgeIsAPill);
  testWidgets('caps the badge at the width of a full count', _badgeIsCapped);
  testWidgets('takes the badge colour from the style', _badgeUsesStyle);
  testWidgets('does not overflow with a long label and badge', _longLabel);
  testWidgets(
    'does not overflow with a long label, chevron, and trailing slot',
    _longLabelWithChevronAndTrailing,
  );
  testWidgets('grows past the minimum height at a large text scale', _textScale);
  testWidgets(
    'grows for multi-line caller supporting content',
    _supportingContentGrows,
  );
  testWidgets('mutes the trailing slot below the label', _trailingIsMuted);
  testWidgets('points the chevron down when expanded', _chevronDirection);
  testWidgets('keeps the chevron beside the label', _chevronHugsLabel);
  testWidgets('insets the badge from the row edge', _badgeHugsTheRowEdge);
  testWidgets('prefers leading over icon', _leadingWins);
  testWidgets('allows a leading icon colour override', _iconColorOverride);
  testWidgets(
    'keeps the leading icon size and gap from the style',
    _iconKeepsStyleGeometry,
  );
  testWidgets('keeps the badge before the trailing slot', _badgeThenTrailing);
  testWidgets(
    'lays out a tappable chevron with a narrow custom spacing',
    _narrowSpacing,
  );
  testWidgets('uses a scoped sidebar theme', _scopedTheme);
  test('mutes the trailing token below the label token', _trailingTokenIsMuted);
  test('copies a sidebar style without changing untouched tokens', _styleCopyWith);
  test('returns an equal style from an empty copy', _styleCopyWithNothing);
  test('copies each sidebar token group', _styleCopyWithGroups);
  test('compares custom styles by value', _styleEquality);
}

Future<void> _scopedTheme(WidgetTester tester) async {
  final style = LinagoraSidebarStyle.light().copyWith(
    item: const LinagoraSidebarItemStyleOverride(
      foreground: Color(0xFF0055AA),
      itemMinHeight: 48,
    ),
  );
  await tester.pumpWidget(
    MaterialApp(
      home: LinagoraSidebarTheme(
        data: style,
        child: const Scaffold(
          body: SizedBox(width: 204, child: LinagoraSidebarItem(label: 'Inbox')),
        ),
      ),
    ),
  );

  expect(tester.widget<Text>(find.text('Inbox')).style?.color, style.foreground);
  expect(tester.getSize(sidebarRowFinder).height, greaterThanOrEqualTo(48));
}

void _styleCopyWith() {
  final base = LinagoraSidebarStyle.light();
  final copy = base.copyWith(
    item: const LinagoraSidebarItemStyleOverride(itemSpacing: 12),
  );

  expect(copy.itemSpacing, 12);
  expect(copy.foreground, base.foreground);
  expect(copy.disabledOpacity, base.disabledOpacity);
}

void _styleCopyWithNothing() {
  final base = LinagoraSidebarStyle.light();

  expect(base.copyWith(), base);
}

void _styleCopyWithGroups() {
  final copy = LinagoraSidebarStyle.light().copyWith(
    item: _itemOverride,
    section: _sectionOverride,
    storage: _storageOverride,
    popover: _popoverOverride,
  );

  _expectItemOverride(copy);
  _expectSectionOverride(copy);
  _expectStorageOverride(copy);
  _expectPopoverOverride(copy);
}

const _itemOverride = LinagoraSidebarItemStyleOverride(
  itemMinHeight: 48,
  itemBorderRadius: 10,
  itemIconSize: 20,
  itemHorizontalPadding: 12,
  chevronSize: 14,
  itemSpacing: 6,
  hoverBackground: Color(0xFF010101),
  selectedBackground: Color(0xFF020202),
  badgeBackground: Color(0xFF030303),
  badgeHeight: 18,
  badgeHorizontalPadding: 7,
  badgeForeground: Color(0xFF040404),
  foreground: Color(0xFF050505),
  activeForeground: Color(0xFF060606),
  trailingForeground: Color(0xFF070707),
  actionActiveBackground: Color(0xFF080808),
  actionIconPadding: 5,
  disabledOpacity: 0.5,
);

const _sectionOverride = LinagoraSidebarSectionStyleOverride(
  headerMinHeight: 44,
  headerForeground: Color(0xFF090909),
);

const _storageOverride = LinagoraSidebarStorageStyleOverride(
  progressHeight: 4,
  foreground: Color(0xFF101010),
  iconForeground: Color(0xFF111111),
  versionForeground: Color(0xFF121212),
  progressColor: Color(0xFF131313),
  progressWarningColor: Color(0xFF141414),
  progressFullColor: Color(0xFF151515),
  progressTrackColor: Color(0xFF161616),
  upsellBorderColor: Color(0xFF171717),
  upsellForeground: Color(0xFF181818),
);

const _popoverOverride = LinagoraSidebarPopoverStyleOverride(
  background: Color(0xFF191919),
  shadow: Color(0xFF202020),
  destructiveBackground: Color(0xFF212121),
  confirmForeground: Color(0xFF222222),
);

/// Asserts every token listed took its value from its override group.
///
/// The mapping is data rather than a run of assertions so a failure names the
/// token that did not survive `copyWith`, instead of reporting a bare colour
/// or number that could belong to any of them.
void _expectTokensFromOverride(Map<String, (Object?, Object?)> tokens) {
  tokens.forEach((token, values) {
    final (actual, expected) = values;
    expect(actual, expected, reason: '$token should come from its override');
  });
}

void _expectItemOverride(LinagoraSidebarStyle style) =>
    _expectTokensFromOverride({
      'itemMinHeight': (style.itemMinHeight, _itemOverride.itemMinHeight),
      'itemBorderRadius': (
        style.itemBorderRadius,
        _itemOverride.itemBorderRadius,
      ),
      'itemIconSize': (style.itemIconSize, _itemOverride.itemIconSize),
      'itemHorizontalPadding': (
        style.itemHorizontalPadding,
        _itemOverride.itemHorizontalPadding,
      ),
      'chevronSize': (style.chevronSize, _itemOverride.chevronSize),
      'itemSpacing': (style.itemSpacing, _itemOverride.itemSpacing),
      'hoverBackground': (style.hoverBackground, _itemOverride.hoverBackground),
      'selectedBackground': (
        style.selectedBackground,
        _itemOverride.selectedBackground,
      ),
      'badgeBackground': (style.badgeBackground, _itemOverride.badgeBackground),
      'badgeHeight': (style.badgeHeight, _itemOverride.badgeHeight),
      'badgeHorizontalPadding': (
        style.badgeHorizontalPadding,
        _itemOverride.badgeHorizontalPadding,
      ),
      'badgeForeground': (style.badgeForeground, _itemOverride.badgeForeground),
      'foreground': (style.foreground, _itemOverride.foreground),
      'activeForeground': (
        style.activeForeground,
        _itemOverride.activeForeground,
      ),
      'trailingForeground': (
        style.trailingForeground,
        _itemOverride.trailingForeground,
      ),
      'actionActiveBackground': (
        style.actionActiveBackground,
        _itemOverride.actionActiveBackground,
      ),
      'actionIconPadding': (
        style.actionIconPadding,
        _itemOverride.actionIconPadding,
      ),
      'disabledOpacity': (style.disabledOpacity, _itemOverride.disabledOpacity),
    });

void _expectSectionOverride(LinagoraSidebarStyle style) =>
    _expectTokensFromOverride({
      'sectionHeaderMinHeight': (
        style.sectionHeaderMinHeight,
        _sectionOverride.headerMinHeight,
      ),
      'sectionHeaderForeground': (
        style.sectionHeaderForeground,
        _sectionOverride.headerForeground,
      ),
    });

void _expectStorageOverride(LinagoraSidebarStyle style) =>
    _expectTokensFromOverride({
      'progressHeight': (style.progressHeight, _storageOverride.progressHeight),
      'storageForeground': (
        style.storageForeground,
        _storageOverride.foreground,
      ),
      'storageIconForeground': (
        style.storageIconForeground,
        _storageOverride.iconForeground,
      ),
      'storageVersionForeground': (
        style.storageVersionForeground,
        _storageOverride.versionForeground,
      ),
      'progressColor': (style.progressColor, _storageOverride.progressColor),
      'progressWarningColor': (
        style.progressWarningColor,
        _storageOverride.progressWarningColor,
      ),
      'progressFullColor': (
        style.progressFullColor,
        _storageOverride.progressFullColor,
      ),
      'progressTrackColor': (
        style.progressTrackColor,
        _storageOverride.progressTrackColor,
      ),
      'upsellBorderColor': (
        style.upsellBorderColor,
        _storageOverride.upsellBorderColor,
      ),
      'upsellForeground': (
        style.upsellForeground,
        _storageOverride.upsellForeground,
      ),
    });

void _expectPopoverOverride(LinagoraSidebarStyle style) =>
    _expectTokensFromOverride({
      'popoverBackground': (
        style.popoverBackground,
        _popoverOverride.background,
      ),
      'popoverShadowColor': (style.popoverShadowColor, _popoverOverride.shadow),
      'destructiveBackground': (
        style.destructiveBackground,
        _popoverOverride.destructiveBackground,
      ),
      'confirmForeground': (
        style.confirmForeground,
        _popoverOverride.confirmForeground,
      ),
    });

Future<void> _badgeIsAPill(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Inbox',
      icon: Icons.inbox_outlined,
      badgeLabel: '999+',
      active: true,
    ),
  );

  final style = LinagoraSidebarStyle.light();
  final badge = tester.getSize(find.byType(LinagoraSidebarBadge));

  expect(badge.height, style.badgeHeight);
  expect(badge.height, lessThan(tester.getSize(sidebarRowFinder).height));
  expect(badge.width, greaterThan(badge.height));
}

Future<void> _badgeIsCapped(WidgetTester tester) async {
  Future<double> widthOf(String badgeLabel) async {
    await pumpSidebarItem(
      tester,
      LinagoraSidebarItem(
        label: 'Inbox',
        icon: Icons.inbox_outlined,
        badgeLabel: badgeLabel,
      ),
    );
    expect(tester.takeException(), isNull);
    return tester.getSize(find.byType(LinagoraSidebarBadge)).width;
  }

  final single = await widthOf('9');
  final capped = await widthOf(LinagoraSidebarBadge.widestLabel);
  final overlong = await widthOf('lklklklklklklklklklklkkklk');

  expect(single, lessThan(capped));
  expect(
    single,
    greaterThanOrEqualTo(LinagoraSidebarStyle.light().badgeHeight),
  );
  expect(overlong, capped);
}

Future<void> _badgeUsesStyle(WidgetTester tester) async {
  final dark = LinagoraSidebarStyle.dark();
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(label: 'Inbox', badgeLabel: '5', style: dark),
  );

  expect(tester.widget<Text>(find.text('5')).style?.color, dark.badgeForeground);
  expect(
    dark.badgeForeground,
    isNot(LinagoraSidebarStyle.light().badgeForeground),
  );
}

Future<void> _longLabel(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'A folder name that is far too long for the available sidebar row',
      icon: Icons.folder_outlined,
      badgeLabel: '999+',
    ),
  );

  expect(tester.takeException(), isNull);
}

Future<void> _longLabelWithChevronAndTrailing(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'A folder name that is far too long for the available sidebar row',
      expanded: true,
      badgeLabel: '999+',
    ),
  );

  expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  expect(tester.takeException(), isNull);
}

Future<void> _textScale(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(3)),
        child: Scaffold(
          body: SizedBox(
            width: 204,
            child: LinagoraSidebarItem(
              label: 'Action required',
              icon: Icons.schedule_outlined,
              onTap: sidebarNoop,
            ),
          ),
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);

  // The row is laid out on the label's glyphs, so it follows the text once
  // they outgrow the minimum — which is the premise this asserts first.
  final minHeight = LinagoraSidebarStyle.light().itemMinHeight;
  expect(
    tester.getSize(find.text('Action required')).height,
    greaterThan(minHeight),
  );
  expect(tester.getSize(sidebarRowFinder).height, greaterThan(minHeight));
}

Future<void> _supportingContentGrows(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 204,
          child: LinagoraSidebarItem(
            label: 'Design Team',
            supportingContent: Text(
              'A caller-owned status that wraps within the available width.',
            ),
          ),
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getSize(sidebarRowFinder).height,
    greaterThan(LinagoraSidebarStyle.light().itemMinHeight),
  );
}

Future<void> _trailingIsMuted(WidgetTester tester) async {
  late Color iconColor;
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      icon: Icons.report_outlined,
      trailing: Builder(
        builder: (context) {
          iconColor = IconTheme.of(context).color!;
          return const Icon(Icons.chevron_right);
        },
      ),
    ),
  );

  final style = LinagoraSidebarStyle.light();
  expect(iconColor, style.trailingForeground);
  expect(tester.widget<Text>(find.text('Spam')).style?.color, style.foreground);
}

/// The token itself, so a palette change is caught here rather than in the
/// layout test that only cares about which slot reads which token.
void _trailingTokenIsMuted() {
  final style = LinagoraSidebarStyle.light();
  expect(style.trailingForeground, isNot(style.foreground));
  expect(style.trailingForeground, const Color(0xA3424242));
}

Future<void> _chevronDirection(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Folders', expanded: true),
  );
  expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Folders', expanded: false),
  );
  expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);

  await pumpSidebarItem(tester, const LinagoraSidebarItem(label: 'Folders'));
  expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
  expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
}

Future<void> _pumpExpandedFolderRow(WidgetTester tester) => pumpSidebarItem(
  tester,
  const LinagoraSidebarItem(
    label: 'Personal folders',
    icon: Icons.folder_outlined,
    expanded: true,
    badgeLabel: '5',
  ),
);

Future<void> _chevronHugsLabel(WidgetTester tester) async {
  await _pumpExpandedFolderRow(tester);

  final label = tester.getRect(find.text('Personal folders'));
  final chevron = tester.getRect(find.byIcon(Icons.keyboard_arrow_down));
  final badge = tester.getRect(find.byType(LinagoraSidebarBadge));

  final style = LinagoraSidebarStyle.light();
  expect(chevron.left - label.right, closeTo(style.itemSpacing, 1));
  expect(chevron.width, style.chevronSize);
  expect(chevron.right, lessThan(badge.left));
}

Future<void> _badgeHugsTheRowEdge(WidgetTester tester) async {
  await _pumpExpandedFolderRow(tester);

  final badge = tester.getRect(find.byType(LinagoraSidebarBadge));
  final row = tester.getRect(sidebarRowFinder);

  expect(
    row.right - badge.right,
    LinagoraSidebarStyle.light().itemHorizontalPadding,
  );
}

Future<void> _leadingWins(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Inbox',
      icon: Icons.inbox_outlined,
      leading: FlutterLogo(),
    ),
  );

  expect(find.byType(FlutterLogo), findsOneWidget);
  expect(find.byIcon(Icons.inbox_outlined), findsNothing);
}

const _overriddenIconColor = Color(0xFF1DBB37);

Future<void> _pumpOverriddenIconRow(WidgetTester tester) => pumpSidebarItem(
  tester,
  const LinagoraSidebarItem(
    label: 'Design',
    icon: Icons.label,
    iconColor: _overriddenIconColor,
  ),
);

Future<void> _iconColorOverride(WidgetTester tester) async {
  await _pumpOverriddenIconRow(tester);

  expect(
    tester.widget<Icon>(find.byIcon(Icons.label)).color,
    _overriddenIconColor,
  );
  expect(
    tester.widget<Text>(find.text('Design')).style?.color,
    LinagoraSidebarStyle.light().foreground,
  );
}

/// An icon colour override changes the colour only: the leading slot keeps the
/// size and gap it takes from the style.
Future<void> _iconKeepsStyleGeometry(WidgetTester tester) async {
  await _pumpOverriddenIconRow(tester);

  final style = LinagoraSidebarStyle.light();
  final iconRect = tester.getRect(find.byIcon(Icons.label));
  final labelRect = tester.getRect(find.text('Design'));

  expect(tester.widget<Icon>(find.byIcon(Icons.label)).size, style.itemIconSize);
  expect(labelRect.left - iconRect.right, closeTo(style.itemSpacing, 0.1));
}

Future<void> _badgeThenTrailing(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Inbox',
      badgeLabel: '5',
      trailing: Icon(Icons.chevron_right),
    ),
  );

  final badge = tester.getRect(find.byType(LinagoraSidebarBadge));
  final trailing = tester.getRect(find.byIcon(Icons.chevron_right));
  expect(badge.right, lessThanOrEqualTo(trailing.left));
}

Future<void> _narrowSpacing(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Folders',
      expanded: false,
      onExpandToggle: sidebarNoop,
      expandToggleLabel: 'Expand',
      style: _styleWithSpacing(0),
    ),
  );

  expect(tester.takeException(), isNull);
}

LinagoraSidebarStyle _styleWithSpacing(double itemSpacing) {
  final style = LinagoraSidebarStyle.light();
  return LinagoraSidebarStyle(
    itemMinHeight: style.itemMinHeight,
    itemBorderRadius: style.itemBorderRadius,
    itemIconSize: style.itemIconSize,
    itemHorizontalPadding: style.itemHorizontalPadding,
    chevronSize: style.chevronSize,
    itemSpacing: itemSpacing,
    hoverBackground: style.hoverBackground,
    selectedBackground: style.selectedBackground,
    badgeBackground: style.badgeBackground,
    badgeHeight: style.badgeHeight,
    badgeHorizontalPadding: style.badgeHorizontalPadding,
    badgeForeground: style.badgeForeground,
    foreground: style.foreground,
    activeForeground: style.activeForeground,
    trailingForeground: style.trailingForeground,
    labelTextStyle: style.labelTextStyle,
    badgeTextStyle: style.badgeTextStyle,
    disabledOpacity: style.disabledOpacity,
  );
}

void _styleEquality() {
  expect(_styleWithSpacing(0), _styleWithSpacing(0));
  expect(_styleWithSpacing(0), isNot(_styleWithSpacing(1)));
}
