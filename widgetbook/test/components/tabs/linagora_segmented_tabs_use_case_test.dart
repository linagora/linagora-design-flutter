import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/tabs/linagora_segmented_tabs_use_case.dart';

void main() {
  testWidgets('default knobs reach the tabs', _defaultKnobs);
  testWidgets('the label knobs replace both segments', _labelKnobs);
  testWidgets('empty label knobs reach the tabs', _emptyLabelKnobs);
  testWidgets('the expanded knob shares the width', _expandedKnob);
  testWidgets('tapping a segment selects it', _selectsOnTap);
  testWidgets('the dark theme picks the dark style', _darkTheme);
}

Future<void> _defaultKnobs(WidgetTester tester) async {
  await _pump(tester, const {});

  final tabs = tester.widget<LinagoraSegmentedTabs<int>>(
    find.byType(LinagoraSegmentedTabs<int>),
  );
  expect(tabs.segments.map((segment) => segment.label), [
    'By me',
    'With me',
  ]);
  expect(tabs.expanded, isFalse);
  expect(tabs.selected, 0);
  expect(tabs.style, LinagoraSegmentedTabsStyle.material());
}

Future<void> _labelKnobs(WidgetTester tester) async {
  await _pump(tester, const {
    'First label': 'Mine',
    'Second label': 'Shared',
  });

  expect(find.text('Mine'), findsOneWidget);
  expect(find.text('Shared'), findsOneWidget);
}

Future<void> _emptyLabelKnobs(WidgetTester tester) async {
  await _pump(tester, const {
    'First label': '',
    'Second label': '',
  });

  final tabs = tester.widget<LinagoraSegmentedTabs<int>>(
    find.byType(LinagoraSegmentedTabs<int>),
  );
  expect(tabs.segments.map((segment) => segment.label), ['', '']);
}

Future<void> _expandedKnob(WidgetTester tester) async {
  await _pump(tester, const {'Expanded': 'true'});

  final tabs = tester.widget<LinagoraSegmentedTabs<int>>(
    find.byType(LinagoraSegmentedTabs<int>),
  );
  expect(tabs.expanded, isTrue);
  final first = tester.getSize(find.byKey(LinagoraSegmentedTabs.segmentKey(0)));
  final second =
      tester.getSize(find.byKey(LinagoraSegmentedTabs.segmentKey(1)));
  expect(first.width, second.width);
  expect(first.width, greaterThan(160));
}

Future<void> _selectsOnTap(WidgetTester tester) async {
  await _pump(tester, const {});

  await tester.tap(find.byKey(LinagoraSegmentedTabs.segmentKey(1)));
  await tester.pump();

  expect(
    tester
        .widget<LinagoraSegmentedTabs<int>>(
            find.byType(LinagoraSegmentedTabs<int>))
        .selected,
    1,
  );
}

Future<void> _darkTheme(WidgetTester tester) async {
  await _pump(tester, const {}, brightness: Brightness.dark);

  expect(
    tester
        .widget<LinagoraSegmentedTabs<int>>(
            find.byType(LinagoraSegmentedTabs<int>))
        .style,
    LinagoraSegmentedTabsStyle.dark(),
  );
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, String> knobs, {
  Brightness brightness = Brightness.light,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: WidgetbookScope(
        state: WidgetbookState(
          root: WidgetbookRoot(children: const []),
          queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
        ),
        child: const Scaffold(
            body: Builder(builder: linagoraSegmentedTabsUseCase)),
      ),
    ),
  );
}
