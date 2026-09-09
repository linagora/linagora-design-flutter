import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets('matches the Figma date-icon geometry and typography', _figmaInk);
  testWidgets(
    'scales its complete geometry and accepts visual overrides',
    _overrides,
  );
  testWidgets('scales shadows from the 50px Figma coordinate space', _shadow);
  testWidgets('exposes one accessible date label', _semantics);
  test('rejects invalid date content and sizes', _invalidInputs);
}

Future<void> _figmaInk(WidgetTester tester) async {
  await _pump(tester, LinagoraEventDateIcon(month: 'Jun', day: '16'));

  expect(
    tester.getSize(find.byType(LinagoraEventDateIcon)),
    const Size.square(50),
  );

  final surface = tester.widget<DecoratedBox>(_surfaceFinder());
  final decoration = surface.decoration as BoxDecoration;
  expect(decoration.color, LinagoraEventDateIcon.defaultBackgroundColor);
  expect(decoration.borderRadius, BorderRadius.circular(11.765));
  expect(decoration.boxShadow, [LinagoraEventDateIcon.defaultShadow]);

  final header = tester.widget<ColoredBox>(_headerFinder());
  expect(header.color, LinagoraEventDateIcon.defaultHeaderColor);
  expect(tester.getSize(_headerFinder()).height, closeTo(15.685, 0.001));

  final month = tester.widget<Text>(find.text('JUN'));
  expect(month.style?.fontSize, 8.824);
  expect(month.style?.fontWeight, FontWeight.w600);
  expect(
    month.style?.fontFamily,
    'packages/linagora_design_flutter/TwakeInter',
  );
  expect(month.style?.height, 1);
  expect(month.style?.letterSpacing, 0);
  expect(month.style?.color, LinagoraEventDateIcon.defaultMonthTextColor);

  final day = tester.widget<Text>(find.text('16'));
  expect(day.style?.fontSize, 27.451);
  expect(day.style?.fontWeight, FontWeight.w300);
  expect(
    day.style?.fontFamily,
    'packages/linagora_design_flutter/TwakeInter',
  );
  expect(day.style?.height, 1);
  expect(day.style?.letterSpacing, 0);
  expect(day.style?.color, LinagoraEventDateIcon.defaultDayTextColor);
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

  final surface = tester.widget<DecoratedBox>(_surfaceFinder());
  final decoration = surface.decoration as BoxDecoration;
  expect(decoration.color, backgroundColor);
  expect(decoration.boxShadow, isNull);

  expect(tester.widget<Text>(find.text('SEP')).style?.fontSize, 17.648);
  expect(tester.widget<Text>(find.text('SEP')).style?.color, monthColor);
  expect(tester.widget<Text>(find.text('24')).style?.fontSize, 54.902);
  expect(tester.widget<Text>(find.text('24')).style?.color, dayColor);
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

  final surface = tester.widget<DecoratedBox>(_surfaceFinder());
  final decoration = surface.decoration as BoxDecoration;
  expect(decoration.boxShadow, [shadow.scale(2)]);
}

void _invalidInputs() {
  expect(
    () => LinagoraEventDateIcon(month: '', day: '16'),
    throwsArgumentError,
  );
  expect(
    () => LinagoraEventDateIcon(month: 'June', day: '16'),
    throwsArgumentError,
  );
  expect(
    () => LinagoraEventDateIcon(month: 'Jun', day: ''),
    throwsArgumentError,
  );
  expect(
    () => LinagoraEventDateIcon(month: 'Jun', day: '160'),
    throwsArgumentError,
  );
  expect(
    () => LinagoraEventDateIcon(month: 'Jun', day: '32'),
    throwsArgumentError,
  );
  expect(
    () => LinagoraEventDateIcon(month: 'Jun', day: 'AA'),
    throwsArgumentError,
  );
  expect(
    () => LinagoraEventDateIcon(month: 'Jun', day: '16', size: 0),
    throwsArgumentError,
  );
}

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
