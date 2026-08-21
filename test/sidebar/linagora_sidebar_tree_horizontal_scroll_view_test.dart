import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _sidebarWidth = 304.0;

void main() {
  group('LinagoraSidebarTreeHorizontalScrollView', () {
    _testKeepsNonScrollableViewportWithoutOverflow();
    _testExtendsContentAndScrollsWhenTreeOverflows();
    _testAcceptsEveryPointerDevice();
    _testDisablesHorizontalScrollingWhenUnbounded();
    _testResetsOffsetWhenOverflowDisappears();
    _testKeepsVerticalListPositionWhenOverflowStarts();
    _testCreatesViewportForEveryTargetPlatform();
  });
}

void _testKeepsNonScrollableViewportWithoutOverflow() {
  testWidgets('keeps a non-scrollable horizontal viewport without overflow',
      (tester) async {
    await _pumpSidebar(tester, overflowWidth: 0);

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(_horizontalPosition(tester).maxScrollExtent, 0);
    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
    expect(scrollbar.thumbVisibility, isFalse);
    expect(scrollbar.trackVisibility, isFalse);
    expect(scrollbar.interactive, isFalse);
    expect(
      tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      ).physics,
      isA<NeverScrollableScrollPhysics>(),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('tree-content'))).width,
      _sidebarWidth,
    );
  });
}

void _testExtendsContentAndScrollsWhenTreeOverflows() {
  testWidgets('extends content and scrolls when a deep tree overflows',
      (tester) async {
    await _pumpSidebar(tester, overflowWidth: 48);

    expect(
      tester.getSize(find.byKey(const ValueKey('tree-content'))).width,
      _sidebarWidth + 48,
    );
    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
    expect(scrollbar.thumbVisibility, isTrue);
    expect(scrollbar.trackVisibility, isTrue);
    expect(scrollbar.interactive, isTrue);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-48, 0),
    );
    await tester.pump();

    expect(_horizontalPosition(tester).pixels, greaterThan(0));
  });
}

void _testAcceptsEveryPointerDevice() {
  testWidgets('accepts every Flutter pointer device for cross-platform drag',
      (tester) async {
    await _pumpSidebar(tester, overflowWidth: 48);

    final scrollConfiguration = tester.widget<ScrollConfiguration>(
      find.descendant(
        of: find.byType(LinagoraSidebarTreeHorizontalScrollView),
        matching: find.byType(ScrollConfiguration),
      ),
    );

    expect(
      scrollConfiguration.behavior.dragDevices,
      PointerDeviceKind.values.toSet(),
    );
  });
}

void _testDisablesHorizontalScrollingWhenUnbounded() {
  testWidgets('keeps horizontal scrolling disabled when the host is unbounded',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: UnconstrainedBox(
          child: SizedBox(
            height: 240,
            child: LinagoraSidebarTreeHorizontalScrollView(
              overflowWidth: 48,
              child: SizedBox(
                key: ValueKey('unbounded-tree-content'),
                width: _sidebarWidth,
                height: 240,
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();

    expect(_horizontalPosition(tester).maxScrollExtent, 0);
    expect(
      tester
          .getSize(find.byKey(const ValueKey('unbounded-tree-content')))
          .width,
      _sidebarWidth,
    );
  });
}

void _testResetsOffsetWhenOverflowDisappears() {
  testWidgets('resets its offset when overflow disappears', (tester) async {
    var overflowWidth = 48.0;
    late StateSetter setOverflowWidth;

    await tester.pumpWidget(MaterialApp(
      home: StatefulBuilder(builder: (context, setState) {
        setOverflowWidth = setState;
        return SizedBox(
          width: _sidebarWidth,
          height: 240,
          child: LinagoraSidebarTreeHorizontalScrollView(
            overflowWidth: overflowWidth,
            child: const SizedBox(
              key: ValueKey('resettable-tree-content'),
              height: 240,
            ),
          ),
        );
      }),
    ));
    await tester.pump();
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-48, 0),
    );
    await tester.pump();

    expect(_horizontalPosition(tester).pixels, greaterThan(0));

    setOverflowWidth(() => overflowWidth = 0);
    await tester.pump();
    expect(_horizontalPosition(tester).pixels, 0);

    setOverflowWidth(() => overflowWidth = 48);
    await tester.pump();
    expect(_horizontalPosition(tester).pixels, 0);
  });
}

void _testKeepsVerticalListPositionWhenOverflowStarts() {
  testWidgets('keeps the vertical list position when overflow starts',
      (tester) async {
    var overflowWidth = 0.0;
    late StateSetter setOverflowWidth;

    await tester.pumpWidget(MaterialApp(
      home: StatefulBuilder(builder: (context, setState) {
        setOverflowWidth = setState;
        return SizedBox(
          width: _sidebarWidth,
          height: 240,
          child: LinagoraSidebarTreeHorizontalScrollView(
            overflowWidth: overflowWidth,
            child: const _ScrollableSidebarList(),
          ),
        );
      }),
    ));
    await tester.pump();
    final originalListState = tester.state<_ScrollableSidebarListState>(
      find.byType(_ScrollableSidebarList),
    );
    originalListState.controller.jumpTo(320);
    await tester.pump();

    setOverflowWidth(() => overflowWidth = 48);
    await tester.pump();

    final updatedListState = tester.state<_ScrollableSidebarListState>(
      find.byType(_ScrollableSidebarList),
    );
    expect(identical(updatedListState, originalListState), isTrue);
    expect(updatedListState.controller.offset, 320);
    expect(_horizontalPosition(tester).maxScrollExtent, 48);
  });
}

void _testCreatesViewportForEveryTargetPlatform() {
  testWidgets('creates a usable viewport for every Flutter target platform',
      (tester) async {
    try {
      for (final platform in TargetPlatform.values) {
        debugDefaultTargetPlatformOverride = platform;
        await _pumpSidebar(tester, overflowWidth: 48);

        expect(
          find.byType(SingleChildScrollView),
          findsOneWidget,
          reason: 'Expected a horizontal viewport on $platform',
        );
        expect(
          _horizontalPosition(tester).maxScrollExtent,
          greaterThan(0),
          reason: 'Expected horizontal overflow on $platform',
        );
        debugDefaultTargetPlatformOverride = null;
      }
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

Future<void> _pumpSidebar(
  WidgetTester tester, {
  required double overflowWidth,
}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: _sidebarWidth,
        height: 240,
        child: LinagoraSidebarTreeHorizontalScrollView(
          overflowWidth: overflowWidth,
          child: const SizedBox(
            key: ValueKey('tree-content'),
            height: 240,
          ),
        ),
      ),
    ),
  ));
  await tester.pump();
}

ScrollPosition _horizontalPosition(WidgetTester tester) {
  return tester.state<ScrollableState>(
    find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.right,
    ),
  ).position;
}

class _ScrollableSidebarList extends StatefulWidget {
  const _ScrollableSidebarList();

  @override
  State<_ScrollableSidebarList> createState() =>
      _ScrollableSidebarListState();
}

class _ScrollableSidebarListState extends State<_ScrollableSidebarList> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: 40,
      itemExtent: 40,
      itemBuilder: (context, index) => Text('Folder $index'),
    );
  }
}
