import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook_workspace/components/event/linagora_event_info_row_use_case.dart';

void main() {
  testWidgets('hides the participants until asked', _collapsedByDefault);
  testWidgets('reveals every participant on expand', _expandsTheList);
  testWidgets('collapses again from the hide action', _collapsesAgain);
  testWidgets('names some participants and not others', _mixedDisplayNames);
  testWidgets('toggles from inside the card rows too', _cardRowsToggle);
  testWidgets('greys the calendar glyph', _calendarIconIsGrey);
  testWidgets('explains the warning glyph on hover', _warningTooltip);
}

/// The design system exports a `WidgetBuilder` of its own, so spell the
/// signature out rather than import an ambiguous name.
typedef _UseCase = Widget Function(BuildContext context);

Future<void> _pumpUseCase(WidgetTester tester, _UseCase useCase) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: Builder(builder: useCase)),
      ),
    ),
  );
}

Future<void> _expand(WidgetTester tester) async {
  await tester.tap(find.text('See all participants'));
  await tester.pumpAndSettle();
}

Future<void> _collapsedByDefault(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraEventInfoRowParticipantsUseCase);

  expect(find.text('See all participants'), findsOneWidget);
  expect(find.text('Hide'), findsNothing);
  expect(find.textContaining('@example.invalid'), findsOneWidget);
}

Future<void> _expandsTheList(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraEventInfoRowParticipantsUseCase);
  await _expand(tester);

  expect(find.text('See all participants'), findsNothing);
  expect(find.text('Hide'), findsOneWidget);
  expect(
    find.textContaining('@example.invalid'),
    findsNWidgets(11),
    reason: 'the organiser plus every participant',
  );
}

Future<void> _collapsesAgain(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraEventInfoRowParticipantsUseCase);
  await _expand(tester);

  await tester.tap(find.text('Hide'));
  await tester.pumpAndSettle();

  expect(find.text('Hide'), findsNothing);
  expect(find.text('See all participants'), findsOneWidget);
  expect(find.textContaining('@example.invalid'), findsOneWidget);
}

Future<void> _mixedDisplayNames(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraEventInfoRowParticipantsUseCase);
  await _expand(tester);

  expect(find.text('Jordan Blake'), findsOneWidget);
  expect(
    find.text('priya.raman@example.invalid'),
    findsOneWidget,
    reason: 'a participant without a name shows the address alone',
  );
  expect(find.text('Priya Raman'), findsNothing);
}

Future<void> _cardRowsToggle(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraEventInfoRowUseCase);

  expect(find.text('Hide'), findsNothing);

  await tester.tap(find.text('See all participants'));
  await tester.pumpAndSettle();

  expect(find.text('Hide'), findsOneWidget);
  expect(find.text('jordan.blake@example.invalid'), findsOneWidget);
}

Future<void> _calendarIconIsGrey(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraEventInfoRowUseCase);

  final button = tester.widget<LinagoraButton>(
    find.ancestor(
      of: find.text('See in your Calendar'),
      matching: find.byType(LinagoraButton),
    ),
  );

  expect(button.iconColor, LinagoraEventInfoColors.secondary);
  expect(
    button.foregroundColor,
    LinagoraEventInfoColors.buttonLabel,
    reason: 'only the glyph is grey; the label stays blue',
  );
}

Future<void> _warningTooltip(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraEventInfoRowUseCase);

  final tooltip = tester.widget<Tooltip>(
    find.ancestor(of: find.byIcon(Icons.error), matching: find.byType(Tooltip)),
  );

  expect(tooltip.message, isNotNull);
  expect(tooltip.message, isNotEmpty);
}
