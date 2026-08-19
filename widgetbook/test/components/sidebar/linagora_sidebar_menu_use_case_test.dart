import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/sidebar/linagora_sidebar_menu_use_case.dart';

void main() {
  testWidgets(
    'a caption knob edited after one storage reload is silently ignored',
    _stuckStorageCaption,
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
