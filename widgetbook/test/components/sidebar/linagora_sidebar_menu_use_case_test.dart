import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/sidebar/linagora_sidebar_menu_use_case.dart';

void main() {
  testWidgets(
    'a caption knob edited after one storage reload is silently ignored',
    _stuckStorageCaption,
  );
  testWidgets(
    'reopening a folders section started collapsed shows it pre-expanded',
    _folderPreExpansionIgnoresKnob,
  );
  testWidgets(
    'nested folders render to the configured depth and hide on collapse',
    _folderTreeDepthAndCollapse,
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

/// Regression test for the review finding: `_storageStatus` is set by the
/// reload simulation but never cleared, so it permanently shadows the
/// "Storage caption" knob after the first reload — editing the knob
/// afterward silently does nothing.
Future<void> _stuckStorageCaption(WidgetTester tester) async {
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
  state.queryParams['knobs'] = FieldCodec.encodeQueryGroup(const {
    'Storage caption': 'Updated by user',
  });
  await _pumpCompleteMenu(tester, state);

  expect(find.text('Updated by user'), findsOneWidget);
}

/// Regression test for the review finding: `_expandedFolderIds` seeds full
/// tree expansion from the tree-depth knob alone, regardless of "Initially
/// expand folders". That knob only ever toggles the section header's own
/// flag — a user who turns it off still finds the tree wide open the moment
/// they reopen the section.
Future<void> _folderPreExpansionIgnoresKnob(WidgetTester tester) async {
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
