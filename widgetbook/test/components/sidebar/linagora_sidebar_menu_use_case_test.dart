import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/sidebar/linagora_sidebar_menu_use_case.dart';

void main() {
  testWidgets(
    'uses a caption knob edited after a storage reload',
    _storageCaptionUpdatesAfterReload,
  );
  testWidgets(
    'does not pre-expand a folders tree configured to start collapsed',
    _collapsedFoldersDoNotPreExpand,
  );
  testWidgets(
    'nested folders render to the configured depth and hide on collapse',
    _folderTreeDepthAndCollapse,
  );
  testWidgets(
    'aligns Compose with the active navigation row',
    _composerAlignsWithActiveNavigation,
  );
  testWidgets(
    'shows the menu horizontal scrollbar for a deep folder tree',
    _deepFolderTreeUsesHorizontalScrollbar,
  );
}

/// Pumps the 'Complete menu' use case through a minimal Widgetbook host —
/// the only way to reach its knob-driven, file-private preview state.
///
/// The viewport is set tall on the first pump so every section, including
/// ones below the navigation list, actually builds instead of staying
/// unmounted past the sliver viewport's cache extent.
Future<void> _pumpCompleteMenu(WidgetTester tester, WidgetbookState state) {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  return tester.pumpWidget(
    MaterialApp(
      home: WidgetbookScope(
        state: state,
        child: const Builder(builder: linagoraSidebarMenuUseCase),
      ),
    ),
  );
}

/// Forces the sidebar tall enough that every section lays out and builds,
/// regardless of what the test's own knob overrides ask for.
WidgetbookState _stateWithKnobs(Map<String, String> knobs) {
  return WidgetbookState(
    root: WidgetbookRoot(children: const []),
    queryParams: {
      'knobs': FieldCodec.encodeQueryGroup({
        'Sidebar height': '2000',
        ...knobs,
      }),
    },
  );
}

/// A caption knob changed after the reload takes precedence over the temporary
/// reload status.
Future<void> _storageCaptionUpdatesAfterReload(WidgetTester tester) async {
  final state = _stateWithKnobs(const {});
  await _pumpCompleteMenu(tester, state);

  expect(find.text('497.28 Go disponible'), findsOneWidget);

  await tester.tap(find.bySemanticsLabel('Reload storage'));
  await tester.pump();
  expect(find.text('Refreshing storage…'), findsOneWidget);

  await tester.pump(const Duration(milliseconds: 750));
  expect(find.text('Storage refreshed'), findsOneWidget);

  // A user editing the caption knob after that reload expects the row to
  // pick it up, the same as it did before the reload was ever tapped.
  state.updateQueryField(
    group: 'knobs',
    field: 'Storage caption',
    value: 'Updated by user',
  );
  await tester.pump();

  expect(find.text('Updated by user'), findsOneWidget);
}

/// Reopening a section configured to start collapsed reveals only its root.
Future<void> _collapsedFoldersDoNotPreExpand(WidgetTester tester) async {
  final state = _stateWithKnobs(const {'Initially expand folders': 'false'});
  await _pumpCompleteMenu(tester, state);

  // Starts collapsed, as asked: no folder rows at all yet.
  expect(find.text('Personal folders'), findsNothing);

  await tester.tap(find.bySemanticsLabel('Expand folders'));
  await tester.pump();

  // Reopening should reveal the top level only, not an already-drilled-down
  // tree the knob said to start collapsed.
  expect(find.text('Personal folders'), findsOneWidget);
  expect(find.text('Project'), findsNothing);
}

/// Characterization test for the coverage gap flagged in review: the
/// mutually-recursive folder-flattening builders (`_folderEntries` /
/// `_projectSubfolders` / `_nestedProjectFolders`) had no test at all. Pins
/// that nested rows render down to the configured depth, and that collapsing
/// their parent removes them again — the exact recursion this logic exists
/// for.
Future<void> _folderTreeDepthAndCollapse(WidgetTester tester) async {
  final state = _stateWithKnobs(const {'Project tree depth': '4'});
  await _pumpCompleteMenu(tester, state);

  expect(find.text('Nested folder 3'), findsOneWidget);
  expect(find.text('Nested folder 4'), findsOneWidget);

  await tester.tap(find.bySemanticsLabel('Collapse Design'));
  await tester.pump();

  expect(find.text('Nested folder 3'), findsNothing);
  expect(find.text('Nested folder 4'), findsNothing);
}

Future<void> _composerAlignsWithActiveNavigation(WidgetTester tester) async {
  await _pumpCompleteMenu(tester, _stateWithKnobs(const {}));

  final compose = tester.getRect(find.byType(FilledButton));
  final inbox = tester.getRect(
    find.ancestor(
      of: find.text('Inbox'),
      matching: find.byType(LinagoraSidebarItem),
    ),
  );

  expect(compose.left, closeTo(inbox.left, 0.01));
  expect(compose.right, closeTo(inbox.right, 0.01));
}

Future<void> _deepFolderTreeUsesHorizontalScrollbar(
  WidgetTester tester,
) async {
  await _pumpCompleteMenu(
    tester,
    _stateWithKnobs(const {'Project tree depth': '12'}),
  );

  final viewport = find.descendant(
    of: find.byType(LinagoraSidebarMenu),
    matching: find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.right,
    ),
  );
  final scrollbar = tester.widget<Scrollbar>(
    find.descendant(
      of: find.byType(LinagoraSidebarMenu),
      matching: find.byType(Scrollbar),
    ),
  );

  expect(viewport, findsOneWidget);
  expect(tester.state<ScrollableState>(viewport).position.maxScrollExtent,
      greaterThan(0));
  expect(scrollbar.thumbVisibility, isTrue);
  expect(scrollbar.trackVisibility, isTrue);
  expect(scrollbar.interactive, isTrue);
}
