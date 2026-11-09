import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Widget _host(Widget child, {double width = 400}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          child: Align(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('LinagoraDismissibleChip', () {
    testWidgets('is a 32 high pill with the label and a close button', _pill);
    testWidgets('shows the leading widget before the label', _leading);
    testWidgets('mirrors leading and dismiss in RTL', _rtl);
    testWidgets('ellipsizes a long label without overflow', _ellipsizes);
    testWidgets(
      'ellipsizes beside a sibling when wrapped in Flexible',
      _ellipsizesInRow,
    );
    testWidgets('grows with the text scale', _growsWithTextScale);
    testWidgets('names the close button for screen readers', _semantics);
    testWidgets(
      'keeps a 48dp close target around a 32 high pill',
      _tapTarget,
    );
  });
  group('LinagoraDismissibleChipStyle', () {
    testWidgets('paints the dark tokens', _darkChip);
    test('copyWith overrides one field and keeps the rest', _copyWith);
  });
}

Future<void> _pill(WidgetTester tester) async {
  var dismissed = 0;
  await tester.pumpWidget(
    _host(
      LinagoraDismissibleChip(
        label: 'Viewing Nora Hale',
        dismissTooltip: 'Back to my mailbox',
        onDismissed: () => dismissed++,
      ),
    ),
  );

  final chip = tester.getRect(find.byType(LinagoraDismissibleChip));
  final close = tester.getRect(find.byKey(LinagoraDismissibleChip.dismissKey));
  expect(chip.height, 48);
  expect(_pillHeight(tester), 32);
  expect(find.text('Viewing Nora Hale'), findsOneWidget);
  expect(close.size, const Size(48, 48));
  expect(close.center.dy, closeTo(chip.center.dy, 0.5));
  expect(close.right, chip.right);
  final decoration =
      tester
              .widget<Container>(
                find.descendant(
                  of: find.byType(LinagoraDismissibleChip),
                  matching: find.byType(Container),
                ),
              )
              .decoration
          as BoxDecoration;
  expect(decoration.borderRadius, BorderRadius.circular(16));
  expect(decoration.border, isNotNull);

  await tester.tapAt(close.center);
  expect(dismissed, 1);
}

Future<void> _rtl(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Center(
            child: LinagoraDismissibleChip(
              label: 'Viewing Nora Hale',
              dismissTooltip: 'Back to my mailbox',
              leading: const SizedBox.square(
                dimension: 20,
                key: ValueKey('lead'),
              ),
              onDismissed: () {},
            ),
          ),
        ),
      ),
    ),
  );

  expect(
    tester.getRect(find.byKey(const ValueKey('lead'))).left,
    greaterThan(tester.getRect(find.text('Viewing Nora Hale')).right),
  );
  expect(
    tester.getRect(find.byKey(LinagoraDismissibleChip.dismissKey)).left,
    lessThan(tester.getRect(find.text('Viewing Nora Hale')).left),
  );
}

double _pillHeight(WidgetTester tester) {
  return tester
      .getSize(
        find.descendant(
          of: find.byType(LinagoraDismissibleChip),
          matching: find.byType(Container),
        ),
      )
      .height;
}

Future<void> _leading(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraDismissibleChip(
        label: 'Viewing Nora Hale',
        dismissTooltip: 'Back to my mailbox',
        leading: const SizedBox.square(dimension: 20, key: ValueKey('lead')),
        onDismissed: () {},
      ),
    ),
  );

  expect(
    tester.getRect(find.byKey(const ValueKey('lead'))).right,
    lessThan(tester.getRect(find.text('Viewing Nora Hale')).left),
  );
}

Future<void> _ellipsizes(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraDismissibleChip(
        label: 'Viewing a very long owner name that cannot fit here',
        dismissTooltip: 'Back to my mailbox',
        onDismissed: () {},
      ),
      width: 160,
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.byKey(LinagoraDismissibleChip.dismissKey), findsOneWidget);
}

Future<void> _ellipsizesInRow(WidgetTester tester) async {
  const label = 'Viewing Catherine Williamson';
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 360,
          child: Row(
            children: [
              const Text('Inbox'),
              Flexible(
                child: LinagoraDismissibleChip(
                  label: label,
                  leading: const SizedBox.square(dimension: 20),
                  dismissTooltip: 'Back to my mailbox',
                  onDismissed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getSize(find.byType(LinagoraDismissibleChip)).width,
    lessThan(360),
  );
  expect(
    tester.getRect(find.byKey(LinagoraDismissibleChip.dismissKey)).right,
    lessThanOrEqualTo(360),
  );
  expect(
    tester.renderObject<RenderParagraph>(find.text(label)).didExceedMaxLines,
    isTrue,
  );
}

Future<void> _growsWithTextScale(WidgetTester tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: _host(
        LinagoraDismissibleChip(
          label: 'Hi',
          dismissTooltip: 'Back to my mailbox',
          onDismissed: () {},
        ),
      ),
    ),
  );

  final chip = tester.getSize(find.byType(LinagoraDismissibleChip));
  expect(chip.height, 64);
  expect(
    chip.height,
    greaterThanOrEqualTo(tester.getSize(find.text('Hi')).height),
  );
}

Future<void> _semantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      LinagoraDismissibleChip(
        label: 'Viewing Nora Hale',
        dismissTooltip: 'Back to my mailbox',
        onDismissed: () {},
      ),
    ),
  );

  expect(
    tester.getSemantics(find.byKey(LinagoraDismissibleChip.dismissKey)),
    containsSemantics(
      tooltip: 'Back to my mailbox',
      isButton: true,
      hasTapAction: true,
    ),
  );
  handle.dispose();
}

Future<void> _darkChip(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraDismissibleChip(
        label: 'Viewing Nora Hale',
        dismissTooltip: 'Back to my mailbox',
        onDismissed: () {},
        style: LinagoraDismissibleChipStyle.dark(),
      ),
    ),
  );

  final decoration =
      tester
              .widget<Container>(
                find.descendant(
                  of: find.byType(LinagoraDismissibleChip),
                  matching: find.byType(Container),
                ),
              )
              .decoration
          as BoxDecoration;
  expect(decoration.color, const Color(0x14FFFFFF));
  expect(
    tester.widget<Text>(find.text('Viewing Nora Hale')).style?.color,
    Colors.white,
  );
}

Future<void> _tapTarget(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  var dismissed = 0;
  await tester.pumpWidget(
    _host(
      LinagoraDismissibleChip(
        label: 'Viewing Nora Hale',
        dismissTooltip: 'Back to my mailbox',
        onDismissed: () => dismissed++,
      ),
    ),
  );

  expect(tester.getSize(find.byType(LinagoraDismissibleChip)).height, 48);
  expect(_pillHeight(tester), 32);
  expect(
    tester.getSize(find.byKey(LinagoraDismissibleChip.dismissKey)),
    const Size(48, 48),
  );
  final close = tester.getRect(find.byKey(LinagoraDismissibleChip.dismissKey));
  await tester.tapAt(Offset(close.center.dx, close.top + 1));
  await tester.tapAt(Offset(close.center.dx, close.bottom - 1));
  await tester.tapAt(Offset(close.left + 1, close.center.dy));
  await tester.tapAt(Offset(close.right - 1, close.center.dy));
  expect(dismissed, 4);
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  handle.dispose();
}

void _copyWith() {
  final base = LinagoraDismissibleChipStyle.material();
  final next = base.copyWith(dismissTargetSize: 56);
  expect(next.dismissTargetSize, 56);
  expect(next.height, base.height);
  expect(next.iconSize, base.iconSize);
  expect(next.color, base.color);
}
