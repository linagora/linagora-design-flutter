import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  _registerInlineLayoutTests();
  _registerResponsiveLayoutTests();
  _registerGroupTests();
  _registerValidationTests();
}

void _registerInlineLayoutTests() {
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
    'shrink-wraps an adaptive expanded row under an unbounded width',
    _adaptiveExpandUnderUnboundedWidth,
  );
  testWidgets(
    'shrink-wraps an inline expanded row under an unbounded width',
    _inlineExpandUnderUnboundedWidth,
  );
  testWidgets(
    'keeps the trailing action beside the content when not expanded',
    _unexpandedTrailingFollowsContent,
  );
  testWidgets('spaces a run by 8px', _runSpacing);
  testWidgets('forwards custom run presentation', _runPresentation);
  testWidgets('reflows a run instead of overflowing', _runWraps);
  testWidgets(
    'reflows a single unbreakable token instead of overflowing',
    _runOverflowsUnbreakableToken,
  );
}

void _registerResponsiveLayoutTests() {
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
  testWidgets(
    'stays inline at the adaptive breakpoint',
    _adaptiveBoundaryStaysInline,
  );
  testWidgets(
    'honours a custom adaptive breakpoint',
    _adaptiveHonoursCustomBreakpoint,
  );
  testWidgets(
    'stays inline when its available width is unbounded',
    _adaptiveUsesInlineAtUnboundedWidth,
  );
  testWidgets('drops the trailing action below a stacked row', _stackedTrailing);
  testWidgets(
    'honours stacked spacing and alignment',
    _stackedSpacingAndAlignment,
  );
  testWidgets('honours a pinned inline layout when narrow', _pinnedInline);
  testWidgets('aligns the prefix directionally in RTL', _alignsPrefixInRtl);
  testWidgets(
    'fits long content with large accessible text',
    _fitsLargeAccessibleText,
  );
}

void _registerGroupTests() {
  testWidgets(
    'gives every grouped row one label column and a 16px gap',
    _groupSharesPrefixColumn,
  );
  testWidgets(
    'leaves a row that sets its own label column alone',
    _groupRespectsExplicitPrefixWidth,
  );
  testWidgets(
    'lets grouped prefixes size themselves when the column is null',
    _groupAllowsContentSizedPrefixes,
  );
  testWidgets(
    'reaches a row nested inside a wrapper widget',
    _groupReachesNestedRow,
  );
  test(
    'notifies dependants only when the shared prefix width changes',
    _prefixColumnNotification,
  );
}

void _registerValidationTests() {
  test('accepts zero measurements', _acceptsZeroMeasurements);
  test('rejects invalid measurements', _rejectsInvalidMeasurements);
  test('rejects unsupported baseline alignments', _rejectsBaselineAlignments);
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

Future<void> _adaptiveExpandUnderUnboundedWidth(WidgetTester tester) =>
    _expandUnderUnboundedWidth(tester, LinagoraEventInfoRowLayout.adaptive);

Future<void> _inlineExpandUnderUnboundedWidth(WidgetTester tester) =>
    _expandUnderUnboundedWidth(tester, LinagoraEventInfoRowLayout.inline);

Future<void> _expandUnderUnboundedWidth(
  WidgetTester tester,
  LinagoraEventInfoRowLayout layout,
) async {
  const hostKey = Key('unbounded-width-host');

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Row(
          key: hostKey,
          children: [
            LinagoraEventInfoRow(
              expand: true,
              layout: layout,
              prefix: const LinagoraEventInfoLabel('Attending?'),
              content: const LinagoraEventInfoText('Yes'),
              trailing: LinagoraEventInfoLink(
                label: 'See in your Calendar',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull, reason: '$layout must not use flex');
  expect(
    tester.getSize(find.byType(LinagoraEventInfoRow)).width,
    lessThan(tester.getSize(find.byKey(hostKey)).width),
    reason: '$layout must shrink-wrap when there is no finite width to fill',
  );
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

Future<void> _runPresentation(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRun(
        spacing: 3,
        runSpacing: 11,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [SizedBox.square(dimension: 16)],
      ),
    ),
  );

  final wrap = tester.widget<Wrap>(find.byType(Wrap));
  expect(
    (
      spacing: wrap.spacing,
      runSpacing: wrap.runSpacing,
      alignment: wrap.alignment,
      crossAxisAlignment: wrap.crossAxisAlignment,
    ),
    const (
      spacing: 3,
      runSpacing: 11,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.end,
    ),
  );
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

/// Gap: nothing previously exercised a single unbreakable token wider than
/// the row, the shape the class doc calls out as "reflows instead of
/// overflowing".
Future<void> _runOverflowsUnbreakableToken(WidgetTester tester) async {
  const longToken =
      'https://example.invalid/an-unbreakable-token-longer-than-the-row';

  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRun(children: [LinagoraEventInfoText(longToken)]),
      width: 200,
    ),
  );

  final container = tester.getRect(find.byType(LinagoraEventInfoRun));
  final text = tester.getRect(find.text(longToken));

  expect(tester.takeException(), isNull);
  expect(text.right, lessThanOrEqualTo(container.right));
  expect(
    text.height,
    greaterThan(LinagoraEventInfoText.lineHeight),
    reason: 'the token must occupy multiple visual lines instead of clipping',
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

Future<void> _groupAllowsContentSizedPrefixes(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRowGroup(
        prefixWidth: null,
        rows: [
          LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('At'),
            content: LinagoraEventInfoText('Tuesday, Jun 16'),
          ),
          LinagoraEventInfoRow(
            prefix: LinagoraEventInfoLabel('Location'),
            content: LinagoraEventInfoText('Villa Good Tech'),
          ),
        ],
      ),
    ),
  );

  expect(
    tester.getTopLeft(find.text('Tuesday, Jun 16')).dx,
    lessThan(tester.getTopLeft(find.text('Villa Good Tech')).dx),
  );
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

Future<void> _adaptiveBoundaryStaysInline(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _adaptiveRow,
      width: LinagoraEventInfoRow.defaultStackedBreakpoint,
    ),
  );

  expect(
    tester.getCenter(find.text('Villa Good Tech')).dy,
    tester.getCenter(find.text('Where')).dy,
  );
}

Future<void> _adaptiveHonoursCustomBreakpoint(WidgetTester tester) async {
  const customBreakpoint = 520.0;
  const row = LinagoraEventInfoRow(
    stackedBreakpoint: customBreakpoint,
    prefix: LinagoraEventInfoLabel('Where'),
    content: LinagoraEventInfoText('Villa Good Tech'),
  );

  await tester.pumpWidget(_host(row, width: customBreakpoint - 1));
  expect(
    tester.getTopLeft(find.text('Villa Good Tech')).dy,
    greaterThan(tester.getTopLeft(find.text('Where')).dy),
  );

  await tester.pumpWidget(_host(row, width: customBreakpoint));
  expect(
    tester.getCenter(find.text('Villa Good Tech')).dy,
    tester.getCenter(find.text('Where')).dy,
  );
}

Future<void> _adaptiveUsesInlineAtUnboundedWidth(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const Row(children: [_adaptiveRow]),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getCenter(find.text('Villa Good Tech')).dy,
    tester.getCenter(find.text('Where')).dy,
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

Future<void> _stackedSpacingAndAlignment(WidgetTester tester) async {
  const trailingKey = Key('stacked-trailing');
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRow(
        layout: LinagoraEventInfoRowLayout.stacked,
        stackedAlignment: CrossAxisAlignment.end,
        stackedSpacing: 12,
        prefix: LinagoraEventInfoLabel('Where'),
        content: LinagoraEventInfoText('Villa Good Tech'),
        trailing: SizedBox.square(dimension: 16, key: trailingKey),
      ),
    ),
  );

  final row = tester.getRect(find.byType(LinagoraEventInfoRow));
  final prefix = tester.getRect(find.text('Where'));
  final content = tester.getRect(find.text('Villa Good Tech'));
  final trailing = tester.getRect(find.byKey(trailingKey));

  expect(row.right - prefix.right, closeTo(0, 0.01));
  expect(content.top - prefix.bottom, closeTo(12, 0.01));
  expect(trailing.top - content.bottom, closeTo(12, 0.01));
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

Future<void> _alignsPrefixInRtl(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: LinagoraEventInfoRow(
          layout: LinagoraEventInfoRowLayout.inline,
          prefixWidth: LinagoraEventInfoRow.defaultPrefixWidth,
          prefix: LinagoraEventInfoLabel('Where'),
          content: LinagoraEventInfoText('Villa Good Tech'),
        ),
      ),
    ),
  );

  final row = tester.getRect(find.byType(LinagoraEventInfoRow));
  final prefix = tester.getRect(find.text('Where'));
  final content = tester.getRect(find.text('Villa Good Tech'));

  expect(row.right - prefix.right, closeTo(0, 0.01));
  expect(content.right, lessThan(prefix.left));
}

Future<void> _fitsLargeAccessibleText(WidgetTester tester) async {
  const hostKey = Key('large-text-host');
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(2),
        ),
        child: child!,
      ),
      home: const Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            key: hostKey,
            width: 320,
            child: LinagoraEventInfoRowGroup(
              rows: [
                LinagoraEventInfoRow(
                  prefix: LinagoraEventInfoLabel(
                    'A long localised location label',
                  ),
                  content: LinagoraEventInfoRun(
                    children: [
                      LinagoraEventInfoText(
                        'Villa Good Tech, 37 rue Pierre and another long value',
                      ),
                      LinagoraEventInfoLink(
                        label: 'See this location on the map',
                        onPressed: _noop,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  final host = tester.getRect(find.byKey(hostKey));
  final group = tester.getRect(find.byType(LinagoraEventInfoRowGroup));

  expect(tester.takeException(), isNull);
  expect(group.left, greaterThanOrEqualTo(host.left));
  expect(group.right, lessThanOrEqualTo(host.right));
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

void _prefixColumnNotification() {
  const child = SizedBox();
  const current = LinagoraEventInfoPrefixColumn(width: 67, child: child);

  expect(
    current.updateShouldNotify(
      const LinagoraEventInfoPrefixColumn(width: 67, child: child),
    ),
    isFalse,
  );
  expect(
    current.updateShouldNotify(
      const LinagoraEventInfoPrefixColumn(width: 80, child: child),
    ),
    isTrue,
  );
}

void _acceptsZeroMeasurements() {
  _expectReturnsNormally([
    () => const LinagoraEventInfoRow(
          prefixWidth: 0,
          prefixSpacing: 0,
          trailingSpacing: 0,
          stackedBreakpoint: 0,
          stackedSpacing: 0,
          content: SizedBox(),
        ),
    () => const LinagoraEventInfoRun(
          spacing: 0,
          runSpacing: 0,
          children: [],
        ),
    () => const LinagoraEventInfoPrefixColumn(
          width: 0,
          child: SizedBox(),
        ),
    () => const LinagoraEventInfoRowGroup(
          spacing: 0,
          prefixWidth: 0,
          rows: [],
        ),
  ]);
}

void _expectReturnsNormally(List<void Function()> constructors) {
  for (final constructor in constructors) {
    expect(constructor, returnsNormally);
  }
}

void _rejectsInvalidMeasurements() {
  const invalid = [
    -1.0,
    double.nan,
    double.infinity,
    double.negativeInfinity,
  ];

  _expectInvalidRowMeasurements(invalid);
  _expectInvalidRunMeasurements(invalid);
  _expectInvalidGroupMeasurements(invalid);
}

typedef _InvalidMeasurement = ({
  String description,
  Object Function(double value) create,
});

void _expectInvalidRowMeasurements(List<double> invalid) {
  _expectAssertionFailures(invalid, [
    (
      description: 'prefix width',
      create: (value) => LinagoraEventInfoRow(
        prefixWidth: value,
        content: const SizedBox(),
      ),
    ),
    (
      description: 'prefix spacing',
      create: (value) => LinagoraEventInfoRow(
        prefixSpacing: value,
        content: const SizedBox(),
      ),
    ),
    (
      description: 'trailing spacing',
      create: (value) => LinagoraEventInfoRow(
        trailingSpacing: value,
        content: const SizedBox(),
      ),
    ),
    (
      description: 'stacked breakpoint',
      create: (value) => LinagoraEventInfoRow(
        stackedBreakpoint: value,
        content: const SizedBox(),
      ),
    ),
    (
      description: 'stacked spacing',
      create: (value) => LinagoraEventInfoRow(
        stackedSpacing: value,
        content: const SizedBox(),
      ),
    ),
  ]);
}

void _expectInvalidRunMeasurements(List<double> invalid) {
  _expectAssertionFailures(invalid, [
    (
      description: 'run spacing',
      create: (value) => LinagoraEventInfoRun(
        spacing: value,
        children: const [],
      ),
    ),
    (
      description: 'run line spacing',
      create: (value) => LinagoraEventInfoRun(
        runSpacing: value,
        children: const [],
      ),
    ),
    (
      description: 'inherited prefix width',
      create: (value) => LinagoraEventInfoPrefixColumn(
        width: value,
        child: const SizedBox(),
      ),
    ),
  ]);
}

void _expectInvalidGroupMeasurements(List<double> invalid) {
  _expectAssertionFailures(invalid, [
    (
      description: 'group spacing',
      create: (value) => LinagoraEventInfoRowGroup(
        spacing: value,
        rows: const [],
      ),
    ),
    (
      description: 'group prefix width',
      create: (value) => LinagoraEventInfoRowGroup(
        prefixWidth: value,
        rows: const [],
      ),
    ),
  ]);
}

void _expectAssertionFailures(
  List<double> invalid,
  List<_InvalidMeasurement> measurements,
) {
  for (final value in invalid) {
    for (final measurement in measurements) {
      expect(
        () => measurement.create(value),
        throwsAssertionError,
        reason: 'Invalid ${measurement.description} $value must be rejected',
      );
    }
  }
}

void _rejectsBaselineAlignments() {
  expect(
    () => LinagoraEventInfoRow(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      content: const SizedBox(),
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraEventInfoRow(
      stackedAlignment: CrossAxisAlignment.baseline,
      content: const SizedBox(),
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraEventInfoRowGroup(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      rows: const [],
    ),
    throwsAssertionError,
  );
}
