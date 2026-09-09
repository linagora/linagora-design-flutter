import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook_workspace/components/event/linagora_event_card_use_case.dart';

void main() {
  testWidgets('renders the complete card on a desktop frame', _desktopFrame);
  testWidgets('reflows the complete card on a phone frame', _phoneFrame);
  testWidgets('shows every component at once', _showsEveryComponent);
  testWidgets('opens and closes the participant list', _participantsToggle);
  testWidgets('settles on the answer the reader picks', _picksAResponse);
}

Future<void> _pump(WidgetTester tester, Size surface) async {
  await tester.binding.setSurfaceSize(surface);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(body: Builder(builder: linagoraEventCardUseCase)),
    ),
  );
}

Future<void> _desktopFrame(WidgetTester tester) async {
  await _pump(tester, const Size(1440, 900));

  expect(tester.takeException(), isNull);
  expect(find.byType(LinagoraEventDateIcon), findsOneWidget);
}

Future<void> _phoneFrame(WidgetTester tester) async {
  await _pump(tester, const Size(390, 844));

  expect(tester.takeException(), isNull);
  expect(
    find.byType(LinagoraEventDateIcon),
    findsNothing,
    reason: 'the compact card drops the date marker',
  );
}

Future<void> _participantsToggle(WidgetTester tester) async {
  await _pump(tester, const Size(1440, 900));

  expect(find.text('jordan.blake@example.invalid'), findsNothing);

  await tester.tap(find.text('See all participants'));
  await tester.pumpAndSettle();

  expect(find.text('jordan.blake@example.invalid'), findsOneWidget);
  expect(find.text('Jordan Blake'), findsOneWidget);
  expect(find.text('See all participants'), findsNothing);

  await tester.tap(find.text('Hide'));
  await tester.pumpAndSettle();

  expect(find.text('jordan.blake@example.invalid'), findsNothing);
  expect(find.text('See all participants'), findsOneWidget);
}

LinagoraButton _pill(WidgetTester tester, String label) {
  return tester.widget<LinagoraButton>(
    find.ancestor(of: find.text(label), matching: find.byType(LinagoraButton)),
  );
}

Future<void> _picksAResponse(WidgetTester tester) async {
  await _pump(tester, const Size(1440, 900));

  expect(_pill(tester, 'Yes').onPressed, isNotNull);

  await tester.tap(find.text('Yes'));
  await tester.pumpAndSettle();

  expect(_pill(tester, 'Yes').onPressed, isNull, reason: 'the answer settles');
  expect(_pill(tester, 'No').onPressed, isNotNull);

  await tester.tap(find.text('No'));
  await tester.pumpAndSettle();

  expect(_pill(tester, 'No').onPressed, isNull);
  expect(
    _pill(tester, 'Yes').onPressed,
    isNotNull,
    reason: 'changing the answer releases the previous one',
  );
}

Future<void> _showsEveryComponent(WidgetTester tester) async {
  await _pump(tester, const Size(1440, 900));

  for (final label in const [
    'Automated DS Flutter',
    'More information',
    'Join the video conference',
    'When',
    'Where',
    'Who',
    'Yes',
    'Mail to attendees',
    'Propose a new time',
    'See in your Calendar',
  ]) {
    expect(find.text(label), findsOneWidget, reason: 'missing $label');
  }

  expect(find.textContaining('not invited'), findsOneWidget);
}
