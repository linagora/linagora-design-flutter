import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

enum _Tab { mine, shared, archived }

const _segments = [
  LinagoraSegment(value: _Tab.mine, label: 'My delegates'),
  LinagoraSegment(value: _Tab.shared, label: 'Delegated to me'),
];

void main() {
  group('LinagoraSegmentedTabs layout', () {
    testWidgets(
      'is a 32 high track with 160 wide segments by default',
      _defaultSize,
    );
    testWidgets('shares the width equally when expanded', _expanded);
    testWidgets(
      'paints the selected segment white with a shadow',
      _selectedPaint,
    );
    testWidgets(
      'ellipsizes long labels at 2x text scale without overflow',
      _ellipsis,
    );
    testWidgets('takes its height from the given style', _customHeight);
    testWidgets('uses the dark tokens when given', _darkTokens);
  });

  group('LinagoraSegmentedTabs selection', () {
    testWidgets('reports a tap on another segment', _tapOther);
    testWidgets('ignores a tap on the selected segment', _tapSelected);
    testWidgets(
      'focuses on tap so arrow keys work without Tab first',
      _tapThenArrow,
    );
    testWidgets('does not paint a focus ring after a pointer tap', _tapNoRing);
  });

  group('LinagoraSegmentedTabs keyboard', () {
    testWidgets('is reachable with Tab and shows a focus ring', _focusRing);
    testWidgets(
      'selects the next and previous segment with arrow keys',
      _arrows,
    );
    testWidgets('mirrors arrow keys in RTL', _rtlArrows);
    testWidgets('jumps to the ends with Home and End', _homeEnd);
    testWidgets('does not move past the last segment', _staysAtEnd);
    testWidgets('does not move past the first segment', _staysAtStart);
    testWidgets(
      'ignores a key that does not move the selection',
      _ignoresOtherKeys,
    );
  });

  testWidgets('announces segments as a selectable exclusive group', _semantics);
  testWidgets(
    'keeps the selected segment name on the focused node',
    _focusedKeepsName,
  );

  group('LinagoraSegmentedTabs contract', () {
    test('rejects one segment', _rejectsOneSegment);
    test('rejects a selected value outside the list', _rejectsUnknownSelected);
    test('rejects a repeated value', _rejectsRepeatedValue);
    test(
      'rejects equal values even when hashCodes differ',
      _rejectsEqualWithoutHashCode,
    );
    test('keys a segment by equality, not its print', _keysByEquality);
  });
}

Future<void> _defaultSize(WidgetTester tester) async {
  await tester.pumpWidget(_host(_tabs(selected: _Tab.mine)));

  expect(tester.getSize(_segment(_Tab.mine)), const Size(160, 32));
  expect(tester.getSize(_segment(_Tab.shared)), const Size(160, 32));
}

Future<void> _expanded(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(_tabs(selected: _Tab.mine, expanded: true), width: 360),
  );

  expect(tester.getSize(_segment(_Tab.mine)).width, 180);
  expect(tester.getSize(_segment(_Tab.shared)).width, 180);
}

Future<void> _selectedPaint(WidgetTester tester) async {
  await tester.pumpWidget(_host(_tabs(selected: _Tab.shared)));

  final selected = _segmentDecoration(tester, _Tab.shared);
  expect(selected.color, Colors.white);
  expect(selected.boxShadow, const [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 80),
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 1,
    ),
  ]);
  expect(_segmentDecoration(tester, _Tab.mine).boxShadow, isNull);
  expect(_labelColor(tester, 'Delegated to me'), const Color(0xFF0A84FF));
  expect(_labelColor(tester, 'My delegates'), const Color(0xA3424244));
  final label = tester.widget<Text>(find.text('My delegates')).style!;
  expect(label.fontSize, 14);
  expect(label.fontWeight, FontWeight.w600);
  expect(label.letterSpacing, 0.25);
  expect(label.height, 18.4 / 14);
  final track = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(LinagoraSegmentedTabs<_Tab>),
          matching: find.byType(Container),
        )
        .first,
  );
  expect((track.decoration! as BoxDecoration).color, const Color(0x0C1D212A));
}

Future<void> _darkTokens(WidgetTester tester) async {
  final style = LinagoraSegmentedTabsStyle.dark();
  await tester.pumpWidget(
    _host(_tabs(selected: _Tab.shared, style: style)),
  );

  expect(_trackColor(tester), const Color(0x14FFFFFF));
  expect(
    _segmentDecoration(tester, _Tab.shared).color,
    const Color(0xFF3E424A),
  );
  expect(_labelColor(tester, 'Delegated to me'), const Color(0xFF91BFFF));
  expect(_labelColor(tester, 'My delegates'), const Color(0xA3FFFFFF));
  expect(style.hoverColor, const Color(0x14FFFFFF));
  expect(style.focusColor, const Color(0xFF91BFFF));
  expect(
    style.selectedShadow,
    LinagoraSegmentedTabsStyle.material().selectedShadow,
  );
}

Future<void> _ellipsis(WidgetTester tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: _host(
        LinagoraSegmentedTabs<_Tab>(
          segments: const [
            LinagoraSegment(value: _Tab.mine, label: 'My delegates and more'),
            LinagoraSegment(value: _Tab.shared, label: 'Delegated to me too'),
          ],
          selected: _Tab.mine,
          onChanged: (_) {},
          expanded: true,
        ),
        width: 280,
      ),
    ),
  );

  expect(tester.takeException(), isNull);
}

Future<void> _tapOther(WidgetTester tester) async {
  final changes = <_Tab>[];
  await tester.pumpWidget(
    _host(_tabs(selected: _Tab.mine, onChanged: changes.add)),
  );

  await tester.tap(_segment(_Tab.shared));

  expect(changes, [_Tab.shared]);
}

Future<void> _tapSelected(WidgetTester tester) async {
  final changes = <_Tab>[];
  await tester.pumpWidget(
    _host(_tabs(selected: _Tab.mine, onChanged: changes.add)),
  );

  await tester.tap(_segment(_Tab.mine));

  expect(changes, isEmpty);
}

Future<void> _tapNoRing(WidgetTester tester) async {
  await tester.pumpWidget(_host(_tabs(selected: _Tab.mine)));

  await tester.tap(_segment(_Tab.shared));
  await tester.pump();

  expect(_segmentChrome(tester, _Tab.shared).foregroundDecoration, isNull);
  expect(_segmentChrome(tester, _Tab.mine).foregroundDecoration, isNull);
}

Future<void> _focusRing(WidgetTester tester) async {
  await _pressKeys(tester, const []);

  final selected = _segmentChrome(tester, _Tab.shared);
  expect(
    selected.foregroundDecoration,
    BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: LinagoraSegmentedTabsStyle.material().focusColor,
        width: LinagoraSegmentedTabsStyle.material().focusWidth,
      ),
    ),
  );
  expect(_segmentChrome(tester, _Tab.mine).foregroundDecoration, isNull);

  // Focus ring is painted in foregroundDecoration, so layout size is stable.
  final focusedSize = tester.getSize(_segment(_Tab.shared));
  expect(focusedSize, const Size(160, 32));
}

Future<void> _arrows(WidgetTester tester) async {
  final changes = await _pressKeys(tester, const [
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowLeft,
  ]);

  expect(changes, [_Tab.archived, _Tab.shared]);
}

Future<void> _rtlArrows(WidgetTester tester) async {
  final changes = await _pressKeys(tester, const [
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowLeft,
  ], textDirection: TextDirection.rtl);

  expect(changes, [_Tab.mine, _Tab.shared]);
}

Future<void> _homeEnd(WidgetTester tester) async {
  final changes = await _pressKeys(tester, const [
    LogicalKeyboardKey.end,
    LogicalKeyboardKey.home,
  ]);

  expect(changes, [_Tab.archived, _Tab.mine]);
}

Future<void> _staysAtEnd(WidgetTester tester) async {
  final changes = await _pressKeys(tester, const [
    LogicalKeyboardKey.arrowRight,
  ], selected: _Tab.archived);

  expect(changes, isEmpty);
}

Future<void> _staysAtStart(WidgetTester tester) async {
  final changes = await _pressKeys(tester, const [
    LogicalKeyboardKey.arrowLeft,
  ], selected: _Tab.mine);

  expect(changes, isEmpty);
}

Future<void> _tapThenArrow(WidgetTester tester) async {
  final changes = <_Tab>[];
  var selected = _Tab.mine;
  await tester.pumpWidget(
    _host(
      StatefulBuilder(
        builder: (context, setState) {
          return LinagoraSegmentedTabs<_Tab>(
            segments: const [
              ..._segments,
              LinagoraSegment(value: _Tab.archived, label: 'Archived'),
            ],
            selected: selected,
            onChanged: (value) {
              changes.add(value);
              setState(() => selected = value);
            },
          );
        },
      ),
    ),
  );

  await tester.tap(_segment(_Tab.shared));
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();

  expect(changes, [_Tab.shared, _Tab.archived]);
}

Future<void> _customHeight(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _tabs(
        selected: _Tab.mine,
        style: LinagoraSegmentedTabsStyle.material().copyWith(height: 40),
      ),
    ),
  );

  expect(tester.getSize(find.byType(LinagoraSegmentedTabs<_Tab>)).height, 40);
}

Future<void> _ignoresOtherKeys(WidgetTester tester) async {
  final changes = await _pressKeys(tester, const [LogicalKeyboardKey.keyA]);

  expect(changes, isEmpty);
}

Future<void> _semantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(_host(_tabs(selected: _Tab.mine)));

  expect(
    tester.getSemantics(_segment(_Tab.mine)),
    matchesSemantics(
      label: 'My delegates',
      isButton: true,
      hasSelectedState: true,
      isSelected: true,
      isInMutuallyExclusiveGroup: true,
      hasTapAction: true,
    ),
  );
  expect(
    tester.getSemantics(_segment(_Tab.shared)),
    matchesSemantics(
      label: 'Delegated to me',
      isButton: true,
      hasSelectedState: true,
      isSelected: false,
      isInMutuallyExclusiveGroup: true,
      hasTapAction: true,
    ),
  );
  handle.dispose();
}

Future<void> _focusedKeepsName(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(_host(_tabs(selected: _Tab.mine)));
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();

  expect(
    tester.getSemantics(_segment(_Tab.mine)),
    matchesSemantics(
      label: 'My delegates',
      isButton: true,
      isFocusable: true,
      hasSelectedState: true,
      isSelected: true,
      isFocused: true,
      isInMutuallyExclusiveGroup: true,
      hasTapAction: true,
    ),
  );
  handle.dispose();
}

void _rejectsOneSegment() {
  expect(
    () => LinagoraSegmentedTabs<_Tab>(
      segments: const [
        LinagoraSegment(value: _Tab.mine, label: 'My delegates'),
      ],
      selected: _Tab.mine,
      onChanged: (_) {},
    ),
    throwsAssertionError,
  );
}

void _rejectsUnknownSelected() {
  expect(
    () => LinagoraSegmentedTabs<_Tab>(
      segments: _segments,
      selected: _Tab.archived,
      onChanged: (_) {},
    ),
    throwsAssertionError,
  );
}

void _rejectsRepeatedValue() {
  expect(
    () => LinagoraSegmentedTabs<int>(
      segments: const [
        LinagoraSegment(value: 1, label: 'One'),
        LinagoraSegment(value: 1, label: 'Also one'),
      ],
      selected: 1,
      onChanged: (_) {},
    ),
    throwsAssertionError,
  );
}

void _rejectsEqualWithoutHashCode() {
  expect(
    () => LinagoraSegmentedTabs<_Bad>(
      segments: [
        LinagoraSegment(value: _Bad(1), label: 'One'),
        LinagoraSegment(value: _Bad(1), label: 'Also one'),
      ],
      selected: _Bad(1),
      onChanged: (_) {},
    ),
    throwsAssertionError,
  );
}

void _keysByEquality() {
  expect(
    LinagoraSegmentedTabs.segmentKey(const _Id(1)) ==
        LinagoraSegmentedTabs.segmentKey(const _Id(2)),
    isFalse,
  );
  expect(
    LinagoraSegmentedTabs.segmentKey(const _Id(1)),
    LinagoraSegmentedTabs.segmentKey(const _Id(1)),
  );
}

class _Id {
  const _Id(this.id);

  final int id;

  @override
  bool operator ==(Object other) => other is _Id && other.id == id;

  @override
  int get hashCode => id;
}

/// Overrides [==] without [hashCode], so a [Set] would miss the duplicate.
class _Bad {
  _Bad(this.id);

  final int id;

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => other is _Bad && other.id == id;
}

Widget _tabs({
  required _Tab selected,
  bool expanded = false,
  ValueChanged<_Tab>? onChanged,
  List<LinagoraSegment<_Tab>> segments = _segments,
  LinagoraSegmentedTabsStyle? style,
}) {
  return LinagoraSegmentedTabs<_Tab>(
    segments: segments,
    selected: selected,
    expanded: expanded,
    onChanged: onChanged ?? (_) {},
    style: style,
  );
}

Future<List<_Tab>> _pressKeys(
  WidgetTester tester,
  List<LogicalKeyboardKey> keys, {
  _Tab selected = _Tab.shared,
  TextDirection textDirection = TextDirection.ltr,
}) async {
  final changes = <_Tab>[];
  var current = selected;
  await tester.pumpWidget(
    _host(
      StatefulBuilder(
        builder: (context, setState) {
          return LinagoraSegmentedTabs<_Tab>(
            segments: const [
              ..._segments,
              LinagoraSegment(value: _Tab.archived, label: 'Archived'),
            ],
            selected: current,
            onChanged: (value) {
              changes.add(value);
              setState(() => current = value);
            },
          );
        },
      ),
      textDirection: textDirection,
    ),
  );
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  for (final key in keys) {
    await tester.sendKeyEvent(key);
    await tester.pump();
  }
  return changes;
}

Widget _host(
  Widget child, {
  TextDirection textDirection = TextDirection.ltr,
  double width = 800,
}) => MaterialApp(
  home: Directionality(
    textDirection: textDirection,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          child: Align(child: child),
        ),
      ),
    ),
  ),
);

Finder _segment(_Tab tab) => find.byKey(LinagoraSegmentedTabs.segmentKey(tab));

BoxDecoration _segmentDecoration(WidgetTester tester, _Tab tab) =>
    _segmentChrome(tester, tab).decoration!;

({BoxDecoration? decoration, Decoration? foregroundDecoration}) _segmentChrome(
  WidgetTester tester,
  _Tab tab,
) {
  final container = tester.widget<AnimatedContainer>(
    find.descendant(
      of: _segment(tab),
      matching: find.byType(AnimatedContainer),
    ),
  );
  return (
    decoration: container.decoration as BoxDecoration?,
    foregroundDecoration: container.foregroundDecoration,
  );
}

Color? _labelColor(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style?.color;

Color? _trackColor(WidgetTester tester) {
  final track = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(LinagoraSegmentedTabs<_Tab>),
          matching: find.byType(Container),
        )
        .first,
  );
  return (track.decoration! as BoxDecoration).color;
}
