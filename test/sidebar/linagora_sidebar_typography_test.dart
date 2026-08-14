import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_item_test_utils.dart';

/// The row label, shared by mailbox and folder rows.
const _labelSpec = (fontSize: 14.0, lineHeight: 18.4, letterSpacing: 0.25);

/// The badge counter.
const _badgeSpec = (fontSize: 11.0, lineHeight: 16.0, letterSpacing: 0.5);

/// Every row icon is 16 square.
const _iconSize = 16.0;

/// The pill hugs its counter: 4.5px each side, 16px tall, never under 16 wide.
const _badgePadding = 4.5;

/// Primary text, carried at 90%, and the active blue, opaque.
const _textPrimary = Color(0xFF424244);
const _primaryMain = Color(0xFF0A84FF);

typedef _TypeSpec = ({
  double fontSize,
  double lineHeight,
  double letterSpacing,
});

void main() {
  testWidgets('labels a row with body2', _labelFollowsTheSpec);
  testWidgets('labels a badge with M3/label/small', _badgeFollowsTheSpec);
  testWidgets('keeps the trailing text on the badge face', _trailingText);
  testWidgets('keeps the label colour tied to the row state', _labelColour);
  testWidgets('sizes the leading icon 16 square', _iconIsSixteen);
  testWidgets('centres the badge counter in its pill', _badgeIsCentred);
  testWidgets('hugs the badge counter, down to a round minimum', _badgeHugs);
  testWidgets('centres the label against the row icon', _labelIsCentred);
}

Future<void> _labelFollowsTheSpec(WidgetTester tester) async {
  await pumpSidebarItem(tester, const LinagoraSidebarItem(label: 'Inbox'));

  _expectSpec(tester.widget<Text>(find.text('Inbox')).style, _labelSpec);
}

Future<void> _badgeFollowsTheSpec(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', badgeLabel: '999+'),
  );

  _expectSpec(tester.widget<Text>(find.text('999+')).style, _badgeSpec);
}

Future<void> _trailingText(WidgetTester tester) async {
  late DefaultTextStyle inherited;
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      trailing: Builder(
        builder: (context) {
          inherited = DefaultTextStyle.of(context);
          return const Text('Clean');
        },
      ),
    ),
  );

  _expectSpec(inherited.style, _badgeSpec);
  expect(
    inherited.style.color,
    LinagoraSidebarStyle.light().trailingForeground,
  );
  expect(inherited.textHeightBehavior, LinagoraSidebarStyle.middleAligned);
}

Future<void> _labelColour(WidgetTester tester) async {
  final style = LinagoraSidebarStyle.light();

  expect(style.foreground, _textPrimary.withValues(alpha: 0.9));
  // The count is inked from the same token as the label it follows.
  expect(style.badgeForeground, style.foreground);
  expect(style.activeForeground, _primaryMain);

  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', active: true),
  );

  expect(tester.widget<Text>(find.text('Inbox')).style?.color, _primaryMain);
  // The type token carries no colour, so the row is free to set one.
  expect(style.labelTextStyle.color, isNull);
}

Future<void> _iconIsSixteen(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', icon: Icons.inbox_outlined),
  );

  expect(LinagoraSidebarStyle.light().itemIconSize, _iconSize);
  expect(
    tester.getSize(find.byIcon(Icons.inbox_outlined)),
    const Size.square(_iconSize),
  );
}

/// The counter is laid out on its glyphs, not on the taller box its line
/// height would leave around them, and centred across the pill.
///
/// Down the pill it is placed by its ink instead — see
/// `linagora_sidebar_ink_test.dart`, which measures the painted pixels.
Future<void> _badgeIsCentred(WidgetTester tester) async {
  await _pumpBadge(tester, '999+');

  final counter = tester.getRect(find.text('999+'));
  final pill = tester.getRect(find.byType(LinagoraSidebarBadge));

  expect(counter.center.dx, closeTo(pill.center.dx, 0.01));
  expect(pill.contains(counter.topLeft), isTrue);
  expect(pill.contains(counter.bottomRight), isTrue);
  _expectGlyphBox(counter, '999+', _badgeSpec);
}

Future<void> _badgeHugs(WidgetTester tester) async {
  final style = LinagoraSidebarStyle.light();
  await _pumpBadge(tester, '999+');

  final counter = tester.getRect(find.text('999+'));
  final pill = tester.getRect(find.byType(LinagoraSidebarBadge));

  expect(style.badgeHorizontalPadding, _badgePadding);
  expect(pill.height, style.badgeHeight);
  expect(pill.width, closeTo(counter.width + _badgePadding * 2, 0.01));
}

Future<void> _labelIsCentred(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', icon: Icons.inbox_outlined),
  );

  final label = tester.getRect(find.text('Inbox'));
  final icon = tester.getRect(find.byIcon(Icons.inbox_outlined));

  expect(label.center.dy, closeTo(icon.center.dy, 0.01));
  _expectGlyphBox(label, 'Inbox', _labelSpec);
}

/// Standalone, so the pill is proven to lay out its own counter rather than
/// inheriting what a row hands to its trailing slot.
Future<void> _pumpBadge(WidgetTester tester, String label) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(child: LinagoraSidebarBadge(label: label)),
      ),
    ),
  );
}

void _expectSpec(TextStyle? style, _TypeSpec spec) {
  expect(style?.fontSize, spec.fontSize);
  expect(style?.height, spec.lineHeight / spec.fontSize);
  expect(style?.letterSpacing, spec.letterSpacing);
  expect(style?.fontWeight, FontWeight.w500);
}

/// Asserts the text was laid out on its glyphs rather than on its line box,
/// which is taller than them and hangs lower.
void _expectGlyphBox(Rect box, String text, _TypeSpec spec) {
  final glyphs = _glyphHeight(text, spec.fontSize);

  expect(glyphs, lessThan(spec.lineHeight));
  expect(box.height, closeTo(glyphs, 0.01));
}

double _glyphHeight(String text, double fontSize) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );
  try {
    painter.layout();
    final line = painter.computeLineMetrics().single;
    return line.ascent + line.descent;
  } finally {
    painter.dispose();
  }
}
