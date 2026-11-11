import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/list_item/linagora_person_tile_use_case.dart';

void main() {
  testWidgets('default knobs reach the row', _defaultKnobsReachTheRow);
  testWidgets('avatar and trailing knobs add each slot', _slotsFollowKnobs);
  testWidgets('text knobs reach the row', _textKnobsReachTheRow);
  testWidgets('the selection knob marks the row', _selectionKnob);
  testWidgets('the status knob shows the trailing text', _statusKnob);
  testWidgets('group knobs reach the card', _groupKnobsReachTheCard);
  testWidgets(
      'an empty header drops the group title', _emptyHeaderDropsTheTitle);
  testWidgets('the dark theme picks the dark style', _darkTheme);
}

Future<void> _defaultKnobsReachTheRow(WidgetTester tester) async {
  final tile = await _row(tester, const {});
  expect(tile.name, 'Nora Hale');
  expect(tile.subtitle, 'nora.hale@example.com');
  expect(tile.subtitleMaxLines, 2);
  expect(tile.selected, isNull);
  expect(tile.onTap, isNotNull);
  expect(tile.avatar, isNotNull);
  expect(tile.action, isNotNull);
}

Future<void> _slotsFollowKnobs(WidgetTester tester) async {
  final tile = await _row(tester, const {
    'Avatar': 'false',
    'Trailing': 'none',
    'Tappable': 'false',
  });
  expect(tile.avatar, isNull);
  expect(tile.action, isNull);
  expect(tile.trailing, isNull);
  expect(tile.onTap, isNull);
}

Future<void> _textKnobsReachTheRow(WidgetTester tester) async {
  final tile = await _row(tester, const {
    'Name': 'Mira Calder',
    'Subtitle': 'mira.calder@example.com',
    'Subtitle max lines': '1',
  });
  expect(tile.name, 'Mira Calder');
  expect(tile.subtitle, 'mira.calder@example.com');
  expect(tile.subtitleMaxLines, 1);
}

Future<void> _selectionKnob(WidgetTester tester) async {
  final tile = await _row(tester, const {
    'Selected': 'true',
    'Trailing': 'check',
  });
  expect(tile.selected, isTrue);
  expect(tile.action, isNull);
  expect(tile.trailing, isNotNull);
}

Future<void> _statusKnob(WidgetTester tester) async {
  final tile = await _row(tester, const {'Trailing': 'status'});
  expect(tile.action, isNull);
  expect(tile.trailing, isNotNull);
  expect(find.text('deleted'), findsOneWidget);
}

Future<LinagoraPersonTile> _row(
  WidgetTester tester,
  Map<String, String> knobs,
) async {
  await _pump(tester, _stateWithKnobs(knobs), linagoraPersonTileUseCase);
  return tester.widget<LinagoraPersonTile>(find.byType(LinagoraPersonTile));
}

Future<void> _groupKnobsReachTheCard(WidgetTester tester) async {
  final state = _stateWithKnobs(const {
    'Header': 'Archives',
    'Filled': 'true',
    'Rows': '3',
    'Subtitle': 'true',
    'Remove': 'false',
  });
  await _pump(tester, state, linagoraTileGroupUseCase);

  final group =
      tester.widget<LinagoraTileGroup>(find.byType(LinagoraTileGroup));
  expect(group.filled, isTrue);
  expect(group.children, hasLength(3));
  expect(find.text('Archives'), findsOneWidget);
  expect(
    tester
        .widget<LinagoraPersonTile>(find.byType(LinagoraPersonTile).first)
        .subtitle,
    isNotNull,
  );
  expect(
    tester
        .widget<LinagoraPersonTile>(find.byType(LinagoraPersonTile).first)
        .action,
    isNull,
  );
}

Future<void> _emptyHeaderDropsTheTitle(WidgetTester tester) async {
  final state = _stateWithKnobs(const {'Header': ''});
  await _pump(tester, state, linagoraTileGroupUseCase);

  expect(
    tester.widget<LinagoraTileGroup>(find.byType(LinagoraTileGroup)).header,
    isNull,
  );
}

Future<void> _darkTheme(WidgetTester tester) async {
  await _pump(
    tester,
    _stateWithKnobs(const {}),
    linagoraPersonTileUseCase,
    brightness: Brightness.dark,
  );
  expect(
    tester.widget<LinagoraPersonTile>(find.byType(LinagoraPersonTile)).style,
    LinagoraPersonTileStyle.dark(),
  );

  await _pump(
    tester,
    _stateWithKnobs(const {}),
    linagoraTileGroupUseCase,
    brightness: Brightness.dark,
  );
  expect(
    tester.widget<LinagoraTileGroup>(find.byType(LinagoraTileGroup)).style,
    LinagoraPersonTileStyle.dark(),
  );
}

typedef _UseCaseBuilder = Widget Function(BuildContext context);

Future<void> _pump(
  WidgetTester tester,
  WidgetbookState state,
  _UseCaseBuilder builder, {
  Brightness brightness = Brightness.light,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: WidgetbookScope(
        state: state,
        child: Scaffold(body: Builder(builder: builder)),
      ),
    ),
  );
}

WidgetbookState _stateWithKnobs(Map<String, String> knobs) {
  return WidgetbookState(
    root: WidgetbookRoot(children: const []),
    queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
  );
}
