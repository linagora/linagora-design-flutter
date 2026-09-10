import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _fontFamily = 'packages/linagora_design_flutter/TwakeInter';

/// The per-label facts that vary between the month and day labels.
typedef _LabelStyle = ({double fontSize, FontWeight fontWeight, Color color});

void main() {
  testWidgets('matches the Figma date-icon geometry and typography', _figmaInk);
  testWidgets(
    'scales its complete geometry and accepts visual overrides',
    _overrides,
  );
  testWidgets('scales shadows from the 50px Figma coordinate space', _shadow);
  testWidgets('exposes one accessible date label', _semantics);
  testWidgets('keeps a two-digit day whole inside the icon', _twoDigitDay);
  test('rejects invalid date content and sizes', _invalidInputs);
}

Future<void> _figmaInk(WidgetTester tester) async {
  await _pump(tester, LinagoraEventDateIcon(month: 'Jun', day: '16'));

  expect(
    tester.getSize(find.byType(LinagoraEventDateIcon)),
    const Size.square(50),
  );

  expect(
    _decorationOf(tester),
    _isSurface(
      color: LinagoraEventDateIcon.defaultBackgroundColor,
      borderRadius: BorderRadius.circular(11.765),
      boxShadow: [LinagoraEventDateIcon.defaultShadow],
    ),
  );

  final header = tester.widget<ColoredBox>(_headerFinder());
  expect(header.color, LinagoraEventDateIcon.defaultHeaderColor);
  expect(tester.getSize(_headerFinder()).height, closeTo(15.685, 0.001));

  _expectLabelStyle(tester, 'JUN', (
    fontSize: 8.824,
    fontWeight: FontWeight.w600,
    color: LinagoraEventDateIcon.defaultMonthTextColor,
  ));
  _expectLabelStyle(tester, '16', (
    fontSize: 27.451,
    fontWeight: FontWeight.w300,
    color: LinagoraEventDateIcon.defaultDayTextColor,
  ));
}

Future<void> _overrides(WidgetTester tester) async {
  const headerColor = Color(0xFF012345);
  const backgroundColor = Color(0xFF456789);
  const monthColor = Color(0xFFABCDEF);
  const dayColor = Color(0xFFFEDCBA);

  await _pump(
    tester,
    LinagoraEventDateIcon(
      month: 'Sep',
      day: '24',
      size: 100,
      headerColor: headerColor,
      backgroundColor: backgroundColor,
      monthTextColor: monthColor,
      dayTextColor: dayColor,
      shadow: null,
    ),
  );

  expect(
    tester.getSize(find.byType(LinagoraEventDateIcon)),
    const Size.square(100),
  );
  expect(tester.widget<ColoredBox>(_headerFinder()).color, headerColor);

  expect(
    _decorationOf(tester),
    _isSurface(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(23.53),
      boxShadow: null,
    ),
  );

  _expectLabelStyle(tester, 'SEP', (
    fontSize: 17.648,
    fontWeight: FontWeight.w600,
    color: monthColor,
  ));
  _expectLabelStyle(tester, '24', (
    fontSize: 54.902,
    fontWeight: FontWeight.w300,
    color: dayColor,
  ));
}

Future<void> _semantics(WidgetTester tester) async {
  await _pump(
    tester,
    LinagoraEventDateIcon(
      month: 'Jun',
      day: '16',
      semanticLabel: 'Event date, June 16',
    ),
  );

  expect(find.bySemanticsLabel('Event date, June 16'), findsOneWidget);
}

Future<void> _twoDigitDay(WidgetTester tester) async {
  await _pump(tester, LinagoraEventDateIcon(month: 'Jun', day: '28'));

  final icon = tester.getRect(find.byType(LinagoraEventDateIcon));
  _expectLabelFits(tester, '28', within: icon);
  _expectLabelFits(tester, 'JUN', within: icon);

  expect(
    tester.getRect(find.text('28')).center.dx,
    closeTo(icon.center.dx, 0.001),
  );
}

Future<void> _shadow(WidgetTester tester) async {
  const shadow = BoxShadow(
    color: Color(0x26000000),
    offset: Offset(1, 2),
    blurRadius: 3,
  );

  await _pump(
    tester,
    LinagoraEventDateIcon(month: 'Jun', day: '16', size: 100, shadow: shadow),
  );

  expect(_decorationOf(tester).boxShadow, [shadow.scale(2)]);
}

void _invalidInputs() {
  const invalidDateParts = <(String month, String day)>[
    ('', '16'),
    ('June', '16'),
    ('Jun', ''),
    ('Jun', '160'),
    ('Jun', '32'),
    ('Jun', 'AA'),
    ('Jun', '+5'),
    ('Jun', '-5'),
    ('Jun', ' 5'),
  ];

  for (final (month, day) in invalidDateParts) {
    expect(
      () => LinagoraEventDateIcon(month: month, day: day),
      throwsArgumentError,
      reason: 'month "$month" with day "$day" must be rejected',
    );
  }

  expect(
    () => LinagoraEventDateIcon(month: 'Jun', day: '16', size: 0),
    throwsArgumentError,
  );
}

/// Asserts the whole typography contract of one label at once, so a failure
/// reports every mismatching field instead of only the first.
void _expectLabelStyle(WidgetTester tester, String text, _LabelStyle expected) {
  expect(
    tester.widget<Text>(find.text(text)).style,
    isA<TextStyle>()
        .having((style) => style.fontSize, 'fontSize', expected.fontSize)
        .having((style) => style.fontWeight, 'fontWeight', expected.fontWeight)
        .having((style) => style.fontFamily, 'fontFamily', _fontFamily)
        .having((style) => style.height, 'height', 1)
        .having((style) => style.letterSpacing, 'letterSpacing', 0)
        .having((style) => style.color, 'color', expected.color),
  );
}

/// Asserts [text] renders whole: never truncated onto a dropped line, never
/// past the icon edge.
void _expectLabelFits(
  WidgetTester tester,
  String text, {
  required Rect within,
}) {
  final label = tester.getRect(find.text(text));

  expect(
    tester.renderObject<RenderParagraph>(find.text(text)).didExceedMaxLines,
    isFalse,
    reason: '"$text" must fit on a single line',
  );
  expect(label.left, greaterThanOrEqualTo(within.left));
  expect(label.right, lessThanOrEqualTo(within.right));
}

Matcher _isSurface({
  required Color color,
  required BorderRadius borderRadius,
  required List<BoxShadow>? boxShadow,
}) {
  return isA<BoxDecoration>()
      .having((decoration) => decoration.color, 'color', color)
      .having(
        (decoration) => decoration.borderRadius,
        'borderRadius',
        borderRadius,
      )
      .having((decoration) => decoration.boxShadow, 'boxShadow', boxShadow);
}

BoxDecoration _decorationOf(WidgetTester tester) =>
    tester.widget<DecoratedBox>(_surfaceFinder()).decoration as BoxDecoration;

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

Finder _surfaceFinder() => find.descendant(
  of: find.byType(LinagoraEventDateIcon),
  matching: find.byType(DecoratedBox),
);

Finder _headerFinder() => find.descendant(
  of: find.byType(LinagoraEventDateIcon),
  matching: find.byType(ColoredBox),
);
