import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _backgroundColor = Color(0xFF123456);
const _foregroundColor = Color(0xFF654321);

void main() {
  testWidgets(
    'paints the style badge background in a stadium',
    _styleBackgroundInStadium,
  );
  testWidgets(
    'lets backgroundColor beat the style',
    _colorOverrideWins(
      badge: LinagoraSidebarBadge(
        label: '5',
        backgroundColor: _backgroundColor,
        style: LinagoraSidebarStyle.dark(),
      ),
      expectedColor: _backgroundColor,
      actualColor: _badgeBackground,
    ),
  );
  testWidgets(
    'lets foregroundColor beat the style',
    _colorOverrideWins(
      badge: LinagoraSidebarBadge(
        label: '5',
        foregroundColor: _foregroundColor,
        style: LinagoraSidebarStyle.dark(),
      ),
      expectedColor: _foregroundColor,
      actualColor: _badgeForeground,
    ),
  );
  testWidgets('resolves dark badge tokens from the ambient theme', _darkTokens);
  testWidgets('lets an injected style beat the ambient theme', _injectedStyleWins);
  testWidgets('sizes the pill 16px tall, not a block', _pillHeight);
  testWidgets('caps the width at the widest label', _capsWidth);
  testWidgets(
    'keeps a single digit at least as wide as the pill is tall',
    _singleDigitMinimumWidth,
  );
  testWidgets(
    'renders widestLabel at exactly the cap, unellipsised',
    _widestLabelFitsExactly,
  );
  testWidgets('centres a single digit in the pill', _centresSingleDigit);
  testWidgets('grows the cap with the text scaler', _capGrowsWithTextScaler);
  testWidgets(
    'measures the cap in RTL without overflowing',
    _rtlCapDoesNotOverflow,
  );
}

Future<void> _styleBackgroundInStadium(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const _BadgeHarness(badge: LinagoraSidebarBadge(label: '5')),
  );

  final decoration = _badgeDecoration(tester);
  expect(decoration.color, LinagoraSidebarStyle.light().badgeBackground);
  expect(decoration.shape, isA<StadiumBorder>());
}

Future<void> _darkTokens(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const _BadgeHarness(
      badge: LinagoraSidebarBadge(label: '5'),
      brightness: Brightness.dark,
    ),
  );

  final style = LinagoraSidebarStyle.dark();
  expect(_badgeDecoration(tester).color, style.badgeBackground);
  expect(_badgeText(tester).style?.color, style.badgeForeground);
}

Future<void> _injectedStyleWins(WidgetTester tester) async {
  final light = LinagoraSidebarStyle.light();
  final dark = LinagoraSidebarStyle.dark();
  await _pumpBadge(
    tester,
    _BadgeHarness(
      badge: LinagoraSidebarBadge(label: '5', style: light),
      brightness: Brightness.dark,
    ),
  );

  expect(light.badgeBackground, isNot(dark.badgeBackground));
  expect(light.badgeForeground, isNot(dark.badgeForeground));
  expect(_badgeDecoration(tester).color, light.badgeBackground);
  expect(_badgeText(tester).style?.color, light.badgeForeground);
}

Future<void> _pillHeight(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const _BadgeHarness(
      badge: LinagoraSidebarBadge(label: LinagoraSidebarBadge.widestLabel),
      parentHeight: 36,
    ),
  );

  final size = _badgeSize(tester);
  expect(size.height, LinagoraSidebarStyle.light().badgeHeight);
  expect(size.height, lessThan(36));
}

Future<void> _capsWidth(WidgetTester tester) async {
  final cap = await _badgeWidth(tester, LinagoraSidebarBadge.widestLabel);
  final overlong = await _badgeWidth(tester, '12345678901234567890');

  expect(overlong, cap);
  expect(_badgeText(tester).overflow, TextOverflow.ellipsis);
}

Future<void> _singleDigitMinimumWidth(WidgetTester tester) async {
  final width = await _badgeWidth(tester, '5');

  expect(width, greaterThanOrEqualTo(LinagoraSidebarStyle.light().badgeHeight));
}

Future<void> _widestLabelFitsExactly(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const _BadgeHarness(
      badge: LinagoraSidebarBadge(label: LinagoraSidebarBadge.widestLabel),
    ),
  );

  final style = LinagoraSidebarStyle.light();
  final expectedWidth = _textWidth(tester) + style.badgeHorizontalPadding * 2;
  final paragraph = tester.renderObject<RenderParagraph>(
    find.text(LinagoraSidebarBadge.widestLabel),
  );

  expect(_badgeSize(tester).width, closeTo(expectedWidth, 0.01));
  expect(paragraph.didExceedMaxLines, isFalse);
}

Future<void> _centresSingleDigit(WidgetTester tester) async {
  await _pumpBadge(
    tester,
    const _BadgeHarness(badge: LinagoraSidebarBadge(label: '5')),
  );

  final badge = tester.getRect(find.byType(LinagoraSidebarBadge));
  final digit = tester.getRect(find.text('5'));
  expect(digit.center.dx, closeTo(badge.center.dx, 0.01));
}

Future<void> _capGrowsWithTextScaler(WidgetTester tester) async {
  final normal = await _badgeWidth(tester, LinagoraSidebarBadge.widestLabel);
  final scaled = await _badgeWidth(
    tester,
    LinagoraSidebarBadge.widestLabel,
    textScaler: const TextScaler.linear(2),
  );

  expect(scaled, greaterThan(normal));
}

Future<void> _rtlCapDoesNotOverflow(WidgetTester tester) async {
  final cap = await _badgeWidth(
    tester,
    LinagoraSidebarBadge.widestLabel,
    textDirection: TextDirection.rtl,
  );
  final overlong = await _badgeWidth(
    tester,
    '12345678901234567890',
    textDirection: TextDirection.rtl,
  );

  expect(overlong, cap);
  expect(tester.takeException(), isNull);
}

Future<void> _pumpBadge(
  WidgetTester tester,
  _BadgeHarness harness,
) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: harness.brightness),
      home: Builder(
        builder: (BuildContext context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: harness.textScaler),
          child: Directionality(
            textDirection: harness.textDirection,
            child: Scaffold(
              body: SizedBox(
                height: harness.parentHeight,
                child: Center(child: harness.badge),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<double> _badgeWidth(
  WidgetTester tester,
  String label, {
  TextDirection textDirection = TextDirection.ltr,
  TextScaler? textScaler,
}) async {
  await _pumpBadge(
    tester,
    _BadgeHarness(
      badge: LinagoraSidebarBadge(label: label),
      textDirection: textDirection,
      textScaler: textScaler,
    ),
  );
  return _badgeSize(tester).width;
}

ShapeDecoration _badgeDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(LinagoraSidebarBadge),
      matching: find.byType(Container),
    ),
  );
  return container.decoration! as ShapeDecoration;
}

Text _badgeText(WidgetTester tester) =>
    tester.widget<Text>(find.descendant(
      of: find.byType(LinagoraSidebarBadge),
      matching: find.byType(Text),
    ));

Size _badgeSize(WidgetTester tester) =>
    tester.getSize(find.byType(LinagoraSidebarBadge));

Color _badgeBackground(WidgetTester tester) =>
    _badgeDecoration(tester).color!;

Color _badgeForeground(WidgetTester tester) =>
    _badgeText(tester).style!.color!;

Future<void> Function(WidgetTester) _colorOverrideWins({
  required LinagoraSidebarBadge badge,
  required Color expectedColor,
  required Color Function(WidgetTester tester) actualColor,
}) {
  return (tester) async {
    await _pumpBadge(tester, _BadgeHarness(badge: badge));
    expect(actualColor(tester), expectedColor);
  };
}

class _BadgeHarness {
  const _BadgeHarness({
    required this.badge,
    this.brightness = Brightness.light,
    this.textDirection = TextDirection.ltr,
    this.textScaler,
    this.parentHeight,
  });

  final LinagoraSidebarBadge badge;
  final Brightness brightness;
  final TextDirection textDirection;
  final TextScaler? textScaler;
  final double? parentHeight;
}

double _textWidth(WidgetTester tester) {
  final textFinder = find.text(LinagoraSidebarBadge.widestLabel);
  final text = _badgeText(tester);
  final painter = TextPainter(
    text: TextSpan(text: LinagoraSidebarBadge.widestLabel, style: text.style),
    textDirection: Directionality.of(tester.element(textFinder)),
    textScaler: MediaQuery.textScalerOf(tester.element(textFinder)),
    maxLines: 1,
  );
  try {
    painter.layout();
    return painter.width;
  } finally {
    painter.dispose();
  }
}
