import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _dotKey = ValueKey('linagora-presence-dot');

Widget _host(
  LinagoraPresence? presence, {
  double size = 40,
  LinagoraPresenceBadgeStyle? style,
  bool disableAnimations = false,
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(
        body: Center(
          child: LinagoraPresenceBadge(
            presence: presence,
            size: size,
            style: style,
            child: SizedBox.square(
              key: const ValueKey('avatar'),
              dimension: size,
            ),
          ),
        ),
      ),
    ),
  );
}

BoxDecoration _decoration(WidgetTester tester) =>
    tester.widget<AnimatedContainer>(find.byKey(_dotKey)).decoration!
        as BoxDecoration;

void main() {
  group('LinagoraPresenceBadge', () {
    testWidgets('draws a green dot when online', _online);
    testWidgets('draws an amber dot when away', _away);
    testWidgets('draws no dot when offline or unknown', _noDot);
    testWidgets('uses a 10 dot up to a 40 avatar, 12 above', _dotSizes);
    testWidgets('sits on the circle at the bottom right', _position);
    testWidgets('keeps the avatar size', _keepsAvatarSize);
    testWidgets('hides the dot from semantics', _semantics);
    testWidgets('fades the colour in 150 ms', _fades);
    testWidgets('does not animate under reduced motion', _reducedMotion);
  });
  group('LinagoraPresenceBadgeStyle', () {
    testWidgets('rings the dot with the dark surface', _darkRing);
  });
}

Future<void> _online(WidgetTester tester) async {
  await tester.pumpWidget(_host(LinagoraPresence.online));

  final decoration = _decoration(tester);
  expect(decoration.color, LinagoraSysColors.material().success);
  expect(decoration.shape, BoxShape.circle);
  expect(decoration.border, Border.all(color: Colors.white, width: 2));
}

Future<void> _away(WidgetTester tester) async {
  await tester.pumpWidget(_host(LinagoraPresence.away));

  expect(_decoration(tester).color, LinagoraSysColors.material().warning);
}

Future<void> _noDot(WidgetTester tester) async {
  await tester.pumpWidget(_host(LinagoraPresence.offline));
  expect(find.byKey(_dotKey), findsNothing);

  await tester.pumpWidget(_host(null));
  expect(find.byKey(_dotKey), findsNothing);
}

Future<void> _dotSizes(WidgetTester tester) async {
  await tester.pumpWidget(_host(LinagoraPresence.online, size: 40));
  expect(tester.getSize(find.byKey(_dotKey)), const Size.square(14));

  await tester.pumpWidget(_host(LinagoraPresence.online, size: 41));
  expect(tester.getSize(find.byKey(_dotKey)), const Size.square(16));
}

Future<void> _position(WidgetTester tester) async {
  for (final size in [32.0, 48.0, 96.0]) {
    await tester.pumpWidget(_host(LinagoraPresence.online, size: size));

    final avatar = tester.getRect(find.byKey(const ValueKey('avatar')));
    final dot = tester.getRect(find.byKey(_dotKey));
    final onCircle = avatar.center + Offset(size / 2, size / 2) * math.sqrt1_2;
    expect(dot.center.dx, moreOrLessEquals(onCircle.dx));
    expect(dot.center.dy, moreOrLessEquals(onCircle.dy));
  }
}

Future<void> _keepsAvatarSize(WidgetTester tester) async {
  await tester.pumpWidget(_host(LinagoraPresence.online, size: 48));

  expect(
    tester.getSize(find.byType(LinagoraPresenceBadge)),
    const Size.square(48),
  );
}

Future<void> _semantics(WidgetTester tester) async {
  await tester.pumpWidget(_host(LinagoraPresence.online));

  expect(
    find.descendant(
      of: find.byType(ExcludeSemantics),
      matching: find.byKey(_dotKey),
    ),
    findsOneWidget,
  );
}

Future<void> _fades(WidgetTester tester) async {
  await tester.pumpWidget(_host(LinagoraPresence.online));

  expect(
    tester.widget<AnimatedContainer>(find.byKey(_dotKey)).duration,
    const Duration(milliseconds: 150),
  );
}

Future<void> _reducedMotion(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(LinagoraPresence.online, disableAnimations: true),
  );

  expect(
    tester.widget<AnimatedContainer>(find.byKey(_dotKey)).duration,
    Duration.zero,
  );
}

Future<void> _darkRing(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(LinagoraPresence.away, style: LinagoraPresenceBadgeStyle.dark()),
  );

  expect(
    _decoration(tester).border,
    Border.all(color: const Color(0xFF3F4249), width: 2),
  );
}
