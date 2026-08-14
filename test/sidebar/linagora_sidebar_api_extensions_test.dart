import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_item_test_utils.dart';
import 'linagora_sidebar_test_utils.dart';

const _svg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M2 2h20v20H2z" fill="#000000"/>
</svg>
''';

void main() {
  testWidgets('supports widget icons and direct button layout', _buttonSlots);
  testWidgets('sizes a button from caller constraints', _buttonConstraints);
  testWidgets(
    'supports widget and generic header action content',
    _headerSlots,
  );
  testWidgets('renders sidebar item supporting text and content', _supporting);
  testWidgets(
    'uses typed generic drag and drop only when configured',
    _dragDrop,
  );
  testWidgets(
    'reveals an asynchronously expanded item in a scroll body',
    _scrollIntoView,
  );
  testWidgets(
    'does not scroll after a failed asynchronous expansion',
    _failedScrollIntoView,
  );
  testWidgets(
    'expands safely without a scroll body',
    _scrollWithoutCoordinator,
  );
  testWidgets('reports sidebar action anchor details', _actionAnchor);
  testWidgets('supports storage loading and a two-line status', _storageStatus);
  testWidgets('reports storage trailing action details', _storageTrailing);
}

Future<void> _buttonSlots(WidgetTester tester) async {
  const outerKey = Key('button-outer');
  const clickableKey = Key('button-clickable');
  const svgKey = Key('button-svg');
  final recorder = _TapRecorder();

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 300,
          child: LinagoraButton(
            key: outerKey,
            buttonKey: clickableKey,
            label: 'Compose',
            icon: Icons.edit,
            iconWidget: SvgPicture.string(_svg, key: svgKey),
            onPressed: recorder.tap,
            outerPadding: const EdgeInsets.symmetric(horizontal: 12),
            width: 120,
            alignment: Alignment.centerRight,
          ),
        ),
      ),
    ),
  );

  // A widget icon replaces the [IconData] slot rather than joining it.
  expect(find.byIcon(Icons.edit), findsNothing);
  expect(tester.getSize(find.byKey(svgKey)), const Size.square(24));

  final layout = (
    width: tester.getSize(find.byKey(clickableKey)).width,
    padding: tester
        .widget<Padding>(
          find
              .descendant(
                of: find.byKey(outerKey),
                matching: find.byType(Padding),
              )
              .first,
        )
        .padding,
  );

  expect(layout, (
    width: 120.0,
    padding: const EdgeInsets.symmetric(horizontal: 12),
  ));

  await tester.tap(find.byKey(clickableKey));

  expect(recorder.count, 1);
}

Future<void> _buttonConstraints(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: LinagoraButton(
          label: 'Constrained',
          onPressed: _noop,
          constraints: BoxConstraints.tightFor(width: 128),
        ),
      ),
    ),
  );

  expect(tester.getSize(find.byType(FilledButton)).width, 128);
}

Future<void> _headerSlots(WidgetTester tester) async {
  const svgKey = Key('header-svg');
  const childKey = Key('header-child');
  final recorder = _TapRecorder();

  await pumpSidebar(
    tester,
    LinagoraSidebarSectionHeader(
      label: 'Folders',
      actions: [
        LinagoraSidebarSectionHeaderAction(
          icon: Icons.add,
          iconWidget: SvgPicture.string(_svg, key: svgKey),
          semanticLabel: 'Add folder',
          onTap: recorder.tap,
        ),
        const LinagoraSidebarSectionHeaderAction(
          onTap: null,
          child: FlutterLogo(key: childKey),
        ),
      ],
    ),
  );

  // A widget icon replaces the [IconData] slot rather than joining it.
  expect(find.byIcon(Icons.add), findsNothing);
  expect(
    (
      icon: tester.getSize(find.byKey(svgKey)),
      child: tester.getSize(find.byKey(childKey)),
    ),
    (icon: const Size.square(16.67), child: const Size.square(16.67)),
  );
  final actionFinder = find.ancestor(
    of: find.byKey(svgKey),
    matching: find.byType(InkResponse),
  );
  expect(actionFinder, findsOneWidget);
  expect(tester.getSize(actionFinder).width, closeTo(16.67, 0.01));
  expect(tester.getSize(actionFinder).height, closeTo(16.67, 0.01));

  await tester.tap(find.byKey(svgKey));

  expect(recorder.count, 1);
}

Future<void> _supporting(WidgetTester tester) async {
  await _pumpItemWidget(
    tester,
    const LinagoraSidebarItem(
      label: 'Design Team',
      supportingText: 'design@linagora.com',
    ),
  );

  expect(find.text('Design Team'), findsOneWidget);
  expect(find.text('design@linagora.com'), findsOneWidget);
  expect(
    tester.getSize(sidebarRowFinder).height,
    greaterThanOrEqualTo(LinagoraSidebarStyle.light().itemMinHeight),
  );

  const contentKey = Key('team-status');
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Design Team',
      supportingText: 'Ignored when custom content is supplied',
      supportingContent: Text('Shared mailbox', key: contentKey),
    ),
  );

  expect(find.byKey(contentKey), findsOneWidget);
  expect(find.text('Ignored when custom content is supplied'), findsNothing);
}

Future<void> _dragDrop(WidgetTester tester) async {
  const sourceKey = Key('drag-source');
  const targetKey = Key('drop-target');
  const value = _DropValue('message-1');
  final recorder = _DropRecorder();

  await _pumpItemWidget(
    tester,
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Draggable<_DropValue>(
          data: value,
          feedback: SizedBox(width: 24, height: 24),
          child: ColoredBox(
            key: sourceKey,
            color: Colors.transparent,
            child: SizedBox(width: 180, height: 36),
          ),
        ),
        LinagoraSidebarItemDropTarget<_DropValue>(
          key: targetKey,
          onWillAcceptDrop: recorder.willAccept,
          onDrop: recorder.drop,
          child: const LinagoraSidebarItem(label: 'Inbox'),
        ),
      ],
    ),
  );

  expect(
    find.byWidgetPredicate((widget) => widget is DragTarget<_DropValue>),
    findsOneWidget,
  );

  final sourceCenter = tester.getCenter(find.byKey(sourceKey));
  final targetCenter = tester.getCenter(find.byKey(targetKey));
  await tester.drag(find.byKey(sourceKey), targetCenter - sourceCenter);
  await tester.pumpAndSettle();

  expect(recorder.accepted, isTrue);
  expect(recorder.details?.data, same(value));
  expect(recorder.details?.offset, isNot(Offset.zero));

  await _pumpItemWidget(
    tester,
    const LinagoraSidebarItem(label: 'No drop target'),
  );

  expect(
    find.byWidgetPredicate((widget) => widget is DragTarget<_DropValue>),
    findsNothing,
  );
}

Future<void> _scrollIntoView(WidgetTester tester) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  var expanded = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: sidebarWidth,
          height: 120,
          child: LinagoraSidebarScrollCoordinator(
            controller: controller,
            child: StatefulBuilder(
              builder: (context, setState) => ListView(
                controller: controller,
                children: [
                  const SizedBox(height: 72),
                  LinagoraSidebarItem(
                    label: 'Projects',
                    expanded: expanded,
                    expandToggleLabel: expanded ? 'Collapse' : 'Expand',
                    scrollIntoViewOnExpand: true,
                    onExpandTogglePressed: (_) async {
                      setState(() => expanded = true);
                    },
                  ),
                  if (expanded)
                    for (var index = 0; index < 5; index++)
                      SizedBox(height: 36, child: Text('Project $index')),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
  await tester.pumpAndSettle();

  expect(expanded, isTrue);
  expect(controller.offset, greaterThan(0));
}

Future<void> _scrollWithoutCoordinator(WidgetTester tester) async {
  var toggles = 0;
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Projects',
      expanded: false,
      expandToggleLabel: 'Expand',
      scrollIntoViewOnExpand: true,
      onExpandToggle: () => toggles++,
    ),
  );

  await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
  await tester.pump();

  expect(toggles, 1);
  expect(tester.takeException(), isNull);
}

Future<void> _failedScrollIntoView(WidgetTester tester) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  final originalOnError = FlutterError.onError;
  FlutterErrorDetails? reportedError;
  FlutterError.onError = (details) => reportedError = details;
  addTearDown(() => FlutterError.onError = originalOnError);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: sidebarWidth,
          height: 120,
          child: LinagoraSidebarScrollCoordinator(
            controller: controller,
            child: ListView(
              controller: controller,
              children: [
                const SizedBox(height: 72),
                LinagoraSidebarItem(
                  label: 'Projects',
                  expanded: false,
                  expandToggleLabel: 'Expand',
                  scrollIntoViewOnExpand: true,
                  onExpandTogglePressed: (_) async {
                    throw StateError('Unable to expand projects');
                  },
                ),
                for (var index = 0; index < 5; index++)
                  SizedBox(height: 36, child: Text('Project $index')),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
  await tester.pumpAndSettle();

  expect(controller.offset, 0);
  expect(reportedError?.exception, isA<StateError>());
}

Future<void> _actionAnchor(WidgetTester tester) async {
  const actionKey = Key('item-action');
  final recorder = _ActionRecorder();

  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      trailing: LinagoraSidebarItemAction(
        semanticLabel: 'More actions',
        onPressed: recorder.press,
        child: const Icon(Icons.more_horiz, key: actionKey),
      ),
    ),
  );

  await tester.tap(find.byKey(actionKey));
  await tester.pump();

  final details = recorder.details;
  expect(details, isNotNull);
  expect(
    details!.globalBounds.size,
    const Size.square(LinagoraSidebarItemAction.minimumDimension),
  );
  // Inside the overlay, so a menu positioned from it stays on screen.
  expect(
    [details.anchor.left, details.anchor.top],
    everyElement(greaterThanOrEqualTo(0)),
  );
}

Future<void> _storageStatus(WidgetTester tester) async {
  const iconKey = Key('storage-svg');
  final handle = tester.ensureSemantics();
  try {
    await pumpSidebar(
      tester,
      LinagoraSidebarStorage(
        label: 'Storage',
        progress: 0.5,
        isLoading: true,
        iconWidget: SvgPicture.string(_svg, key: iconKey),
        status: 'Storage is almost full. Upgrade to keep adding files.',
        statusState: LinagoraSidebarStorageStatusState.warning,
        statusSemanticLabel: 'Storage is almost full',
      ),
    );

    final progress = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    final status = tester.widget<Text>(
      find.text('Storage is almost full. Upgrade to keep adding files.'),
    );

    expect(
      (
        icon: tester.getSize(find.byKey(iconKey)),
        // Null is the indeterminate bar.
        progress: progress.value,
        maxLines: status.maxLines,
        colour: status.style?.color,
      ),
      (
        icon: const Size.square(24),
        progress: null,
        maxLines: 2,
        colour: LinagoraSidebarStyle.light().resolvedProgressWarningColor,
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Storage is almost full')),
      matchesSemantics(label: 'Storage is almost full'),
    );
  } finally {
    handle.dispose();
  }
}

Future<void> _storageTrailing(WidgetTester tester) async {
  const actionKey = Key('storage-action');
  final outerTap = _TapRecorder();
  final trailing = _StorageActionRecorder();

  await pumpSidebar(
    tester,
    LinagoraSidebarStorage(
      label: 'Storage',
      progress: 0.5,
      isLoading: true,
      statusState: LinagoraSidebarStorageStatusState.warning,
      onTap: outerTap.tap,
      trailing: const Icon(Icons.more_horiz, key: actionKey),
      trailingSemanticLabel: 'Storage options',
      onTrailingActionPressed: trailing.press,
    ),
  );

  await tester.tap(find.byKey(actionKey));
  await tester.pump();

  // The trailing action is independent: it must not open the whole block.
  expect(outerTap.count, 0);

  final details = trailing.details;
  expect((details?.label, details?.isLoading, details?.statusState), (
    'Storage',
    true,
    LinagoraSidebarStorageStatusState.warning,
  ));
}

class _TapRecorder {
  int count = 0;

  void tap() => count++;
}

class _DropValue {
  const _DropValue(this.id);

  final String id;
}

class _DropRecorder {
  bool accepted = false;
  LinagoraSidebarItemDropDetails<_DropValue>? details;

  bool willAccept(LinagoraSidebarItemDropDetails<_DropValue> details) {
    accepted = details.data.id == 'message-1';
    return accepted;
  }

  void drop(LinagoraSidebarItemDropDetails<_DropValue> details) {
    this.details = details;
  }
}

class _ActionRecorder {
  LinagoraSidebarActionDetails? details;

  Future<void> press(LinagoraSidebarActionDetails details) async {
    this.details = details;
  }
}

class _StorageActionRecorder {
  LinagoraSidebarStorageActionDetails? details;

  Future<void> press(LinagoraSidebarStorageActionDetails details) async {
    this.details = details;
  }
}

Future<void> _pumpItemWidget(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SizedBox(width: 204, child: child)),
    ),
  );
}

void _noop() {}
