import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'starts the content column 83px in',
    _contentColumn,
  );
  testWidgets(
    'collapses the prefix gap when there is no prefix',
    _noPrefixCollapsesGap,
  );
  testWidgets('hugs its content when it does not expand', _hugsWithoutExpand);
  testWidgets('pins the trailing action when expanded', _expandPinsTrailing);
  testWidgets(
    'keeps the trailing action beside the content when not expanded',
    _unexpandedTrailingFollowsContent,
  );
  testWidgets('spaces a run by 8px', _runSpacing);
  testWidgets('reflows a run instead of overflowing', _runWraps);
  testWidgets(
    'fits a long value on a phone-width card',
    _noOverflowAtPhoneWidth,
  );
  testWidgets(
    'fits an expanding row with a trailing action on a phone',
    _noOverflowForExpandingRow,
  );
  testWidgets('stacks the label above the value when narrow', _adaptiveStacks);
  testWidgets('stays inline when there is room', _adaptiveStaysInline);
  testWidgets('drops the trailing action below a stacked row', _stackedTrailing);
  testWidgets('honours a pinned inline layout when narrow', _pinnedInline);
  testWidgets(
    'gives every grouped row one label column and a 16px gap',
    _groupSharesPrefixColumn,
  );
  testWidgets(
    'leaves a row that sets its own label column alone',
    _groupRespectsExplicitPrefixWidth,
  );
  testWidgets(
    'reaches a row nested inside a wrapper widget',
    _groupReachesNestedRow,
  );
  test('rejects a negative prefix width', _rejectsNegativePrefixWidth);
  test('rejects a negative run spacing', _rejectsNegativeRunSpacing);
}

Widget _host(Widget child, {double width = 600}) {
  return MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

Future<void> _contentColumn(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRow(
        prefix: LinagoraEventInfoLabel('When'),
        prefixWidth: LinagoraEventInfoRow.defaultPrefixWidth,
        content: LinagoraEventInfoText('Tuesday, Jun 16'),
      ),
    ),
  );

  final rowLeft = tester.getTopLeft(find.byType(LinagoraEventInfoRow)).dx;
  final labelLeft = tester.getTopLeft(find.text('When')).dx;
  final contentLeft = tester.getTopLeft(find.text('Tuesday, Jun 16')).dx;

  expect(labelLeft - rowLeft, 0);
  expect(contentLeft - rowLeft, 83);
}

Future<void> _noPrefixCollapsesGap(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const LinagoraEventInfoRow(content: LinagoraEventInfoText('Value'))),
  );

  final rowLeft = tester.getTopLeft(find.byType(LinagoraEventInfoRow)).dx;
  expect(tester.getTopLeft(find.text('Value')).dx - rowLeft, 0);
}

Future<void> _hugsWithoutExpand(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const Row(
        children: [
          LinagoraEventInfoRow(content: LinagoraEventInfoText('Short')),
        ],
      ),
    ),
  );

  final rowWidth = tester.getSize(find.byType(LinagoraEventInfoRow)).width;
  final textWidth = tester.getSize(find.text('Short')).width;
  expect(rowWidth, textWidth);
}

Future<void> _expandPinsTrailing(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEventInfoRow(
        expand: true,
        prefix: const LinagoraEventInfoLabel('Attending?'),
        prefixWidth: LinagoraEventInfoRow.defaultPrefixWidth,
        content: const LinagoraEventInfoText('Yes'),
        trailing: LinagoraEventInfoLink(
          label: 'See in your Calendar',
          onPressed: () {},
        ),
      ),
    ),
  );

  final rowRight = tester.getTopRight(find.byType(LinagoraEventInfoRow)).dx;
  final trailingRight = tester
      .getTopRight(find.text('See in your Calendar'))
      .dx;

  expect(rowRight - trailingRight, lessThan(1));
  expect(tester.getTopLeft(find.text('Yes')).dx, lessThan(trailingRight));
}

Future<void> _unexpandedTrailingFollowsContent(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const Row(
        children: [
          LinagoraEventInfoRow(
            content: LinagoraEventInfoText('Villa Good Tech'),
            trailing: SizedBox.square(dimension: 16, key: Key('icon')),
          ),
        ],
      ),
    ),
  );

  final contentRight = tester.getTopRight(find.text('Villa Good Tech')).dx;
  final trailingLeft = tester.getTopLeft(find.byKey(const Key('icon'))).dx;

  expect(
    trailingLeft - contentRight,
    LinagoraEventInfoRow.defaultTrailingSpacing,
  );
}

Future<void> _runSpacing(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRun(
        children: [
          LinagoraEventInfoText('Alex Martin'),
          LinagoraEventInfoText('alex.martin@example.invalid'),
        ],
      ),
    ),
  );

  final firstRight = tester.getTopRight(find.text('Alex Martin')).dx;
  final secondLeft = tester.getTopLeft(find.text('alex.martin@example.invalid')).dx;

  expect(secondLeft - firstRight, LinagoraEventInfoRun.defaultSpacing);
}

Future<void> _runWraps(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRun(
        children: [
          LinagoraEventInfoText('Alex Martin'),
          LinagoraEventInfoText('Someone Else Entirely'),
        ],
      ),
      width: 160,
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getTopLeft(find.text('Someone Else Entirely')).dy,
    greaterThan(tester.getTopLeft(find.text('Alex Martin')).dy),
  );
}

Future<void> _groupSharesPrefixColumn(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRowGroup(
        rows: [
          LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('When'),
            content: LinagoraEventInfoText('Tuesday, Jun 16'),
          ),
          LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('Where'),
            content: LinagoraEventInfoText('Villa Good Tech'),
          ),
        ],
      ),
    ),
  );

  final first = tester.getTopLeft(find.text('Tuesday, Jun 16'));
  final second = tester.getTopLeft(find.text('Villa Good Tech'));

  expect(second.dx, first.dx);
  expect(
    second.dy - tester.getBottomLeft(find.text('Tuesday, Jun 16')).dy,
    LinagoraEventInfoRowGroup.defaultSpacing,
  );
}

Future<void> _groupRespectsExplicitPrefixWidth(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRowGroup(
        rows: [
          LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('When'),
            content: LinagoraEventInfoText('Tuesday, Jun 16'),
          ),
          LinagoraEventInfoRow(
            prefixWidth: 120,
            prefix: LinagoraEventInfoLabel('Where'),
            content: LinagoraEventInfoText('Villa Good Tech'),
          ),
        ],
      ),
    ),
  );

  final rowLeft = tester
      .getTopLeft(find.byType(LinagoraEventInfoRowGroup))
      .dx;

  expect(tester.getTopLeft(find.text('Tuesday, Jun 16')).dx - rowLeft, 83);
  expect(tester.getTopLeft(find.text('Villa Good Tech')).dx - rowLeft, 136);
}

Future<void> _noOverflowAtPhoneWidth(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRowGroup(
        rows: [
          LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('Where'),
            content: LinagoraEventInfoRun(
              children: [
                LinagoraEventInfoText('Villa Good Tech, 37 rue Pierre'),
                LinagoraEventInfoLink(label: 'See in Map', onPressed: _noop),
              ],
            ),
          ),
          LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('Who'),
            content: LinagoraEventInfoRun(
              children: [
                LinagoraEventInfoText(
                  'Alex Martin',
                  emphasis: LinagoraEventInfoEmphasis.strong,
                ),
                LinagoraEventInfoText(
                  'alex.martin@example.invalid',
                  emphasis: LinagoraEventInfoEmphasis.muted,
                ),
                LinagoraEventInfoText('- Organizer'),
                LinagoraEventInfoLink(
                  label: 'See all participants',
                  onPressed: _noop,
                ),
              ],
            ),
          ),
        ],
      ),
      width: _phoneWidth,
    ),
  );

  expect(tester.takeException(), isNull);
}

Future<void> _noOverflowForExpandingRow(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRow(
        expand: true,
        stackedAlignment: CrossAxisAlignment.center,
        prefix: LinagoraEventInfoLabel('Attending?'),
        content: LinagoraEventInfoRun(
          alignment: WrapAlignment.center,
          children: [
            SizedBox(width: 73, height: 40),
            SizedBox(width: 67, height: 40),
            SizedBox(width: 94, height: 40),
            SizedBox(width: 150, height: 40),
          ],
        ),
        trailing: SizedBox(width: 183, height: 40),
      ),
      width: _phoneWidth,
    ),
  );

  expect(tester.takeException(), isNull);
}

Future<void> _adaptiveStacks(WidgetTester tester) async {
  await tester.pumpWidget(_host(_adaptiveRow, width: _phoneWidth));

  final label = tester.getTopLeft(find.text('Where'));
  final value = tester.getTopLeft(find.text('Villa Good Tech'));

  expect(value.dy, greaterThan(label.dy));
  expect(value.dx, label.dx, reason: 'a stacked value starts at the label');
}

Future<void> _adaptiveStaysInline(WidgetTester tester) async {
  await tester.pumpWidget(_host(_adaptiveRow));

  expect(
    tester.getCenter(find.text('Villa Good Tech')).dy,
    tester.getCenter(find.text('Where')).dy,
    reason: 'an inline row centres the label against the value',
  );
  expect(
    tester.getTopLeft(find.text('Villa Good Tech')).dx,
    greaterThan(tester.getTopLeft(find.text('Where')).dx),
  );
}

Future<void> _stackedTrailing(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRow(
        layout: LinagoraEventInfoRowLayout.stacked,
        prefix: LinagoraEventInfoLabel('Attending?'),
        content: LinagoraEventInfoText('Yes'),
        trailing: SizedBox.square(dimension: 16, key: Key('icon')),
      ),
    ),
  );

  expect(
    tester.getTopLeft(find.byKey(const Key('icon'))).dy,
    greaterThan(tester.getTopLeft(find.text('Yes')).dy),
  );
}

Future<void> _pinnedInline(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRow(
        layout: LinagoraEventInfoRowLayout.inline,
        prefix: LinagoraEventInfoLabel('Where'),
        content: LinagoraEventInfoText('Villa Good Tech'),
      ),
      width: _phoneWidth,
    ),
  );

  expect(
    tester.getCenter(find.text('Villa Good Tech')).dy,
    tester.getCenter(find.text('Where')).dy,
  );
}

const double _phoneWidth = 390;

const _adaptiveRow = LinagoraEventInfoRow(
  prefix: LinagoraEventInfoLabel('Where'),
  content: LinagoraEventInfoText('Villa Good Tech'),
);

void _noop() {}

Future<void> _groupReachesNestedRow(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEventInfoRowGroup(
        rows: [
          const LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('When'),
            content: LinagoraEventInfoText('Tuesday, Jun 16'),
          ),
          Builder(
            builder: (context) => const LinagoraEventInfoRow(
              prefix: LinagoraEventInfoLabel('Where'),
              content: LinagoraEventInfoText('Villa Good Tech'),
            ),
          ),
        ],
      ),
    ),
  );

  expect(
    tester.getTopLeft(find.text('Villa Good Tech')).dx,
    tester.getTopLeft(find.text('Tuesday, Jun 16')).dx,
    reason: 'a nested row still adopts the shared column',
  );
}

void _rejectsNegativePrefixWidth() {
  expect(
    () => LinagoraEventInfoRow(
      prefixWidth: -1,
      content: const LinagoraEventInfoText('Value'),
    ),
    throwsAssertionError,
  );
}

void _rejectsNegativeRunSpacing() {
  expect(
    () => LinagoraEventInfoRun(spacing: -1, children: const []),
    throwsAssertionError,
  );
}
