import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/event/linagora_event_info_row_use_case.dart';

void main() {
  testWidgets('hides the participants until asked', _collapsedByDefault);
  testWidgets('reveals every participant on expand', _expandsTheList);
  testWidgets('collapses again from the hide action', _collapsesAgain);
  testWidgets('names some participants and not others', _mixedDisplayNames);
  testWidgets('toggles from inside the card rows too', _cardRowsToggle);
  testWidgets('greys the calendar glyph', _calendarIconIsGrey);
  testWidgets('explains the warning glyph on hover', _warningTooltip);
  testWidgets('builds the playground from default knobs', _playgroundDefaults);
  testWidgets(
    'forwards playground visibility and spacing knobs',
    _playgroundForwardsKnobs,
  );
  testWidgets(
    'forwards playground dropdown knobs',
    _playgroundForwardsDropdowns,
  );
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

Future<void> _pumpPlayground(
  WidgetTester tester,
  Map<String, String> knobs,
) {
  final state = WidgetbookState(
    root: WidgetbookRoot(children: const []),
    queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
  );

  return tester.pumpWidget(
    MaterialApp(
      home: WidgetbookScope(
        state: state,
        child: const Builder(builder: linagoraEventInfoRowPlaygroundUseCase),
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

Future<void> _playgroundDefaults(WidgetTester tester) async {
  await _pumpPlayground(tester, const {});

  final row = tester.widget<LinagoraEventInfoRow>(
    find.byType(LinagoraEventInfoRow),
  );
  final run = tester.widget<LinagoraEventInfoRun>(
    find.byType(LinagoraEventInfoRun),
  );

  expect(
    (
      hasLabel: row.prefix is LinagoraEventInfoLabel,
      prefixWidth: row.prefixWidth,
      prefixSpacing: row.prefixSpacing,
      trailingSpacing: row.trailingSpacing,
      expand: row.expand,
      trailing: row.trailing,
      runSpacing: run.spacing,
      runChildren: run.children.length,
      venueCount: find
          .text('Villa Good Tech, 37 rue Pierre')
          .evaluate()
          .length,
      linkCount: find.text('See in Map').evaluate().length,
    ),
    const (
      hasLabel: true,
      prefixWidth: LinagoraEventInfoRow.defaultPrefixWidth,
      prefixSpacing: LinagoraEventInfoRow.defaultPrefixSpacing,
      trailingSpacing: LinagoraEventInfoRow.defaultTrailingSpacing,
      expand: false,
      trailing: null,
      runSpacing: LinagoraEventInfoRun.defaultSpacing,
      runChildren: 2,
      venueCount: 1,
      linkCount: 1,
    ),
  );
}

Future<void> _playgroundForwardsKnobs(WidgetTester tester) async {
  await _pumpPlayground(
    tester,
    const {
      'Show prefix': 'false',
      'Fixed prefix column': 'false',
      'Prefix spacing': '20',
      'Value': 'Custom venue',
      'Inline link in content': 'false',
      'Content run spacing': '12',
      'Expand': 'true',
      'Trailing action': 'true',
      'Trailing spacing': '24',
    },
  );

  final row = tester.widget<LinagoraEventInfoRow>(
    find.byType(LinagoraEventInfoRow),
  );
  final run = tester.widget<LinagoraEventInfoRun>(
    find.byType(LinagoraEventInfoRun),
  );

  expect(
    (
      prefix: row.prefix,
      prefixWidth: row.prefixWidth,
      prefixSpacing: row.prefixSpacing,
      trailingSpacing: row.trailingSpacing,
      expand: row.expand,
      hasLinkTrailing: row.trailing is LinagoraEventInfoLink,
      runSpacing: run.spacing,
      runChildren: run.children.length,
      venueCount: find.text('Custom venue').evaluate().length,
      inlineLinkCount: find.text('See in Map').evaluate().length,
      trailingLinkCount: find
          .text('See in your Calendar')
          .evaluate()
          .length,
    ),
    const (
      prefix: null,
      prefixWidth: null,
      prefixSpacing: 20,
      trailingSpacing: 24,
      expand: true,
      hasLinkTrailing: true,
      runSpacing: 12,
      runChildren: 1,
      venueCount: 1,
      inlineLinkCount: 0,
      trailingLinkCount: 1,
    ),
  );
}

Future<void> _playgroundForwardsDropdowns(WidgetTester tester) async {
  await _pumpPlayground(
    tester,
    const {
      'Prefix label': 'Venue',
      'Value emphasis': 'strong',
      'Layout': 'stacked',
      'Cross axis alignment': 'end',
    },
  );

  final row = tester.widget<LinagoraEventInfoRow>(
    find.byType(LinagoraEventInfoRow),
  );
  final value = tester.widget<LinagoraEventInfoText>(
    find.byType(LinagoraEventInfoText),
  );

  expect(
    (
      labelCount: find.text('Venue').evaluate().length,
      layout: row.layout,
      crossAxisAlignment: row.crossAxisAlignment,
      emphasis: value.emphasis,
    ),
    const (
      labelCount: 1,
      layout: LinagoraEventInfoRowLayout.stacked,
      crossAxisAlignment: CrossAxisAlignment.end,
      emphasis: LinagoraEventInfoEmphasis.strong,
    ),
  );
}
