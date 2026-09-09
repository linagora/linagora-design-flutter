import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/buttons/linagora_button_use_case.dart';

void main() {
  testWidgets(
    'the invitation bar reflows instead of overflowing on a phone',
    _invitationBarReflowsOnPhone,
  );
  testWidgets(
    'the standard preview knobs reach the button',
    _standardKnobsReachTheButton,
  );
  testWidgets(
    'the dependent knobs only appear once switched on',
    _dependentKnobsFollowTheirSwitches,
  );
}

/// Every knob the panel offers has to land on the button, or it is decoration.
Future<void> _standardKnobsReachTheButton(WidgetTester tester) async {
  final state = _stateWithKnobs(const {
    'Label': 'Send invite',
    'Override corner radius': 'true',
    'Corner radius': '12',
    'Override background': 'true',
    'Background colour': 'FF00AD48',
    'Override label colour': 'true',
    'Label colour': 'FF101010',
    'Icon size': '28',
    'Override icon colour': 'true',
    'Icon colour': 'FF123456',
    'Height': 'Fixed',
    'Height value': '56',
  });
  await _pumpStandard(tester, state);

  final button = tester.widget<LinagoraButton>(find.byType(LinagoraButton));
  expect(button.label, 'Send invite');
  expect(button.borderRadius, 12);
  expect(button.backgroundColor, const Color(0xFF00AD48));
  expect(button.foregroundColor, const Color(0xFF101010));
  expect(button.iconSize, 28);
  expect(button.iconColor, const Color(0xFF123456));
  expect(button.height, 56);
  expect(button.minimumHeight, isNull);
}

Future<void> _dependentKnobsFollowTheirSwitches(WidgetTester tester) async {
  final state = _stateWithKnobs(const {});
  await _pumpStandard(tester, state);

  // Nothing switched on, so none of the dependent knobs are in the panel.
  expect(
    state.knobs.keys,
    isNot(
      anyElement(
        isIn([
          'Corner radius',
          'Background colour',
          'Label colour',
          'Icon colour',
          'Height value',
        ]),
      ),
    ),
  );
  // An icon is picked by default, so its size is offered.
  expect(state.knobs.keys, contains('Icon size'));

  await _rebuildWith(tester, state, field: 'Leading icon', value: 'No icon');
  expect(state.knobs.keys, isNot(contains('Icon size')));

  await _rebuildWith(tester, state, field: 'Height', value: 'Minimum');
  expect(state.knobs.keys, contains('Height value'));

  await _rebuildWith(tester, state, field: 'Override background', value: 'true');
  expect(state.knobs.keys, contains('Background colour'));
}

Future<void> _pumpStandard(WidgetTester tester, WidgetbookState state) {
  return tester.pumpWidget(
    MaterialApp(
      home: WidgetbookScope(
        state: state,
        child: const Scaffold(body: Builder(builder: linagoraButtonUseCase)),
      ),
    ),
  );
}

/// Changes one knob and rebuilds the way Widgetbook's own `UseCaseBuilder`
/// does — clearing the registry first, so it only holds the knobs this build
/// actually registered.
Future<void> _rebuildWith(
  WidgetTester tester,
  WidgetbookState state, {
  required String field,
  required String value,
}) async {
  state.updateQueryField(group: 'knobs', field: field, value: value);
  state.knobs.clear();
  await tester.pump();
}

WidgetbookState _stateWithKnobs(Map<String, String> knobs) {
  return WidgetbookState(
    root: WidgetbookRoot(children: const []),
    queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
  );
}

/// The bar carries more actions than a phone-width viewport fits, so each
/// section has to wrap rather than overflow.
Future<void> _invitationBarReflowsOnPhone(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final state = _stateWithKnobs(const {
    'Presentation': 'Event invitation bar',
  });

  await tester.pumpWidget(
    MaterialApp(
      home: WidgetbookScope(
        state: state,
        child: const Scaffold(
          body: Builder(builder: linagoraButtonUseCase),
        ),
      ),
    ),
  );
  await tester.pump();

  expect(find.text('Yes'), findsOneWidget);
  expect(find.text('See all participants'), findsOneWidget);
  expect(tester.takeException(), isNull);
}
