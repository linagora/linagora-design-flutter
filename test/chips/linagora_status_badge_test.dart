import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Widget _host(Widget child, {double width = 400}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: width, child: Center(child: child)),
      ),
    ),
  );
}

ShapeDecoration _decoration(WidgetTester tester) {
  return tester
          .widget<DecoratedBox>(
            find.descendant(
              of: find.byType(LinagoraStatusBadge),
              matching: find.byType(DecoratedBox),
            ),
          )
          .decoration
      as ShapeDecoration;
}

void main() {
  group('LinagoraStatusBadge', () {
    testWidgets('is a 32 high blue pill with the label', _pill);
    testWidgets('uses the dark tokens when given', _dark);
    testWidgets('ellipsizes a long label without overflow', _ellipsizes);
    testWidgets(
      'ellipsizes beside a sibling when wrapped in Flexible',
      _ellipsizesInRow,
    );
  });
  test('copyWith overrides one field and keeps the rest', _copyWith);
}

Future<void> _pill(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const LinagoraStatusBadge(label: 'Delegated mailbox')),
  );

  expect(find.text('Delegated mailbox'), findsOneWidget);
  expect(tester.getSize(find.byType(LinagoraStatusBadge)).height, 32);
  final decoration = _decoration(tester);
  expect(decoration.shape, const StadiumBorder());
  expect(decoration.color, const Color(0x140A84FF));
  final text = tester.widget<Text>(find.text('Delegated mailbox')).style!;
  expect(text.color, const Color(0xFF0A84FF));
  expect(text.fontSize, 12);
  expect(text.fontWeight, FontWeight.w500);
}

Future<void> _dark(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraStatusBadge(
        label: 'Delegated mailbox',
        style: LinagoraStatusBadgeStyle.dark(),
      ),
    ),
  );

  expect(_decoration(tester).color, const Color(0x299BBEFA));
  expect(
    tester.widget<Text>(find.text('Delegated mailbox')).style?.color,
    const Color(0xFF9BBEFA),
  );
}

Future<void> _ellipsizes(WidgetTester tester) async {
  const label = 'A very long state name that cannot fit in the badge';
  await tester.pumpWidget(
    _host(
      const SizedBox(width: 120, child: LinagoraStatusBadge(label: label)),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.renderObject<RenderParagraph>(find.text(label)).didExceedMaxLines,
    isTrue,
  );
}

Future<void> _ellipsizesInRow(WidgetTester tester) async {
  const label = 'A very long state name that cannot fit in the badge';
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 360,
          child: Row(
            children: [
              Text('Inbox'),
              Flexible(child: LinagoraStatusBadge(label: label)),
            ],
          ),
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getSize(find.byType(LinagoraStatusBadge)).width,
    lessThan(360),
  );
  expect(
    tester.renderObject<RenderParagraph>(find.text(label)).didExceedMaxLines,
    isTrue,
  );
}

void _copyWith() {
  final base = LinagoraStatusBadgeStyle.material();
  final next = base.copyWith(color: const Color(0xFF00AA44));
  expect(next.color, const Color(0xFF00AA44));
  expect(next.padding, base.padding);
  expect(next.textStyle, base.textStyle);
}
