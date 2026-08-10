import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_item_test_utils.dart';

void main() {
  testWidgets('sizes the badge as a 16px pill, not a block', _badgeIsAPill);
  testWidgets('caps the badge at the width of a full count', _badgeIsCapped);
  testWidgets('takes the badge colour from the style', _badgeUsesStyle);
  testWidgets('does not overflow with a long label and badge', _longLabel);
  testWidgets('grows past the minimum height at a large text scale', _textScale);
  testWidgets('mutes the trailing slot below the label', _trailingIsMuted);
  testWidgets('points the chevron down when expanded', _chevronDirection);
  testWidgets('keeps the chevron beside the label', _chevronHugsLabel);
  testWidgets('prefers leading over icon', _leadingWins);
  testWidgets('keeps the badge before the trailing slot', _badgeThenTrailing);
  testWidgets(
    'lays out a tappable chevron with a narrow custom spacing',
    _narrowSpacing,
  );
  test('compares custom styles by value', _styleEquality);
}

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

Future<void> _textScale(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2.5)),
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
  expect(style.trailingForeground, isNot(style.foreground));
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

Future<void> _chevronHugsLabel(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Personal folders',
      icon: Icons.folder_outlined,
      expanded: true,
      badgeLabel: '5',
    ),
  );

  final label = tester.getRect(find.text('Personal folders'));
  final chevron = tester.getRect(find.byIcon(Icons.keyboard_arrow_down));
  final badge = tester.getRect(find.byType(LinagoraSidebarBadge));
  final row = tester.getRect(sidebarRowFinder);

  final style = LinagoraSidebarStyle.light();
  expect(chevron.left - label.right, closeTo(style.itemSpacing, 1));
  expect(chevron.width, style.chevronSize);
  expect(chevron.right, lessThan(badge.left));
  expect(row.right - badge.right, style.itemHorizontalPadding);
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
    disabledOpacity: style.disabledOpacity,
  );
}

void _styleEquality() {
  expect(_styleWithSpacing(0), _styleWithSpacing(0));
  expect(_styleWithSpacing(0), isNot(_styleWithSpacing(1)));
}
