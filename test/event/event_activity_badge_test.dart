import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _fontFamily = 'packages/linagora_design_flutter/TwakeInter';

void main() {
  testWidgets(
    'maps event states to their default backgrounds',
    _mapsStateBackgrounds,
  );
  testWidgets('defaults to the created state', _defaultsToCreatedState);
  testWidgets(
    'matches the specified padding, radius and typography',
    _matchesVisualSpecification,
  );
  testWidgets('emphasises the optional actor', _emphasisesActor);
  testWidgets(
    'renders only the activity for absent or blank actor names',
    _rendersWithoutActor,
  );
  testWidgets(
    'removes all leading activity whitespace when an actor is shown',
    _normalisesActivityWhitespace,
  );
  testWidgets('uses a 4px auto-layout gap', _usesActivityGap);
  testWidgets('hugs short content', _hugsShortContent);
  testWidgets(
    'wraps a long activity at a finite constraint',
    _wrapsAtFiniteConstraint,
  );
  testWidgets(
    'wraps under a narrow constraint with large text scaling',
    _wrapsWithLargeText,
  );
  testWidgets('exposes a readable activity semantic label', _semantics);
  testWidgets(
    'honours explicit colour overrides independently',
    _honoursColourOverrides,
  );
}

Future<void> _mapsStateBackgrounds(WidgetTester tester) async {
  final errorLight = LinagoraRefColors.material().error[90];
  final expectedBackgrounds = {
    EventActivityBadgeState.created:
        LinagoraSysColors.material().primaryContainer,
    EventActivityBadgeState.reminder:
        LinagoraSysColors.material().primaryContainer,
    EventActivityBadgeState.updated:
        LinagoraSysColors.material().primaryContainer,
    EventActivityBadgeState.accepted: EventActivityBadge.successBackground,
    EventActivityBadgeState.canceled: errorLight,
    EventActivityBadgeState.notInvited: errorLight,
  };

  for (final entry in expectedBackgrounds.entries) {
    await _pumpBadge(
      tester,
      EventActivityBadge(state: entry.key, activity: 'Event activity'),
    );

    expect(_badgeDecoration(tester).color, entry.value);
  }
}

Future<void> _defaultsToCreatedState(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const EventActivityBadge(activity: 'Event activity'),
  );

  expect(
    tester.widget<EventActivityBadge>(find.byType(EventActivityBadge)).state,
    EventActivityBadgeState.created,
  );
  expect(
    _badgeDecoration(tester).color,
    LinagoraSysColors.material().primaryContainer,
  );
}

Future<void> _matchesVisualSpecification(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const EventActivityBadge(activity: 'This event is about to begin'),
  );

  final container = _badgeContainer(tester);
  final decoration = _badgeDecoration(tester);
  final text = tester.widget<Text>(find.byType(Text));

  expect(
    container.padding,
    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  );
  expect(decoration.borderRadius, const BorderRadius.all(Radius.circular(4)));
  expect(text.style?.fontSize, 14);
  expect(text.style?.fontWeight, FontWeight.w400);
  expect(text.style?.height, 18.4 / 14);
  expect(text.style?.letterSpacing, 0.25);
  expect(text.style?.color, const Color(0xE6424244));
  expect(text.style?.fontFamily, _fontFamily);
}

Future<void> _emphasisesActor(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const EventActivityBadge(
      actorName: 'userA',
      activity: 'has invited you in to a meeting',
    ),
  );

  final text = tester.widget<Text>(find.byType(Text));
  final span = text.textSpan! as TextSpan;
  final actor = span.children!.first as TextSpan;
  final activity = span.children!.last as TextSpan;

  expect(actor.text, 'userA');
  expect(actor.style?.fontWeight, FontWeight.w600);
  expect(activity.text, 'has invited you in to a meeting');
}

Future<void> _rendersWithoutActor(WidgetTester tester) async {
  const actorNames = <String?>[null, '', '   '];

  for (final actorName in actorNames) {
    const activity = '  Standalone activity';
    await _pumpBadge(
      tester,
      EventActivityBadge(actorName: actorName, activity: activity),
    );

    final children = _badgeTextSpan(tester).children!;
    expect(
      children,
      hasLength(1),
      reason: 'Actor name "$actorName" must not add actor or gap spans',
    );
    expect((children.single as TextSpan).text, activity);
    expect(children.whereType<WidgetSpan>(), isEmpty);
  }
}

Future<void> _normalisesActivityWhitespace(WidgetTester tester) async {
  const activities = <({String input, String expected})>[
    (input: 'has accepted', expected: 'has accepted'),
    (input: ' has accepted', expected: 'has accepted'),
    (input: '   has accepted', expected: 'has accepted'),
    (input: '\thas accepted', expected: 'has accepted'),
    (input: '\nhas accepted', expected: 'has accepted'),
    (input: '', expected: ''),
  ];

  for (final activity in activities) {
    await _pumpBadge(
      tester,
      EventActivityBadge(actorName: 'userA', activity: activity.input),
    );

    final activitySpan = _badgeTextSpan(tester).children!.last as TextSpan;
    expect(
      activitySpan.text,
      activity.expected,
      reason: 'Leading whitespace must not supplement the fixed 4px gap',
    );
    expect(tester.takeException(), isNull);
  }
}

Future<void> _usesActivityGap(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const EventActivityBadge(
      actorName: 'userA',
      activity: 'has invited you in to a meeting',
    ),
  );

  final span = tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
  final gap = span.children![1] as WidgetSpan;

  expect((gap.child as SizedBox).width, 4);
}

Future<void> _hugsShortContent(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const EventActivityBadge(activity: 'Short'),
  );

  final badgeSize = tester.getSize(find.byType(EventActivityBadge));
  final textSize = tester.getSize(_badgeTextFinder());

  expect(badgeSize.width, closeTo(textSize.width + 16, 0.001));
}

Future<void> _wrapsAtFiniteConstraint(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const SizedBox(
      width: 283,
      child: EventActivityBadge(
        state: EventActivityBadgeState.accepted,
        actorName: 'userA',
        activity: 'has accepted this invitation',
      ),
    ),
  );

  final badgeSize = tester.getSize(find.byType(EventActivityBadge));
  expect(badgeSize.width, 283);
  expect(badgeSize.height, greaterThan(26));
  expect(tester.takeException(), isNull);
}

Future<void> _wrapsWithLargeText(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const SizedBox(
      width: 120,
      child: EventActivityBadge(
        actorName: 'userA',
        activity: 'has accepted this invitation',
      ),
    ),
    textScaler: const TextScaler.linear(2),
  );

  final badge = tester.getRect(find.byType(EventActivityBadge));
  final text = tester.getRect(_badgeTextFinder());
  final paragraph = tester.renderObject<RenderParagraph>(_badgeTextFinder());

  expect(badge.width, 120);
  expect(badge.height, greaterThan(44));
  expect(text.left, greaterThanOrEqualTo(badge.left + 8));
  expect(text.right, lessThanOrEqualTo(badge.right - 8));
  expect(paragraph.didExceedMaxLines, isFalse);
  expect(tester.takeException(), isNull);
}

Future<void> _semantics(WidgetTester tester) async {
  final semantics = tester.ensureSemantics();
  try {
    await _pumpBadge(
      tester,
      const EventActivityBadge(
        actorName: 'userA',
        activity: 'has accepted this invitation',
      ),
    );

    expect(
      find.bySemanticsLabel(
        RegExp(r'^userA\s+has accepted this invitation$'),
      ),
      findsOneWidget,
    );

    await _pumpBadge(
      tester,
      const EventActivityBadge(activity: 'Standalone activity'),
    );

    expect(find.bySemanticsLabel('Standalone activity'), findsOneWidget);
  } finally {
    semantics.dispose();
  }
}

Future<void> _honoursColourOverrides(WidgetTester tester) async {
  const background = Color(0xFF123456);
  const foreground = Color(0xFF654321);

  await _pumpBadge(
    tester,
    const EventActivityBadge(
      activity: 'Background override',
      backgroundColor: background,
    ),
  );

  expect(_badgeDecoration(tester).color, background);
  expect(
    tester.widget<Text>(_badgeTextFinder()).style?.color,
    EventActivityBadge.defaultForeground,
  );

  await _pumpBadge(
    tester,
    const EventActivityBadge(
      activity: 'Foreground override',
      foregroundColor: foreground,
    ),
  );

  expect(
    _badgeDecoration(tester).color,
    LinagoraSysColors.material().primaryContainer,
  );
  expect(tester.widget<Text>(_badgeTextFinder()).style?.color, foreground);

  await _pumpBadge(
    tester,
    const EventActivityBadge(
      activity: 'Custom colours',
      backgroundColor: background,
      foregroundColor: foreground,
    ),
  );

  expect(_badgeDecoration(tester).color, background);
  expect(tester.widget<Text>(_badgeTextFinder()).style?.color, foreground);
}

Future<void> _pumpBadge(
  WidgetTester tester,
  Widget badge, {
  TextScaler? textScaler,
}) {
  return tester.pumpWidget(
    MaterialApp(
      builder: textScaler == null
          ? null
          : (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            ),
      home: Scaffold(body: Center(child: badge)),
    ),
  );
}

TextSpan _badgeTextSpan(WidgetTester tester) =>
    tester.widget<Text>(_badgeTextFinder()).textSpan! as TextSpan;

Finder _badgeTextFinder() => find.descendant(
  of: find.byType(EventActivityBadge),
  matching: find.byType(Text),
);

Container _badgeContainer(WidgetTester tester) {
  return tester.widget<Container>(
    find.descendant(
      of: find.byType(EventActivityBadge),
      matching: find.byType(Container),
    ),
  );
}

BoxDecoration _badgeDecoration(WidgetTester tester) {
  return _badgeContainer(tester).decoration! as BoxDecoration;
}
