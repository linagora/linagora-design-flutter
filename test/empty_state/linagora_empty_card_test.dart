import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _title = 'No one has access yet';
const _message = 'Add someone below to share access to your inbox.';

void main() {
  group('LinagoraEmptyCard', () {
    testWidgets('centres title, message and action in a bordered card', _card);
    testWidgets('fills the parent width by default', _fillsParentWidth);
    testWidgets('honours a fixed width', _fixedWidth);
    testWidgets('shows only the title when nothing else is given', _titleOnly);
    testWidgets('drops a blank message', _dropsBlankMessage);
    testWidgets('trims trailing newlines from the message', _trimsMessage);
    testWidgets('honours a taller actionHeight floor', _tallerAction);
    testWidgets('puts the illustration above the title', _illustration);
    testWidgets('drops the border when not bordered', _unbordered);
    testWidgets('disables the action without a callback', _disabledAction);
    testWidgets('wraps long text on a phone without overflow', _wraps);
    testWidgets(
      'announces the title as a header and hides the illustration',
      _semantics,
    );
    testWidgets('uses the padding and border from the given style', _style);
    testWidgets('uses the dark tokens when given', _darkTokens);
    test('copyWith overrides one field and keeps the rest', _copyWith);
  });
}

Future<void> _card(WidgetTester tester) async {
  var added = 0;
  await tester.pumpWidget(
    _host(
      LinagoraEmptyCard(
        title: _title,
        message: _message,
        action: LinagoraEmptyCardAction(
          label: 'Add',
          icon: Icons.add,
          onPressed: () => added++,
        ),
      ),
    ),
  );

  final card = tester.getRect(find.byType(LinagoraEmptyCard));
  final title = tester.getRect(find.text(_title));
  final message = tester.getRect(find.text(_message));
  final action = tester.getRect(find.byKey(LinagoraEmptyCard.actionKey));
  expect(title.center.dx, closeTo(card.center.dx, 0.5));
  expect(action.center.dx, closeTo(card.center.dx, 0.5));
  expect(title.top, card.top + 16 + 1);
  expect(message.top, title.bottom + 8);
  expect(message.left, greaterThanOrEqualTo(card.left + 16 + 1));
  expect(action.top, message.bottom + 8);
  expect(card.bottom - action.bottom, 16 + 1);
  expect(action.height, 48);
  expect(tester.getSize(find.byIcon(Icons.add)).height, 20);
  expect(
    _decoration(tester)?.border,
    Border.all(color: const Color(0x29424242)),
  );
  expect(_decoration(tester)?.borderRadius, BorderRadius.circular(16));
  expect(_decoration(tester)?.color, Colors.white);

  await tester.tap(find.byKey(LinagoraEmptyCard.actionKey));
  expect(added, 1);
}

Future<void> _fillsParentWidth(WidgetTester tester) async {
  await tester.pumpWidget(_host(const LinagoraEmptyCard(title: _title)));

  expect(tester.getSize(find.byType(LinagoraEmptyCard)).width, 488);
}

Future<void> _fixedWidth(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: LinagoraEmptyCard(title: _title, width: 320),
        ),
      ),
    ),
  );

  expect(tester.getSize(find.byType(LinagoraEmptyCard)).width, 320);
}

Future<void> _titleOnly(WidgetTester tester) async {
  await tester.pumpWidget(_host(const LinagoraEmptyCard(title: _title)));

  expect(find.text(_title), findsOneWidget);
  expect(find.byKey(LinagoraEmptyCard.actionKey), findsNothing);
  expect(find.byType(Text), findsOneWidget);
}

Future<void> _dropsBlankMessage(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const LinagoraEmptyCard(title: _title, message: '  \n')),
  );

  expect(find.byType(Text), findsOneWidget);
}

Future<void> _trimsMessage(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const LinagoraEmptyCard(title: _title, message: 'hello\n')),
  );

  expect(find.text('hello'), findsOneWidget);
  expect(find.text('hello\n'), findsNothing);
}

Future<void> _tallerAction(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEmptyCard(
        title: _title,
        action: const LinagoraEmptyCardAction(
          label: 'Add',
          icon: Icons.add,
          onPressed: _noop,
        ),
        style: LinagoraEmptyCardStyle.material().copyWith(actionHeight: 56),
      ),
    ),
  );

  expect(tester.getSize(find.byKey(LinagoraEmptyCard.actionKey)).height, 56);
}

Future<void> _illustration(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEmptyCard(
        title: _title,
        illustration: Icon(Icons.group_outlined, key: ValueKey('art')),
      ),
    ),
  );

  final art = tester.getRect(find.byKey(const ValueKey('art')));
  final card = tester.getRect(find.byType(LinagoraEmptyCard));
  expect(art.top, card.top + 1 + 16);
  expect(tester.getRect(find.text(_title)).top, art.bottom + 8);
}

Future<void> _unbordered(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEmptyCard(
        title: _title,
        bordered: false,
        style: LinagoraEmptyCardStyle.dark(),
      ),
    ),
  );

  expect(_decoration(tester)?.border, isNull);
  expect(_decoration(tester)?.color, const Color(0xFF3E424A));
  expect(_decoration(tester)?.borderRadius, BorderRadius.circular(16));
}

Future<void> _disabledAction(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEmptyCard(
        title: _title,
        action: LinagoraEmptyCardAction(label: 'Add', onPressed: null),
      ),
    ),
  );

  final button = tester.widget<LinagoraButton>(
    find.byKey(LinagoraEmptyCard.actionKey),
  );
  expect(button.onPressed, isNull);
}

Future<void> _wraps(WidgetTester tester) async {
  tester.view.physicalSize = const Size(320, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: _host(
        const LinagoraEmptyCard(
          title: _title,
          message: _message,
          action: LinagoraEmptyCardAction(
            label: 'Add',
            icon: Icons.add,
            onPressed: _noop,
          ),
        ),
        width: 320,
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getSize(find.byKey(LinagoraEmptyCard.actionKey)).height,
    greaterThanOrEqualTo(48),
  );
}

void _noop() {}

Future<void> _semantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      const LinagoraEmptyCard(
        title: _title,
        illustration: Icon(Icons.group_outlined, semanticLabel: 'People'),
      ),
    ),
  );

  expect(
    tester.getSemantics(find.text(_title)),
    matchesSemantics(label: _title, isHeader: true),
  );
  expect(find.bySemanticsLabel('People'), findsNothing);
  handle.dispose();
}

Future<void> _style(WidgetTester tester) async {
  final style = LinagoraEmptyCardStyle.material().copyWith(
    padding: EdgeInsets.zero,
    borderColor: const Color(0xFF00AA44),
  );
  await tester.pumpWidget(
    _host(LinagoraEmptyCard(title: _title, style: style)),
  );

  final card = tester.getRect(find.byType(LinagoraEmptyCard));
  // The border stroke is inside the card box, so zero padding still insets by 1.
  expect(tester.getRect(find.text(_title)).top, card.top + 1);
  expect(
    _decoration(tester)?.border,
    Border.all(color: const Color(0xFF00AA44)),
  );
}

Future<void> _darkTokens(WidgetTester tester) async {
  final style = LinagoraEmptyCardStyle.dark();
  await tester.pumpWidget(
    _host(
      LinagoraEmptyCard(
        title: _title,
        message: _message,
        style: style,
        action: const LinagoraEmptyCardAction(
          label: 'Add',
          onPressed: null,
        ),
      ),
    ),
  );

  expect(_decoration(tester)?.color, const Color(0xFF3E424A));
  expect(
    _decoration(tester)?.border,
    Border.all(color: const Color(0x29FFFFFF)),
  );
  final title = tester.widget<Text>(find.text(_title)).style!;
  expect(title.color, Colors.white);
  expect(title.fontWeight, FontWeight.w500);
  final message = tester.widget<Text>(find.text(_message)).style!;
  expect(message.color, const Color(0xA3FFFFFF));
  expect(message.fontWeight, FontWeight.w500);
  expect(style.actionBackgroundColor, const Color(0xFF91BFFF));
  expect(style.actionForegroundColor, const Color(0xFF424244));
  expect(style.actionDisabledForegroundColor, const Color(0x61424244));
}

void _copyWith() {
  final base = LinagoraEmptyCardStyle.material();
  final next = base.copyWith(borderColor: const Color(0xFF00AA44));
  expect(next.borderColor, const Color(0xFF00AA44));
  expect(next.backgroundColor, base.backgroundColor);
  expect(next.padding, base.padding);
  expect(next.radius, base.radius);
  expect(next.actionHeight, base.actionHeight);
  expect(next.titleTextStyle, base.titleTextStyle);
  expect(next.messageTextStyle, base.messageTextStyle);
  expect(next.actionBackgroundColor, base.actionBackgroundColor);
  expect(next.actionForegroundColor, base.actionForegroundColor);
  expect(
    next.actionDisabledForegroundColor,
    base.actionDisabledForegroundColor,
  );
}

Widget _host(Widget child, {double width = 488}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

BoxDecoration? _decoration(WidgetTester tester) =>
    tester
            .widget<Container>(
              find
                  .descendant(
                    of: find.byType(LinagoraEmptyCard),
                    matching: find.byType(Container),
                  )
                  .first,
            )
            .decoration
        as BoxDecoration?;
