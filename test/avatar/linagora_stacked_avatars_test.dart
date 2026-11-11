import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Widget _host(Widget child, {TextDirection textDirection = TextDirection.ltr}) {
  return MaterialApp(
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

Widget _avatar(String id) {
  return ColoredBox(
    key: ValueKey(id),
    color: Colors.blue,
    child: const SizedBox.expand(),
  );
}

void main() {
  group('LinagoraStackedAvatars', () {
    testWidgets('overlaps avatars by 6 and sizes the row to fit', _overlaps);
    testWidgets('puts the first avatar on top', _firstAvatarOnTop);
    testWidgets(
      'sums up the avatars beyond maxVisible in a +N bubble',
      _overflow,
    );
    testWidgets('keeps a two-digit overflow count readable', _twoDigitOverflow);
    testWidgets('scales the overflow count with text scale', _overflowScales);
    testWidgets('draws a white ring around each avatar', _ring);
    testWidgets('starts from the right in RTL', _rtl);
    testWidgets('keeps +N left-to-right in RTL', _overflowStaysLtrInRtl);
    testWidgets(
      'uses the given label, or each avatar\'s own label',
      _semantics,
    );
    testWidgets(
      'an empty label keeps each avatar\'s name',
      _emptySemanticLabel,
    );
    testWidgets('takes no space without avatars', _empty);
  });
  group('LinagoraStackedAvatarsStyle', () {
    testWidgets('takes size and overlap from the style', _customStyle);
    testWidgets('rings the avatars with the dark surface', _darkRing);
  });
}

Future<void> _overlaps(WidgetTester tester) async {
  final row = await _twoAvatars(tester);

  expect(
    tester.getSize(find.byType(LinagoraStackedAvatars)),
    const Size(58, 32),
  );
  expect(row.owner.left - row.me.left, 26);
}

Future<void> _firstAvatarOnTop(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(LinagoraStackedAvatars(avatars: [_avatar('me'), _avatar('owner')])),
  );

  final hit = tester.hitTestOnBinding(
    tester.getRect(find.byKey(const ValueKey('me'))).centerRight -
        const Offset(2, 0),
  );
  final me = tester.renderObject(find.byKey(const ValueKey('me')));
  expect(hit.path.any((entry) => entry.target == me), isTrue);
}

Future<void> _overflow(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraStackedAvatars(
        maxVisible: 2,
        avatars: [_avatar('a'), _avatar('b'), _avatar('c'), _avatar('d')],
      ),
    ),
  );

  expect(find.byKey(const ValueKey('c')), findsNothing);
  expect(find.text('+2'), findsOneWidget);
  expect(
    tester.getSize(find.byType(LinagoraStackedAvatars)).width,
    32 + 26 * 2,
  );
}

Future<void> _twoDigitOverflow(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraStackedAvatars(
        maxVisible: 1,
        avatars: [for (var i = 0; i < 11; i++) _avatar('$i')],
      ),
    ),
  );

  final text = find.text('+10');
  expect(text, findsOneWidget);
  final box = tester.getRect(text);
  final paragraph = tester.renderObject<RenderParagraph>(text);
  expect(
    paragraph
        .getPositionForOffset(Offset(box.width * 0.85, box.height / 2))
        .offset,
    greaterThan(1),
    reason: 'the tens digit must stay hittable inside the ring',
  );
}

Future<void> _overflowScales(WidgetTester tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: _host(
        LinagoraStackedAvatars(
          maxVisible: 1,
          avatars: [_avatar('a'), _avatar('b')],
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.text('+1'), findsOneWidget);
  expect(
    tester.getSize(find.text('+1')).height,
    greaterThan(
      LinagoraStackedAvatarsStyle.material().overflowTextStyle.fontSize!,
    ),
  );
}

Future<void> _overflowStaysLtrInRtl(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraStackedAvatars(
        maxVisible: 1,
        avatars: [_avatar('a'), _avatar('b')],
      ),
      textDirection: TextDirection.rtl,
    ),
  );

  final text = find.text('+1');
  final box = tester.getRect(text);
  final paragraph = tester.renderObject<RenderParagraph>(text);
  final midY = box.height / 2;
  final samples = [
    for (final x in [0.15, 0.35, 0.65, 0.85])
      paragraph.getPositionForOffset(Offset(box.width * x, midY)).offset,
  ];
  expect(samples.first, lessThan(samples.last));
  expect(
    samples.where((offset) => offset == 0).isNotEmpty,
    isTrue,
    reason: '+ stays on the start of the visual line in RTL',
  );
}

Future<void> _ring(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(LinagoraStackedAvatars(avatars: [_avatar('me')])),
  );

  final ring = tester.widget<Container>(
    find
        .ancestor(
          of: find.byKey(const ValueKey('me')),
          matching: find.byType(Container),
        )
        .first,
  );
  final decoration = ring.decoration! as BoxDecoration;
  expect(decoration.shape, BoxShape.circle);
  expect(decoration.border, Border.all(color: Colors.white, width: 2));
}

Future<void> _rtl(WidgetTester tester) async {
  final row = await _twoAvatars(tester, textDirection: TextDirection.rtl);

  expect(row.me.right - row.owner.right, 26);
}

Future<({Rect me, Rect owner})> _twoAvatars(
  WidgetTester tester, {
  TextDirection textDirection = TextDirection.ltr,
}) async {
  await tester.pumpWidget(
    _host(
      LinagoraStackedAvatars(avatars: [_avatar('me'), _avatar('owner')]),
      textDirection: textDirection,
    ),
  );
  return (
    me: tester.getRect(find.byKey(const ValueKey('me'))),
    owner: tester.getRect(find.byKey(const ValueKey('owner'))),
  );
}

Future<void> _semantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinagoraStackedAvatars(
            avatars: [_avatar('me'), _avatar('owner')],
            semanticLabel: 'You and Nora Hale',
          ),
          LinagoraStackedAvatars(
            maxVisible: 1,
            avatars: [_avatar('x'), _avatar('y')],
          ),
          const LinagoraStackedAvatars(
            avatars: [RoundAvatar(text: 'NH', size: 24)],
          ),
        ],
      ),
    ),
  );

  expect(find.bySemanticsLabel('You and Nora Hale'), findsOneWidget);
  expect(find.bySemanticsLabel('+1'), findsOneWidget);
  expect(find.bySemanticsLabel('NH'), findsOneWidget);
  handle.dispose();
}

Future<void> _emptySemanticLabel(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      const LinagoraStackedAvatars(
        semanticLabel: '  ',
        avatars: [RoundAvatar(text: 'ZZ', size: 24)],
      ),
    ),
  );

  expect(find.bySemanticsLabel('ZZ'), findsOneWidget);
  handle.dispose();
}

Future<void> _empty(WidgetTester tester) async {
  await tester.pumpWidget(_host(const LinagoraStackedAvatars(avatars: [])));

  expect(tester.getSize(find.byType(LinagoraStackedAvatars)), Size.zero);
}

Future<void> _customStyle(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraStackedAvatars(
        style: LinagoraStackedAvatarsStyle.material().copyWith(
          size: 24,
          overlap: 8,
        ),
        avatars: [_avatar('me'), _avatar('owner')],
      ),
    ),
  );

  expect(
    tester.getSize(find.byType(LinagoraStackedAvatars)),
    const Size(40, 24),
  );
}

Future<void> _darkRing(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraStackedAvatars(
        style: LinagoraStackedAvatarsStyle.dark(),
        avatars: [_avatar('me')],
      ),
    ),
  );

  final ring = tester.widget<Container>(
    find.ancestor(
      of: find.byKey(const ValueKey('me')),
      matching: find.byType(Container),
    ).first,
  );
  expect(
    (ring.decoration! as BoxDecoration).border,
    Border.all(color: const Color(0xFF3F4249), width: 2),
  );
}
