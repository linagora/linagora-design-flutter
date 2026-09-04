import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/event/linagora_event_date_icon_use_case.dart';

void main() {
  testWidgets(
    'shows input errors and recovers to the updated valid date',
    _dateIconInputValidation,
  );
}

Future<void> _dateIconInputValidation(WidgetTester tester) async {
  final state = _stateWithKnobs();
  await _pumpDateIconUseCase(tester, state);

  expect(find.text('JUN'), findsOneWidget);
  expect(find.text('16'), findsOneWidget);

  state.updateQueryField(
    group: 'knobs',
    field: 'Month',
    value: 'JUN22222',
  );
  await tester.pump();

  expect(
    find.text('Month must contain exactly three characters.'),
    findsOneWidget,
  );

  state.updateQueryField(group: 'knobs', field: 'Month', value: 'SEP');
  state.updateQueryField(group: 'knobs', field: 'Day', value: '32');
  await tester.pump();

  expect(find.text('Day must be a number from 1 to 31.'), findsOneWidget);

  state.updateQueryField(group: 'knobs', field: 'Day', value: '24');
  await tester.pump();

  expect(find.text('SEP'), findsOneWidget);
  expect(find.text('24'), findsOneWidget);
}

Future<void> _pumpDateIconUseCase(
  WidgetTester tester,
  WidgetbookState state,
) {
  return tester.pumpWidget(
    MaterialApp(
      home: WidgetbookScope(
        state: state,
        child: const Builder(builder: linagoraEventDateIconUseCase),
      ),
    ),
  );
}

WidgetbookState _stateWithKnobs() {
  return WidgetbookState(
    root: WidgetbookRoot(children: const []),
    queryParams: {
      'knobs': FieldCodec.encodeQueryGroup(const {}),
    },
  );
}
