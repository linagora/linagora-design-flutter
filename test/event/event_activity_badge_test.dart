import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'maps event states to their default backgrounds',
    _mapsStateBackgrounds,
  );
  testWidgets(
    'matches the specified padding, radius and typography',
    _matchesVisualSpecification,
  );
  testWidgets('emphasises the optional actor', _emphasisesActor);
  testWidgets('uses a 4px auto-layout gap', _usesActivityGap);
  testWidgets(
    'wraps a long activity at a finite constraint',
    _wrapsAtFiniteConstraint,
  );
  testWidgets('honours explicit colour overrides', _honoursColourOverrides);
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

Future<void> _honoursColourOverrides(WidgetTester tester) async {
  const background = Color(0xFF123456);
  const foreground = Color(0xFF654321);
  await _pumpBadge(
    tester,
    const EventActivityBadge(
      activity: 'Custom colours',
      backgroundColor: background,
      foregroundColor: foreground,
    ),
  );

  expect(_badgeDecoration(tester).color, background);
  expect(tester.widget<Text>(find.byType(Text)).style?.color, foreground);
}

Future<void> _pumpBadge(WidgetTester tester, Widget badge) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: badge)),
    ),
  );
}

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
