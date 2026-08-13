import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_item_test_utils.dart';

void main() {
  testWidgets('paints the active background and foreground', _active);
  testWidgets(
    'paints nothing until a mouse enters the row',
    onTargetPlatform(TargetPlatform.macOS, _hoverFollowsMouse),
  );
  testWidgets(
    'keeps the selected background while hovered',
    onTargetPlatform(TargetPlatform.macOS, _activeBeatsHover),
  );
  testWidgets('does not hover a row that has no onTap', _nonInteractiveNoHover);
  testWidgets('suppresses hover when hovered is false', _hoverSuppressed);
  testWidgets('pins hover when hovered is true', _hoverForced);
  testWidgets('dims every slot of a disabled row', _disabledDimsUniformly);
  testWidgets('publishes the selected state to semantics', _semanticsSelected);
  testWidgets('honours the colour overrides', _colourOverrides);
  testWidgets('lets an injected style beat the ambient theme', _styleOverride);
  testWidgets('resolves dark tokens from the ambient theme', _darkTokens);
  testWidgets('doubles the overlay opacity in dark', _darkOverlayScale);
}

Future<void> _active(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Inbox',
      icon: Icons.inbox_outlined,
      active: true,
    ),
  );

  expect(
    sidebarBackground(tester),
    LinagoraSidebarStyle.light().selectedBackground,
  );
  expect(
    tester.widget<Text>(find.text('Inbox')).style?.color,
    LinagoraSidebarStyle.light().activeForeground,
  );
  expect(
    tester.getSize(sidebarRowFinder).height,
    LinagoraSidebarStyle.light().itemMinHeight,
  );
}

Future<void> _hoverFollowsMouse(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Starred', onTap: sidebarNoop),
  );

  expect(sidebarBackground(tester), Colors.transparent);

  await hoverSidebarItem(tester, find.text('Starred'));

  expect(sidebarBackground(tester), LinagoraSidebarStyle.light().hoverBackground);
}

Future<void> _activeBeatsHover(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', active: true, onTap: sidebarNoop),
  );

  await hoverSidebarItem(tester, find.text('Inbox'));

  expect(
    sidebarBackground(tester),
    LinagoraSidebarStyle.light().selectedBackground,
  );
}

Future<void> _nonInteractiveNoHover(WidgetTester tester) async {
  await pumpSidebarItem(tester, const LinagoraSidebarItem(label: 'Starred'));

  await hoverSidebarItem(tester, find.text('Starred'));

  expect(sidebarBackground(tester), Colors.transparent);
}

Future<void> _hoverSuppressed(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Spam',
      badgeLabel: '3',
      hoverTrailing: Text('Clean'),
      hovered: false,
      onTap: sidebarNoop,
    ),
  );

  await hoverSidebarItem(tester, find.text('Spam'));

  expect(sidebarBackground(tester), Colors.transparent);
  expect(find.text('3'), findsOneWidget);
  expect(find.text('Clean'), findsNothing);
}

Future<void> _hoverForced(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Inbox',
      hovered: true,
      onTap: sidebarNoop,
    ),
  );

  expect(sidebarBackground(tester), LinagoraSidebarStyle.light().hoverBackground);
}

Future<void> _disabledDimsUniformly(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Archives',
      icon: Icons.folder_outlined,
      badgeLabel: '5',
      expanded: true,
      enabled: false,
    ),
  );

  final opacity = tester.widget<Opacity>(
    find.descendant(
      of: find.byType(LinagoraSidebarItem),
      matching: find.byType(Opacity),
    ),
  );
  expect(opacity.opacity, LinagoraSidebarStyle.light().disabledOpacity);
  expect(
    find.descendant(of: find.byType(Opacity), matching: find.text('5')),
    findsOneWidget,
  );
}

Future<void> _semanticsSelected(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  try {
    await pumpSidebarItem(
      tester,
      const LinagoraSidebarItem(
        label: 'Inbox',
        active: true,
        onTap: sidebarNoop,
      ),
    );

    expect(
      tester.getSemantics(find.byType(LinagoraSidebarItem)),
      matchesSemantics(
        label: 'Inbox',
        hasSelectedState: true,
        isSelected: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
  } finally {
    handle.dispose();
  }
}

Future<void> _colourOverrides(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Inbox',
      active: true,
      activeBackgroundColor: Color(0xFF112233),
      activeForegroundColor: Color(0xFF445566),
    ),
  );

  expect(sidebarBackground(tester), const Color(0xFF112233));
  expect(
    tester.widget<Text>(find.text('Inbox')).style?.color,
    const Color(0xFF445566),
  );
}

Future<void> _styleOverride(WidgetTester tester) async {
  final dark = LinagoraSidebarStyle.dark();
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(label: 'Inbox', active: true, style: dark),
  );

  expect(sidebarBackground(tester), dark.selectedBackground);
  expect(
    tester.widget<Text>(find.text('Inbox')).style?.color,
    dark.activeForeground,
  );
  expect(
    dark.selectedBackground,
    isNot(LinagoraSidebarStyle.light().selectedBackground),
  );
}

Future<void> _darkTokens(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const Scaffold(
        body: SizedBox(
          width: 204,
          child: LinagoraSidebarItem(label: 'Inbox', active: true),
        ),
      ),
    ),
  );

  final dark = LinagoraSidebarStyle.dark();
  expect(sidebarBackground(tester), dark.selectedBackground);
  expect(
    tester.widget<Text>(find.text('Inbox')).style?.color,
    dark.activeForeground,
  );
}

Future<void> _darkOverlayScale(WidgetTester tester) async {
  final light = LinagoraSidebarStyle.light();
  final dark = LinagoraSidebarStyle.dark();

  expect(light.selectedBackground.a, closeTo(0.08, 0.001));
  expect(light.hoverBackground.a, closeTo(0.04, 0.001));
  expect(dark.selectedBackground.a, closeTo(0.16, 0.001));
  expect(dark.hoverBackground.a, closeTo(0.08, 0.001));

  expect(light.badgeBackground, light.selectedBackground);
  expect(dark.badgeBackground, dark.selectedBackground);
}
