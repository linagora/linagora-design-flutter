import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets('renders every section it is given', _rendersEverySection);
  testWidgets('renders nothing for an empty event', _emptyEvent);
  for (final omission in _omissions) {
    testWidgets(omission.description, omission.verify);
  }
  testWidgets('drops a detail row with no content', _dropsEmptyDetail);
  testWidgets('renders any subset of the detail rows', _detailSubset);
  testWidgets('shows whatever label the data carries', _customLabels);
  testWidgets('labels the action row from the data', _customAttendingLabel);
  testWidgets('holds the column for a blank label', _blankLabelHoldsColumn);
  testWidgets('renders any subset of the action buttons', _actionSubset);
  testWidgets('lines an unlabelled row up with the labelled ones', _emptyLabelColumn);
  testWidgets('shows a status notice under the rows', _statusNotice);
  testWidgets('stacks extra value lines under the first', _detailExtraLines);
  testWidgets('hides the date marker when compact', _compactHidesDate);
  testWidgets('stacks the labels when compact', _compactStacksLabels);
  testWidgets('keeps labels beside values when regular', _regularKeepsInline);
  testWidgets(
    'keeps the conference clear of a full-width badge',
    _headerKeepsItsGap,
  );
  testWidgets('goes compact under the breakpoint', _adaptiveGoesCompact);
  testWidgets(
    'fits a pinned regular layout into a narrow card',
    _regularSurvivesNarrowWidth,
  );
  testWidgets(
    'settles only the chosen response',
    _selectionSettlesOnlyTheChosenResponse,
  );
  testWidgets('reports a response tap', _reportsResponseTap);
  testWidgets('reports a tap on an actionable value', _reportsValueTap);
  testWidgets(
    'reports a tap on a value in an extra line',
    _reportsExtraLineValueTap,
  );
  testWidgets('leaves a plain value inert', _plainValueIsInert);
  testWidgets('renders content from a card data object', _rendersFromData);
  testWidgets(
    'expands and collapses detail lines inside the card',
    _expandsAndCollapsesDetailLines,
  );
  testWidgets(
    'shows every detail line below the collapse threshold',
    _showsLinesBelowCollapseThreshold,
  );
  testWidgets(
    'resets detail expansion when its identity changes',
    _resetsExpansionForNewIdentity,
  );
  test('rejects a negative border radius', _rejectsNegativeRadius);
  test('rejects invalid detail expansion configuration', _invalidExpansion);
}

const _date = LinagoraEventDate(month: 'Jun', day: '16');

const _details = [
  LinagoraEventDetail(
    label: 'When',
    values: [LinagoraEventValue.strong('Tuesday, Jun 16')],
  ),
  LinagoraEventDetail(
    label: 'Where',
    values: [LinagoraEventValue('Villa Good Tech')],
    action: LinagoraEventAction(label: 'See in Map'),
  ),
];

const _attending = LinagoraEventAttending(
  label: 'Attending?',
  responses: [
    LinagoraEventAction(label: 'Yes'),
    LinagoraEventAction(label: 'No'),
  ],
  secondaryAction: LinagoraEventAction(label: 'Propose a new time'),
);

Widget _host(Widget child, {double width = 1000}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

/// A section a card can leave out.
enum _Section { date, activity, moreInformation, conference, details, attending, calendar }

/// A fully populated card, minus the sections named in [hidden].
///
/// [details] and [attending] replace their fixture rather than hiding it; use
/// [hidden] to drop the section entirely.
LinagoraEventCard _card({
  Set<_Section> hidden = const {},
  List<LinagoraEventDetail>? details,
  LinagoraEventAttending? attending,
  LinagoraEventCardLayout layout = LinagoraEventCardLayout.regular,
}) {
  bool shows(_Section section) => !hidden.contains(section);

  return LinagoraEventCard(
    date: shows(_Section.date) ? _date : null,
    activity: shows(_Section.activity)
        ? 'has invited you in to a meeting'
        : null,
    actorName: shows(_Section.activity) ? 'Alex Martin' : null,
    title: 'Automated DS Flutter',
    moreInformation: shows(_Section.moreInformation)
        ? const LinagoraEventAction(label: 'More information')
        : null,
    conference: shows(_Section.conference)
        ? const LinagoraEventConference(
            join: LinagoraEventAction(label: 'Join the video conference'),
          )
        : null,
    details: shows(_Section.details) ? (details ?? _details) : const [],
    attending: shows(_Section.attending) ? (attending ?? _attending) : null,

    calendarAction: shows(_Section.calendar)
        ? const LinagoraEventAction(label: 'See in your Calendar')
        : null,
    layout: layout,
  );
}

Future<void> _rendersEverySection(WidgetTester tester) async {
  await tester.pumpWidget(_host(_card()));

  expect(find.byType(LinagoraEventDateIcon), findsOneWidget);
  expect(find.textContaining('Alex Martin'), findsOneWidget);
  expect(find.text('Automated DS Flutter'), findsOneWidget);
  expect(find.text('More information'), findsOneWidget);
  expect(find.text('Join the video conference'), findsOneWidget);
  expect(find.text('When'), findsOneWidget);
  expect(find.text('See in Map'), findsOneWidget);
  expect(find.text('Attending?'), findsOneWidget);
  expect(find.text('Propose a new time'), findsOneWidget);
  expect(find.text('See in your Calendar'), findsOneWidget);
}

Future<void> _emptyEvent(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventCard(layout: LinagoraEventCardLayout.regular),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.byType(Text), findsNothing);
}

/// One hidden section and the text that must disappear with it.
class _Omission {
  final String description;
  final LinagoraEventCard card;
  final String absent;

  const _Omission({
    required this.description,
    required this.card,
    required this.absent,
  });

  Future<void> verify(WidgetTester tester) async {
    await tester.pumpWidget(_host(card));

    expect(tester.takeException(), isNull);
    expect(find.textContaining(absent), findsNothing);
    expect(
      find.text('Automated DS Flutter'),
      findsOneWidget,
      reason: 'the rest of the card survives',
    );
  }
}

final _omissions = <_Omission>[
  _Omission(
    description: 'omits the activity badge',
    card: _card(hidden: {_Section.activity}),
    absent: 'Alex Martin',
  ),
  _Omission(
    description: 'omits the more information link',
    card: _card(hidden: {_Section.moreInformation}),
    absent: 'More information',
  ),
  _Omission(
    description: 'omits the conference actions',
    card: _card(hidden: {_Section.conference}),
    absent: 'Join the video conference',
  ),
  _Omission(
    description: 'omits the detail rows',
    card: _card(hidden: {_Section.details}),
    absent: 'When',
  ),
  _Omission(
    description: 'omits the attending block',
    card: _card(hidden: {_Section.attending}),
    absent: 'Attending?',
  ),
  _Omission(
    description: 'omits the calendar action',
    card: _card(hidden: {_Section.calendar}),
    absent: 'See in your Calendar',
  ),
];

Future<void> _dropsEmptyDetail(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _card(
        details: const [
          LinagoraEventDetail(label: 'Where'),
          LinagoraEventDetail(
            label: 'Who',
            values: [LinagoraEventValue('Alex Martin')],
          ),
        ],
      ),
    ),
  );

  expect(
    find.text('Where'),
    findsNothing,
    reason: 'a label with no value would render a dangling row',
  );
  expect(find.text('Who'), findsOneWidget);
}

Future<void> _detailSubset(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _card(
        details: const [
          LinagoraEventDetail(
            label: 'When',
            values: [LinagoraEventValue('Tuesday, Jun 16')],
          ),
        ],
      ),
    ),
  );

  expect(find.text('When'), findsOneWidget);
  expect(find.text('Where'), findsNothing);
  expect(find.text('Who'), findsNothing);
  expect(
    find.text('See in Map'),
    findsNothing,
    reason: 'a link belongs to its row and leaves with it',
  );
  expect(find.text('See all participants'), findsNothing);
}

Future<void> _customLabels(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        prefixWidth: 140,
        details: [
          LinagoraEventDetail(
            label: 'Quand',
            values: [LinagoraEventValue('Tuesday, Jun 16')],
          ),
          LinagoraEventDetail(
            label: 'Où',
            values: [LinagoraEventValue('Villa Good Tech')],
          ),
        ],
      ),
    ),
  );

  expect(find.text('Quand'), findsOneWidget);
  expect(find.text('Où'), findsOneWidget);
  expect(find.text('When'), findsNothing);
  expect(
    tester.getTopLeft(find.text('Villa Good Tech')).dx,
    tester.getTopLeft(find.text('Tuesday, Jun 16')).dx,
    reason: 'labels of different widths keep one value column',
  );
}

Future<void> _customAttendingLabel(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _card(
        attending: const LinagoraEventAttending(
          label: 'Participez ?',
          responses: [LinagoraEventAction(label: 'Oui')],
        ),
      ),
    ),
  );

  expect(find.text('Participez ?'), findsOneWidget);
  expect(find.text('Attending?'), findsNothing);
  expect(
    tester.getTopLeft(find.text('Participez ?')).dx,
    tester.getTopLeft(find.text('When')).dx,
    reason: 'the action row label shares the detail rows column',
  );
}

Future<void> _blankLabelHoldsColumn(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        details: [
          LinagoraEventDetail(
            label: 'When',
            values: [LinagoraEventValue('Tuesday, Jun 16')],
          ),
          LinagoraEventDetail(
            values: [LinagoraEventValue('Villa Good Tech')],
          ),
        ],
      ),
    ),
  );

  expect(
    tester.getTopLeft(find.text('Villa Good Tech')).dx,
    tester.getTopLeft(find.text('Tuesday, Jun 16')).dx,
    reason: 'an unlabelled row keeps its place in the column',
  );
}

Future<void> _actionSubset(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        title: 'Automated DS Flutter',
        attending: LinagoraEventAttending(
          responses: [LinagoraEventAction(label: 'Maybe')],
        ),
        actions: [LinagoraEventAction(label: 'Mail to attendees')],
      ),
    ),
  );

  expect(find.text('Maybe'), findsOneWidget);
  expect(find.text('Mail to attendees'), findsOneWidget);
  expect(find.text('Yes'), findsNothing);
  expect(find.text('No'), findsNothing);
  expect(find.text('Propose a new time'), findsNothing);
  expect(find.text('See in your Calendar'), findsNothing);
}

Future<void> _emptyLabelColumn(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        details: [
          LinagoraEventDetail(
            label: 'When',
            values: [LinagoraEventValue('Tuesday, Jun 16')],
          ),
        ],
        actions: [LinagoraEventAction(label: 'Mail to attendees')],
      ),
    ),
  );

  final button = find.ancestor(
    of: find.text('Mail to attendees'),
    matching: find.byType(LinagoraButton),
  );

  expect(
    tester.getTopLeft(button).dx,
    tester.getTopLeft(find.text('Tuesday, Jun 16')).dx,
    reason: 'an unlabelled action row still starts at the value column',
  );
}

Future<void> _statusNotice(WidgetTester tester) async {
  const message = 'You are not invited to this event.';

  await tester.pumpWidget(
    _host(
      const LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        title: 'Automated DS Flutter',
        details: _details,
        status: LinagoraEventStatus(message),
      ),
    ),
  );

  expect(find.textContaining(message), findsOneWidget);
  expect(
    tester.getTopLeft(find.textContaining(message)).dy,
    greaterThan(tester.getTopLeft(find.text('Where')).dy),
    reason: 'the notice sits under the detail rows',
  );
}

Future<void> _detailExtraLines(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _card(
        details: const [
          LinagoraEventDetail(
            label: 'Who',
            values: [LinagoraEventValue.strong('Alex Martin')],
            lines: [
              LinagoraEventLine([
                LinagoraEventValue.muted('jordan.blake@example.invalid'),
              ]),
            ],
            action: LinagoraEventAction(label: 'Hide'),
          ),
        ],
      ),
    ),
  );

  final first = tester.getTopLeft(find.text('Alex Martin'));
  final second = tester.getTopLeft(find.text('jordan.blake@example.invalid'));
  final link = tester.getTopLeft(find.text('Hide'));

  expect(second.dy, greaterThan(first.dy));
  expect(second.dx, first.dx);
  expect(
    link.dy,
    greaterThan(second.dy),
    reason: 'the link drops below the lines instead of trailing the first',
  );
}

Future<void> _compactHidesDate(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(_card(layout: LinagoraEventCardLayout.compact), width: 375),
  );

  expect(find.byType(LinagoraEventDateIcon), findsNothing);
  expect(find.text('Automated DS Flutter'), findsOneWidget);
}

Future<void> _compactStacksLabels(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(_card(layout: LinagoraEventCardLayout.compact), width: 375),
  );

  expect(
    tester.getTopLeft(find.text('Tuesday, Jun 16')).dy,
    greaterThan(tester.getTopLeft(find.text('When')).dy),
  );
}

Future<void> _regularKeepsInline(WidgetTester tester) async {
  await tester.pumpWidget(_host(_card()));

  expect(
    tester.getTopLeft(find.text('Tuesday, Jun 16')).dy,
    tester.getTopLeft(find.text('When')).dy,
    reason: 'an inline row keeps the label on the value it labels',
  );
}

Future<void> _headerKeepsItsGap(WidgetTester tester) async {
  const activity = 'has invited you in to a meeting that runs long enough '
      'for the badge to fill the whole column beside the join button';

  await tester.pumpWidget(
    _host(
      const LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        activity: activity,
        actorName: 'Alex Martin',
        title: 'Automated DS Flutter',
        conference: LinagoraEventConference(
          join: LinagoraEventAction(label: 'Join'),
        ),
      ),
    ),
  );

  final badgeRight = tester.getTopRight(find.byType(EventActivityBadge)).dx;
  final conferenceLeft = tester
      .getTopLeft(find.byType(EventConferenceActions))
      .dx;

  expect(tester.takeException(), isNull);
  expect(conferenceLeft - badgeRight, greaterThanOrEqualTo(16));
}

Future<void> _adaptiveGoesCompact(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(_card(layout: LinagoraEventCardLayout.adaptive), width: 375),
  );

  expect(find.byType(LinagoraEventDateIcon), findsNothing);

  await tester.pumpWidget(
    _host(_card(layout: LinagoraEventCardLayout.adaptive), width: 1000),
  );

  expect(find.byType(LinagoraEventDateIcon), findsOneWidget);
}

Future<void> _regularSurvivesNarrowWidth(WidgetTester tester) async {
  await tester.pumpWidget(_host(_card(), width: 300));

  expect(tester.takeException(), isNull);
  expect(
    tester.getSize(find.text('Join the video conference')).width,
    lessThan(300),
    reason: 'the conference block gives way instead of overflowing',
  );
}

LinagoraButton _responseButton(WidgetTester tester, String label) {
  return tester.widget<LinagoraButton>(
    find.ancestor(
      of: find.text(label),
      matching: find.byType(LinagoraButton),
    ),
  );
}

Future<void> _selectionSettlesOnlyTheChosenResponse(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      _card(
        attending: LinagoraEventAttending(
          label: 'Attending?',
          selectedResponse: 'Yes',
          responses: [
            // Both carry a callback, so a settled pill can only come from the
            // selection rather than from a missing one.
            LinagoraEventAction(label: 'Yes', onPressed: () {}),
            LinagoraEventAction(label: 'No', onPressed: () {}),
          ],
        ),
      ),
    ),
  );

  expect(_responseButton(tester, 'Yes').onPressed, isNull);
  expect(_responseButton(tester, 'No').onPressed, isNotNull);
}

Future<void> _reportsResponseTap(WidgetTester tester) async {
  var taps = 0;
  await tester.pumpWidget(
    _host(
      _card(
        attending: LinagoraEventAttending(
          label: 'Attending?',
          responses: [
            LinagoraEventAction(label: 'Yes', onPressed: () => taps++),
          ],
        ),
      ),
    ),
  );

  await tester.tap(find.text('Yes'));
  await tester.pump();

  expect(taps, 1);
}

void _rejectsNegativeRadius() {
  expect(
    () => LinagoraEventCard(borderRadius: -1),
    throwsAssertionError,
  );
}

Future<void> _reportsValueTap(WidgetTester tester) async {
  var taps = 0;

  await tester.pumpWidget(
    _host(
      _card(
        details: [
          LinagoraEventDetail(
            label: 'Who',
            values: [
              LinagoraEventValue.muted(
                'alex.martin@example.invalid',
                onTap: () => taps++,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.text('alex.martin@example.invalid'));

  expect(taps, 1);
}

Future<void> _reportsExtraLineValueTap(WidgetTester tester) async {
  var taps = 0;

  await tester.pumpWidget(
    _host(
      _card(
        details: [
          LinagoraEventDetail(
            label: 'Who',
            values: const [LinagoraEventValue.strong('Alex Martin')],
            lines: [
              LinagoraEventLine([
                LinagoraEventValue.muted(
                  'jordan.blake@example.invalid',
                  onTap: () => taps++,
                ),
              ]),
            ],
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.text('jordan.blake@example.invalid'));

  expect(taps, 1, reason: 'an extra line carries its own value actions');
}

Future<void> _plainValueIsInert(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _card(
        details: const [
          LinagoraEventDetail(
            label: 'Where',
            values: [LinagoraEventValue('Villa Good Tech')],
          ),
        ],
      ),
    ),
  );

  expect(
    find.ancestor(
      of: find.text('Villa Good Tech'),
      matching: find.byType(GestureDetector),
    ),
    findsNothing,
  );
}

Future<void> _rendersFromData(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEventCard.fromData(
        const LinagoraEventCardData(
          date: _date,
          actorName: 'Alex Martin',
          activity: 'has invited you in to a meeting',
          title: 'Data-driven event',
          details: _details,
          attending: _attending,
        ),
        layout: LinagoraEventCardLayout.regular,
      ),
    ),
  );

  expect(find.text('Data-driven event'), findsOneWidget);
  expect(find.textContaining('Alex Martin'), findsOneWidget);
  expect(find.text('When'), findsOneWidget);
  expect(find.text('Attending?'), findsOneWidget);
}

Future<void> _expandsAndCollapsesDetailLines(WidgetTester tester) async {
  final changes = <bool>[];

  await tester.pumpWidget(
    _host(
      LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        details: [
          LinagoraEventDetail(
            label: 'Who',
            values: const [LinagoraEventValue.strong('Organizer')],
            lines: _participantLines('Attendee', 7),
            expansion: LinagoraEventDetailExpansion(
              expandLabel: 'See all participants',
              collapseLabel: 'Hide',
              onChanged: changes.add,
            ),
          ),
        ],
      ),
    ),
  );

  expect(find.text('Attendee 4'), findsOneWidget);
  expect(find.text('Attendee 5'), findsNothing);
  expect(find.text('See all participants'), findsOneWidget);

  await tester.tap(find.text('See all participants'));
  await tester.pump();

  expect(find.text('Attendee 6'), findsOneWidget);
  expect(find.text('Hide'), findsOneWidget);
  expect(changes, [true]);

  await tester.tap(find.text('Hide'));
  await tester.pump();

  expect(find.text('Attendee 5'), findsNothing);
  expect(find.text('See all participants'), findsOneWidget);
  expect(changes, [true, false]);
}

Future<void> _showsLinesBelowCollapseThreshold(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEventCard(
        layout: LinagoraEventCardLayout.regular,
        details: [
          LinagoraEventDetail(
            label: 'Who',
            lines: _participantLines('Attendee', 6),
            expansion: const LinagoraEventDetailExpansion(
              expandLabel: 'See all participants',
              collapseLabel: 'Hide',
            ),
          ),
        ],
      ),
    ),
  );

  expect(find.text('Attendee 5'), findsOneWidget);
  expect(find.text('See all participants'), findsNothing);
  expect(find.text('Hide'), findsNothing);
}

Future<void> _resetsExpansionForNewIdentity(WidgetTester tester) async {
  await tester.pumpWidget(_host(_expandableCard('first')));

  await tester.tap(find.text('See all participants'));
  await tester.pump();
  expect(find.text('Attendee 6'), findsOneWidget);

  await tester.pumpWidget(_host(_expandableCard('second')));
  await tester.pump();

  expect(find.text('Attendee 5'), findsNothing);
  expect(find.text('See all participants'), findsOneWidget);
}

LinagoraEventCard _expandableCard(Object identity) {
  return LinagoraEventCard(
    layout: LinagoraEventCardLayout.regular,
    details: [
      LinagoraEventDetail(
        label: 'Who',
        lines: _participantLines('Attendee', 7),
        expansion: LinagoraEventDetailExpansion(
          expandLabel: 'See all participants',
          collapseLabel: 'Hide',
          identity: identity,
        ),
      ),
    ],
  );
}

List<LinagoraEventLine> _participantLines(String prefix, int count) => [
  for (var index = 0; index < count; index++)
    LinagoraEventLine([LinagoraEventValue('$prefix $index')]),
];

void _invalidExpansion() {
  expect(
    () => LinagoraEventDetailExpansion(
      expandLabel: 'See all',
      collapseLabel: 'Hide',
      collapsedLineCount: -1,
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraEventDetailExpansion(
      expandLabel: 'See all',
      collapseLabel: 'Hide',
      collapsedLineCount: 5,
      collapseThreshold: 4,
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraEventDetail(
      action: const LinagoraEventAction(label: 'Action'),
      expansion: const LinagoraEventDetailExpansion(
        expandLabel: 'See all',
        collapseLabel: 'Hide',
      ),
    ),
    throwsAssertionError,
  );
}
