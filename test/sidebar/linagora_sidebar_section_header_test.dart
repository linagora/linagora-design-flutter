import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets('fills the sidebar using caption typography', _sizeAndTypography);
  testWidgets('publishes its caption as a section header', _headerSemantics);
  testWidgets('resolves secondary header content for dark theme', _darkTypography);
  testWidgets('uses the Figma Text/icon token for light actions', _lightActionColor);
  testWidgets('lets an injected style beat the ambient theme', _injectedStyle);
  testWidgets('derives header tokens for a legacy custom style', _legacyStyle);
  testWidgets('honours header and action color overrides', _colorOverrides);
  testWidgets('renders the disclosure direction from expansion state', _disclosureDirection);
  testWidgets('keeps the disclosure beside the caption either way', _disclosureSpacing);
  testWidgets('forwards disclosure taps with accessible semantics', _disclosureTap);
  testWidgets('publishes a decorative disclosure to semantics', _decorativeDisclosureSemantics);
  testWidgets('places compact actions flush at the trailing edge', _actions);
  testWidgets('preserves action semantics in the compact target', _actionSemantics);
  testWidgets('creates one hover tooltip for an interactive action', _actionTooltip);
  testWidgets('keeps disclosure and compact action targets distinct', _tapTargets);
  testWidgets('keeps actions visible for scaled long titles', _scaledLongTitle);
  testWidgets('omits optional affordances when they are not supplied', _noAffordances);
  testWidgets('mirrors the title and actions in right-to-left layouts', _rightToLeft);
}

Future<void> _sizeAndTypography(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(label: 'Folders'),
  );

  final style = LinagoraSidebarStyle.light();
  final text = tester.widget<Text>(find.text('Folders'));
  final expectedStyle = LinagoraTextTheme.material().labelMedium;

  expect(
    tester.getSize(find.byType(LinagoraSidebarSectionHeader)),
    Size(sidebarWidth, style.sectionHeaderMinHeight),
  );
  expect(text.style?.fontSize, expectedStyle?.fontSize);
  expect(text.style?.fontWeight, expectedStyle?.fontWeight);
  expect(text.style?.letterSpacing, expectedStyle?.letterSpacing);
  expect(text.style?.color, style.resolvedSectionHeaderForeground);
}

Future<void> _headerSemantics(WidgetTester tester) => _expectCaptionSemantics(
  tester,
  const LinagoraSidebarSectionHeader(label: 'Folders'),
  matchesSemantics(label: 'Folders', isHeader: true),
);

Future<void> _darkTypography(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(
      label: 'Folders',
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.add,
          onTap: null,
        ),
      ],
    ),
    surface: const SidebarSurface(brightness: Brightness.dark),
  );

  final expectedColor = LinagoraSidebarStyle.dark().resolvedSectionHeaderForeground;

  expect(tester.widget<Text>(find.text('Folders')).style?.color, expectedColor);
  expect(tester.widget<Icon>(find.byIcon(Icons.add)).color, expectedColor);
}

Future<void> _lightActionColor(WidgetTester tester) async {
  final expectedColor = const Color(0xFF424244).withValues(alpha: 0.64);
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(
      label: 'Folders',
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.search,
          onTap: null,
        ),
      ],
    ),
  );

  expect(tester.widget<Icon>(find.byIcon(Icons.search)).color, expectedColor);
}

/// Actions inherit an injected header style.
Future<void> _injectedStyle(WidgetTester tester) async {
  final injected = LinagoraSidebarStyle.dark();
  await pumpSidebar(
    tester,
    LinagoraSidebarSectionHeader(
      label: 'Folders',
      style: injected,
      actions: const [
        LinagoraSidebarSectionHeaderAction(icon: Icons.add, onTap: null),
      ],
    ),
  );

  expect(
    tester.widget<Text>(find.text('Folders')).style?.color,
    injected.resolvedSectionHeaderForeground,
  );
  expect(
    tester.widget<Icon>(find.byIcon(Icons.add)).color,
    injected.resolvedSectionHeaderForeground,
  );
}

Future<void> _legacyStyle(WidgetTester tester) async {
  const foreground = Color(0xFF123456);
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
    badgeForeground: foreground,
    foreground: foreground,
    activeForeground: foreground,
    trailingForeground: foreground,
    labelTextStyle: TextStyle(),
    badgeTextStyle: TextStyle(),
  );
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(label: 'Folders', style: style),
  );

  expect(style.sectionHeaderMinHeight, LinagoraSidebarControl.tapTarget);
  expect(
    style.resolvedSectionHeaderForeground,
    foreground.withValues(alpha: 0.64),
  );
  expect(
    tester.widget<Text>(find.text('Folders')).style?.color,
    style.resolvedSectionHeaderForeground,
  );
}

Future<void> _colorOverrides(WidgetTester tester) async {
  const headerColor = Color(0xFF123456);
  const actionColor = Color(0xFFABCDEF);
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(
      label: 'Labels',
      foregroundColor: headerColor,
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.add,
          color: actionColor,
          onTap: null,
        ),
      ],
    ),
  );

  expect(tester.widget<Text>(find.text('Labels')).style?.color, headerColor);
  expect(tester.widget<Icon>(find.byIcon(Icons.add)).color, actionColor);
}

Future<void> _disclosureDirection(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(label: 'Folders', expanded: true),
  );
  expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(label: 'Folders', expanded: false),
  );
  expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
}

/// A tappable disclosure never reduces the visual title gap.
Future<void> _disclosureSpacing(WidgetTester tester) async {
  Future<double> gap({required bool tappable}) async {
    await pumpSidebar(
      tester,
      LinagoraSidebarSectionHeader(
        label: 'Folders',
        expanded: true,
        expandToggleLabel: tappable ? 'Collapse folders' : null,
        onExpandToggle: tappable ? _noop : null,
      ),
    );
    final chevron = tester.getRect(find.byIcon(Icons.keyboard_arrow_down));
    return chevron.left - tester.getRect(find.text('Folders')).right;
  }

  expect(
    await gap(tappable: false),
    closeTo(LinagoraSidebarSectionHeader.titleSpacing, 0.5),
  );
  expect(
    await gap(tappable: true),
    greaterThanOrEqualTo(LinagoraSidebarSectionHeader.titleSpacing),
  );
}

Future<void> _disclosureTap(WidgetTester tester) {
  var toggleCount = 0;
  return _withSemantics(tester, () async {
    await pumpSidebar(
      tester,
      LinagoraSidebarSectionHeader(
        label: 'Folders',
        expanded: true,
        expandToggleLabel: 'Collapse folders',
        onExpandToggle: () => toggleCount++,
      ),
    );

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));

    expect(toggleCount, 1);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Collapse folders')),
      matchesSemantics(
        label: 'Collapse folders',
        hasTapAction: true,
        hasFocusAction: true,
        isButton: true,
        isFocusable: true,
        hasExpandedState: true,
        isExpanded: true,
      ),
    );
  });
}

/// Decorative disclosures still announce their state.
Future<void> _decorativeDisclosureSemantics(WidgetTester tester) =>
    _expectCaptionSemantics(
      tester,
      const LinagoraSidebarSectionHeader(label: 'Folders', expanded: false),
      matchesSemantics(
        label: 'Folders',
        hasExpandedState: true,
        isHeader: true,
      ),
    );

Future<void> _actions(WidgetTester tester) async {
  var searchCount = 0;
  var addCount = 0;
  await pumpSidebar(
    tester,
    LinagoraSidebarSectionHeader(
      label: 'Folders',
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.search,
          semanticLabel: 'Search folders',
          onTap: () => searchCount++,
        ),
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.add,
          semanticLabel: 'Add folder',
          onTap: () => addCount++,
        ),
      ],
    ),
  );

  await tester.tap(find.byIcon(Icons.search));
  await tester.tap(find.byIcon(Icons.add));

  final search = tester.getRect(find.byIcon(Icons.search));
  final add = tester.getRect(find.byIcon(Icons.add));
  final searchTarget = _targetFor(Icons.search);
  final addTarget = _targetFor(Icons.add);

  expect(searchCount, 1);
  expect(addCount, 1);
  _expectSquareSize(tester.getSize(searchTarget), 16.67);
  _expectSquareSize(tester.getSize(addTarget), 16.67);
  _expectSquareSize(search.size, 16.67);
  _expectSquareSize(add.size, 16.67);
  expect(tester.getRect(searchTarget).right, tester.getRect(addTarget).left);
  expect(search.right, add.left);
  expect(tester.getRect(addTarget).right, sidebarWidth);
}

Future<void> _actionSemantics(WidgetTester tester) {
  var searchCount = 0;
  return _withSemantics(tester, () async {
    await pumpSidebar(
      tester,
      LinagoraSidebarSectionHeader(
        label: 'Folders',
        actions: [
          LinagoraSidebarSectionHeaderAction(
            icon: Icons.search,
            semanticLabel: 'Search folders',
            onTap: () => searchCount++,
          ),
        ],
      ),
    );

    await tester.tap(find.byIcon(Icons.search));

    expect(searchCount, 1);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Search folders')),
      matchesSemantics(
        label: 'Search folders',
        hasTapAction: true,
        hasFocusAction: true,
        isButton: true,
        isFocusable: true,
      ),
    );
  });
}

Future<void> _actionTooltip(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(
      label: 'Folders',
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.search,
          semanticLabel: 'Search folders',
          onTap: _noop,
        ),
      ],
    ),
  );

  expect(find.byType(Tooltip), findsOneWidget);
  expect(tester.widget<Tooltip>(find.byType(Tooltip)).message, 'Search folders');
}

/// Disclosure retains its accessible target; Figma section actions do not add
/// invisible padding around their 16px glyphs.
Future<void> _tapTargets(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(
      label: 'Folders',
      expanded: true,
      expandToggleLabel: 'Collapse folders',
      onExpandToggle: _noop,
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.add,
          semanticLabel: 'Add folder',
          onTap: _noop,
        ),
      ],
    ),
  );

  final toggleFinder = _targetFor(Icons.keyboard_arrow_down);
  final actionFinder = _targetFor(Icons.add);
  final legacyActionFinder = find.ancestor(
    of: find.byIcon(Icons.add),
    matching: find.byType(LinagoraSidebarControl),
  );
  final toggle = tester.widget<InkResponse>(toggleFinder);
  final action = tester.widget<InkResponse>(actionFinder);

  expect(legacyActionFinder, findsOneWidget);
  expect(tester.getSize(toggleFinder), const Size.square(24));
  _expectSquareSize(tester.getSize(actionFinder), 16.67);
  for (final control in [toggle, action]) {
    expect(control.containedInkWell, isTrue);
    expect(control.highlightShape, BoxShape.circle);
    expect(control.customBorder, isA<CircleBorder>());
  }
}

Future<void> _scaledLongTitle(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2.5)),
        child: Scaffold(
          body: SizedBox(
            width: sidebarWidth,
            child: LinagoraSidebarSectionHeader(
              label: 'A folder title too long for the available sidebar width',
              actions: [
                LinagoraSidebarSectionHeaderAction(
                  icon: Icons.search,
                  semanticLabel: 'Search folders',
                  onTap: _noop,
                ),
                LinagoraSidebarSectionHeaderAction(
                  icon: Icons.add,
                  semanticLabel: 'Add folder',
                  onTap: _noop,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getSize(find.byType(LinagoraSidebarSectionHeader)).height,
    greaterThan(LinagoraSidebarStyle.light().sectionHeaderMinHeight),
  );
  expect(find.byIcon(Icons.search), findsOneWidget);
  expect(find.byIcon(Icons.add), findsOneWidget);
}

Future<void> _noAffordances(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(label: 'Labels'),
  );

  expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
  expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
  expect(find.byType(LinagoraSidebarSectionHeaderAction), findsNothing);
}

Future<void> _rightToLeft(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarSectionHeader(
      label: 'Folders',
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.add,
          semanticLabel: 'Add folder',
          onTap: _noop,
        ),
      ],
    ),
    surface: const SidebarSurface(textDirection: TextDirection.rtl),
  );

  final title = tester.getRect(find.text('Folders'));
  final action = tester.getRect(find.byIcon(Icons.add));

  expect(title.right, sidebarWidth);
  expect(action.left, 0);
}

Finder _targetFor(IconData icon) {
  final target = find.ancestor(
    of: find.byIcon(icon),
    matching: find.byType(InkResponse),
  );
  expect(target, findsOneWidget);
  return target;
}

void _expectSquareSize(Size actual, double expected) {
  expect(actual.width, closeTo(expected, 0.01));
  expect(actual.height, closeTo(expected, 0.01));
}

/// Runs [body] with the semantics tree built, disposing the handle even when
/// an expectation fails.
Future<void> _withSemantics(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  final handle = tester.ensureSemantics();
  try {
    await body();
  } finally {
    handle.dispose();
  }
}

/// Pumps [header] and matches the semantics node its caption belongs to.
Future<void> _expectCaptionSemantics(
  WidgetTester tester,
  LinagoraSidebarSectionHeader header,
  Matcher matcher,
) {
  return _withSemantics(tester, () async {
    await pumpSidebar(tester, header);
    expect(tester.getSemantics(find.text(header.label)), matcher);
  });
}

void _noop() {}
