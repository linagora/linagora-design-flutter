import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets('renders the Figma caption typography', _typography);
  testWidgets('uses the same steel-grey token in dark mode', _darkToken);
  testWidgets('uses an injected sidebar style', _injectedStyle);
  testWidgets('does not overflow a long version string', _overflow);
  testWidgets('renders inside an unbounded-width parent', _unboundedWidth);
  testWidgets('ellipsizes a long line in a bounded Row', _boundedRowOverflow);
  testWidgets(
    'centres itself in a stretched footer column',
    _centresInAStretchedColumn,
  );
}

Future<void> _typography(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarVersion(text: 'version 0.13.2'),
  );

  final text = tester.widget<Text>(find.text('version 0.13.2'));
  expect(text.textAlign, TextAlign.center);
  expect(text.style?.fontSize, 11);
  expect(text.style?.fontWeight, FontWeight.w400);
  expect(
    text.style?.color,
    LinagoraSidebarStyle.light().resolvedStorageVersionForeground,
  );
}

Future<void> _darkToken(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarVersion(text: 'version 0.13.2'),
    surface: const SidebarSurface(brightness: Brightness.dark),
  );

  expect(
    tester.widget<Text>(find.text('version 0.13.2')).style?.color,
    const Color(0xFF818C99),
  );
}

Future<void> _injectedStyle(WidgetTester tester) async {
  const version = Color(0xFF654321);
  const style = LinagoraSidebarStyle(
    itemMinHeight: 36,
    itemBorderRadius: 8,
    itemIconSize: 16,
    itemHorizontalPadding: 8,
    chevronSize: 10,
    itemSpacing: 8,
    hoverBackground: Colors.transparent,
    selectedBackground: Colors.transparent,
    badgeBackground: Colors.transparent,
    badgeHeight: 16,
    badgeHorizontalPadding: 6,
    badgeForeground: version,
    foreground: version,
    activeForeground: version,
    trailingForeground: version,
    labelTextStyle: TextStyle(),
    badgeTextStyle: TextStyle(),
    storageVersionForeground: version,
  );
  await pumpSidebar(
    tester,
    const LinagoraSidebarVersion(text: 'version', style: style),
  );

  expect(tester.widget<Text>(find.text('version')).style?.color, version);
}

Future<void> _overflow(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarVersion(
      text: 'A version string that is far too long for the sidebar footer',
    ),
  );

  expect(tester.takeException(), isNull);
}

/// A SizedBox forcing an infinite width threw here, which ruled out every
/// horizontally unbounded parent a product might reach for.
Future<void> _unboundedWidth(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const Row(children: [LinagoraSidebarVersion(text: 'version 0.13.2')]),
  );

  expect(tester.takeException(), isNull);
  expect(find.text('version 0.13.2'), findsOneWidget);
}

Future<void> _boundedRowOverflow(WidgetTester tester) async {
  const text = 'A version string that is far too long for the sidebar footer';
  await pumpSidebar(
    tester,
    const Row(
      children: [Expanded(child: LinagoraSidebarVersion(text: text))],
    ),
  );

  expect(tester.getSize(find.byType(LinagoraSidebarVersion)).width, sidebarWidth);
  expect(tester.takeException(), isNull);
}

/// A stretched footer column hands the line the full sidebar width, and the
/// text centres itself inside it.
Future<void> _centresInAStretchedColumn(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [LinagoraSidebarVersion(text: 'version 0.13.2')],
    ),
  );

  final line = tester.getRect(find.byType(LinagoraSidebarVersion));
  expect(line.width, sidebarWidth);
  expect(
    tester.getCenter(find.text('version 0.13.2')).dx,
    closeTo(line.center.dx, 0.01),
  );
}
