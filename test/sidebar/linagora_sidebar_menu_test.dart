import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets('composes every populated sidebar region', _composesRegions);
  testWidgets(
    'removes empty regions without a scroll view',
    _removesEmptyRegions,
  );
  testWidgets(
    'aligns every sidebar region clear of the scrollbar',
    _alignsContentBounds,
  );
  testWidgets(
    'keeps footer content at the bottom of a bounded menu',
    _pinsFooter,
  );
  testWidgets(
    'constrains auto-scroll targets to the scrolling body',
    _autoScrollTargets,
  );
  testWidgets(
    'drives auto-scroll from the menu controller without product callbacks',
    _autoScrollWithMenuController,
  );
  testWidgets(
    'reveals a newly expanded item inside the menu body',
    _revealsExpandedItem,
  );
  testWidgets('lays out inside an unbounded vertical parent', _unboundedLayout);
  testWidgets(
    'virtualizes a tree list section against the menu viewport',
    _virtualizesTreeSection,
  );
  testWidgets(
    'scrolls a section header away with its tree rows',
    _scrollsHeaderWithTree,
  );
  testWidgets('keeps a collapsed section down to its header', _collapsedSection);
  testWidgets('keeps the spacing rhythm between regions', _sectionRhythm);
  testWidgets('uses injected layout tokens between regions', _customLayout);
  testWidgets(
    'applies an injected scroll physics to the body',
    _appliesCustomPhysics,
  );
  testWidgets(
    'drops a body overlay when the menu lays out unbounded',
    _dropsBodyOverlayWhenUnbounded,
  );
  testWidgets(
    'mirrors the outer inset under RTL while keeping regions aligned',
    _mirrorsInsetUnderRtl,
  );
}

Future<void> _customLayout(WidgetTester tester) async {
  const layout = LinagoraSidebarMenuLayout(
    sectionSpacing: 10,
    scrollContentPadding: EdgeInsetsDirectional.only(end: 4),
  );
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        layout: layout,
        navigationItems: [SizedBox(key: Key('inbox'), height: 36)],
        sections: [
          LinagoraSidebarMenuSection(
            header: SizedBox(key: Key('folders-header'), height: 24),
          ),
        ],
      ),
    ),
  );

  final gap = tester.getTopLeft(find.byKey(const Key('folders-header'))).dy -
      tester.getBottomLeft(find.byKey(const Key('inbox'))).dy;
  expect(gap, closeTo(layout.sectionSpacing, 0.1));
  expect(
    tester.widget<SliverPadding>(find.byType(SliverPadding).first).padding,
    layout.scrollContentPadding,
  );
}

/// The body is one scroll view of slivers, so the gaps that used to be box
/// children between list items now have to be inserted as slivers instead.
Future<void> _sectionRhythm(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 400,
      child: LinagoraSidebarMenu(
        navigationItems: [SizedBox(key: Key('inbox'), height: 36)],
        sections: [
          LinagoraSidebarMenuSection(
            header: SizedBox(key: Key('folders-header'), height: 24),
            children: [SizedBox(key: Key('personal'), height: 36)],
          ),
          LinagoraSidebarMenuSection(
            header: SizedBox(key: Key('labels-header'), height: 24),
          ),
        ],
      ),
    ),
  );

  double gapBetween(String above, String below) =>
      tester.getTopLeft(find.byKey(Key(below))).dy -
      tester.getBottomLeft(find.byKey(Key(above))).dy;

  expect(
    gapBetween('inbox', 'folders-header'),
    closeTo(LinagoraSidebarMenu.sectionSpacing, 0.1),
  );
  expect(
    gapBetween('folders-header', 'personal'),
    closeTo(LinagoraSidebarMenuSection.defaultHeaderSpacing, 0.1),
  );
  expect(
    gapBetween('personal', 'labels-header'),
    closeTo(LinagoraSidebarMenu.sectionSpacing, 0.1),
  );
}

Future<void> _composesRegions(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 400,
      child: LinagoraSidebarMenu(
        primaryAction: Text('Compose'),
        navigationItems: [Text('Inbox'), Text('Sent')],
        sections: [
          LinagoraSidebarMenuSection(
            header: Text('Folders'),
            children: [Text('Personal folders')],
          ),
          LinagoraSidebarMenuSection(header: Text('Labels')),
        ],
        footerItems: [Text('Storage'), Text('version 0.13.2')],
      ),
    ),
  );

  expect(find.text('Compose'), findsOneWidget);
  expect(find.text('Inbox'), findsOneWidget);
  expect(find.text('Sent'), findsOneWidget);
  expect(find.text('Folders'), findsOneWidget);
  expect(find.text('Personal folders'), findsOneWidget);
  expect(find.text('Labels'), findsOneWidget);
  expect(find.text('Storage'), findsOneWidget);
  expect(find.text('version 0.13.2'), findsOneWidget);

  // One scroll view for the whole body: the sections share the navigation
  // viewport rather than nesting their own.
  expect(find.byType(CustomScrollView), findsOneWidget);
  expect(
    tester.widgetList<SliverPadding>(find.byType(SliverPadding)),
    everyElement(
      isA<SliverPadding>().having(
        (padding) => padding.padding,
        'padding',
        LinagoraSidebarMenu.scrollContentPadding,
      ),
    ),
  );
}

Future<void> _alignsContentBounds(WidgetTester tester) async {
  const composeKey = Key('compose');
  const inboxKey = Key('inbox');
  const storageKey = Key('storage');
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        primaryAction: SizedBox(key: composeKey, height: 36),
        navigationItems: [SizedBox(key: inboxKey, height: 36)],
        footerItems: [SizedBox(key: storageKey, height: 36)],
      ),
    ),
  );

  final compose = tester.getRect(find.byKey(composeKey));
  final inbox = tester.getRect(find.byKey(inboxKey));
  final storage = tester.getRect(find.byKey(storageKey));

  // Compose, scrolling rows and pinned footer share the same bounds. The
  // shared end inset leaves room for an overlay scrollbar without making any
  // one region appear narrower than the others.
  for (final bounds in [inbox, storage]) {
    expect(bounds.left, closeTo(compose.left, 0.01));
    expect(bounds.right, closeTo(compose.right, 0.01));
  }
}

Future<void> _removesEmptyRegions(WidgetTester tester) async {
  await pumpSidebar(tester, const LinagoraSidebarMenu());

  expect(find.byType(Scrollable), findsNothing);
  expect(tester.takeException(), isNull);
}

Future<void> _pinsFooter(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        primaryAction: Text('Compose'),
        navigationItems: [Text('Inbox')],
        footerItems: [Text('Storage')],
      ),
    ),
  );

  final menuBottom = tester.getBottomRight(find.byType(LinagoraSidebarMenu)).dy;
  final footerBottom = tester.getBottomRight(find.text('Storage')).dy;
  expect(
    menuBottom - footerBottom,
    closeTo(LinagoraSidebarMenu.verticalPadding, 0.1),
  );
}

Future<void> _autoScrollTargets(WidgetTester tester) async {
  const footerKey = Key('storage');
  var scrollToStartCount = 0;
  var scrollToEndCount = 0;
  var stopScrollingCount = 0;
  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        navigationItems: const [SizedBox(height: 400, child: Text('Inbox'))],
        footerItems: const [SizedBox(key: footerKey, height: 36)],
        bodyOverlay: LinagoraSidebarAutoScrollOverlay(
          isDragging: true,
          canScrollToStart: true,
          canScrollToEnd: true,
          onScrollToStart: () => scrollToStartCount++,
          onScrollToEnd: () => scrollToEndCount++,
          onStopScrolling: () => stopScrollingCount++,
        ),
      ),
    ),
  );

  final body = tester.getRect(find.byType(CustomScrollView));
  final footer = tester.getRect(find.byKey(footerKey));
  final targets = tester
      .widgetList<InkWell>(find.byType(InkWell))
      .toList();

  expect(targets, hasLength(2));

  final startTarget = tester.getRect(find.byWidget(targets.first));
  final endTarget = tester.getRect(find.byWidget(targets.last));

  expect(startTarget.top, closeTo(body.top, 0.1));
  expect(endTarget.bottom, closeTo(body.bottom, 0.1));
  expect(endTarget.bottom, lessThan(footer.top));

  targets.first.onHover!(true);
  targets.last.onHover!(true);
  targets.last.onHover!(false);
  expect(scrollToStartCount, 1);
  expect(scrollToEndCount, 1);
  expect(stopScrollingCount, 1);
}

Future<void> _autoScrollWithMenuController(WidgetTester tester) async {
  final controller = ScrollController();
  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        controller: controller,
        navigationItems: const [SizedBox(height: 600, child: Text('Inbox'))],
        footerItems: const [SizedBox(height: 36, child: Text('Storage'))],
        bodyOverlay: const LinagoraSidebarAutoScrollOverlay(isDragging: true),
      ),
    ),
  );
  await tester.pump();

  controller.jumpTo(80);
  await tester.pump();

  final targets = tester.widgetList<InkWell>(find.byType(InkWell)).toList();
  expect(targets, hasLength(2));

  targets.last.onHover!(true);
  await tester.pumpAndSettle();
  expect(controller.offset, controller.position.maxScrollExtent);
}

Future<void> _revealsExpandedItem(WidgetTester tester) async {
  final controller = ScrollController();
  late BuildContext targetContext;
  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        controller: controller,
        navigationItems: [
          for (var index = 0; index < 10; index++)
            SizedBox(
              height: 36,
              child: index == 9
                  ? Builder(
                      builder: (context) {
                        targetContext = context;
                        return const Text('Project');
                      },
                    )
                  : Text('Mailbox $index'),
            ),
        ],
        footerItems: const [SizedBox(height: 36, child: Text('Storage'))],
      ),
    ),
  );

  LinagoraSidebarScrollCoordinator.scheduleReveal(targetContext);
  await tester.pumpAndSettle();

  expect(controller.offset, greaterThan(0));
}

/// An unbounded parent hands the menu no viewport, so the body sizes to its
/// content and leaves scrolling to that parent.
Future<void> _unboundedLayout(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinagoraSidebarMenu(
          navigationItems: [Text('Inbox')],
          footerItems: [Text('Storage')],
        ),
      ],
    ),
  );

  expect(find.text('Inbox'), findsOneWidget);
  expect(find.text('Storage'), findsOneWidget);
  final body = tester.widget<CustomScrollView>(find.byType(CustomScrollView));
  expect(body.shrinkWrap, isTrue);
  expect(body.physics, isA<NeverScrollableScrollPhysics>());
  expect(tester.takeException(), isNull);
}

/// The point of [LinagoraSidebarMenuSection.sliver]: a production-sized folder
/// tree inside the menu builds only the rows near the menu's own viewport.
Future<void> _virtualizesTreeSection(WidgetTester tester) async {
  var builtRows = 0;
  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        navigationItems: const [SizedBox(height: 36, child: Text('Inbox'))],
        sections: [
          LinagoraSidebarMenuSection(
            header: const Text('Folders'),
            sliver: LinagoraSidebarSliverTreeList<String>(
              entries: _folderEntries(200),
              itemBuilder: (context, entry) {
                builtRows++;
                return SizedBox(height: 36, child: Text(entry.data));
              },
            ),
          ),
        ],
        footerItems: const [Text('Storage')],
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(builtRows, lessThan(200));
  expect(find.text('Folder 0'), findsOneWidget);
  expect(find.text('Folder 199'), findsNothing);
  // The footer stays put while the tree scrolls between it and the navigation.
  expect(find.text('Storage'), findsOneWidget);
}

/// The tree shares the menu's viewport rather than scrolling inside itself, so
/// the header above it travels with the rows.
Future<void> _scrollsHeaderWithTree(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        navigationItems: const [SizedBox(height: 120, child: Text('Inbox'))],
        sections: [
          LinagoraSidebarMenuSection(
            header: const Text('Folders'),
            sliver: LinagoraSidebarSliverTreeList<String>(
              entries: _folderEntries(200),
              itemBuilder: (context, entry) =>
                  SizedBox(height: 36, child: Text(entry.data)),
            ),
          ),
        ],
      ),
    ),
  );

  final headerTop = tester.getTopLeft(find.text('Folders')).dy;
  final rowTop = tester.getTopLeft(find.text('Folder 0')).dy;
  await tester.drag(find.byType(CustomScrollView), const Offset(0, -60));
  await tester.pumpAndSettle();

  expect(tester.getTopLeft(find.text('Folders')).dy, closeTo(headerTop - 60, 1));
  expect(tester.getTopLeft(find.text('Folder 0')).dy, closeTo(rowTop - 60, 1));
}

Future<void> _collapsedSection(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        sections: [LinagoraSidebarMenuSection(header: Text('Folders'))],
      ),
    ),
  );

  expect(find.text('Folders'), findsOneWidget);
  expect(tester.takeException(), isNull);
}

List<LinagoraSidebarTreeListEntry<String>> _folderEntries(int count) => [
  for (var index = 0; index < count; index++)
    LinagoraSidebarTreeListEntry(id: index, data: 'Folder $index'),
];

Future<void> _appliesCustomPhysics(WidgetTester tester) async {
  const physics = BouncingScrollPhysics();
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        navigationItems: [SizedBox(height: 600, child: Text('Inbox'))],
        physics: physics,
      ),
    ),
  );

  expect(
    tester.widget<CustomScrollView>(find.byType(CustomScrollView)).physics,
    same(physics),
  );
}

/// An unbounded parent leaves nothing for the overlay to sit above: the body
/// never scrolls, so nothing should drag it either.
Future<void> _dropsBodyOverlayWhenUnbounded(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinagoraSidebarMenu(
          navigationItems: [Text('Inbox')],
          bodyOverlay: LinagoraSidebarAutoScrollOverlay(isDragging: true),
        ),
      ],
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.text('Inbox'), findsOneWidget);
  expect(find.byType(LinagoraSidebarAutoScrollOverlay), findsNothing);
}

Future<void> _mirrorsInsetUnderRtl(WidgetTester tester) async {
  const composeKey = Key('compose');
  const inboxKey = Key('inbox');
  const storageKey = Key('storage');
  await pumpSidebar(
    tester,
    const SizedBox(
      height: 300,
      child: LinagoraSidebarMenu(
        primaryAction: SizedBox(key: composeKey, height: 36),
        navigationItems: [SizedBox(key: inboxKey, height: 36)],
        footerItems: [SizedBox(key: storageKey, height: 36)],
      ),
    ),
    surface: const SidebarSurface(textDirection: TextDirection.rtl),
  );

  final menu = tester.getRect(find.byType(LinagoraSidebarMenu));
  final compose = tester.getRect(find.byKey(composeKey));
  final inbox = tester.getRect(find.byKey(inboxKey));
  final storage = tester.getRect(find.byKey(storageKey));

  // The outer padding's bare `end` side and each region's own `end`-only
  // scrollbar-clearance inset are both directional, so they land on the same
  // physical side under RTL and keep the total inset symmetric on both
  // edges — same as in LTR. A regression that swapped either for a
  // non-directional EdgeInsets would break that symmetry under RTL only.
  expect(compose.left - menu.left, closeTo(LinagoraSidebarMenu.horizontalPadding, 0.01));
  expect(menu.right - compose.right, closeTo(LinagoraSidebarMenu.horizontalPadding, 0.01));

  // Every region still shares the same bounds as each other under RTL.
  for (final bounds in [inbox, storage]) {
    expect(bounds.left, closeTo(compose.left, 0.01));
    expect(bounds.right, closeTo(compose.right, 0.01));
  }
}
