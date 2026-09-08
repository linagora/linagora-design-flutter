import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  for (final treatment in _treatments) {
    testWidgets(treatment.description, treatment.verify);
  }
  testWidgets('prefers an explicit colour over the emphasis', _colourOverride);
  testWidgets(
    'merges a caller style over the resolved treatment',
    _styleMerge,
  );
  testWidgets('renders a link in the link blue at w500', _linkTreatment);
  testWidgets('reports a link tap', _linkTap);
  testWidgets('disables a link with no callback', _linkDisabled);
  testWidgets('reports a tap on an actionable value', _valueTap);
  testWidgets('keeps its treatment while actionable', _valueTapTreatment);
  testWidgets('carries emphasis into a rich span', _richSpanEmphasis);
  test('keeps the link and button blues distinct', _linkAndButtonBluesDiffer);
}

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

TextStyle _styleOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

/// One expected text treatment, verified the same way for every emphasis.
class _Treatment {
  final String description;
  final Widget widget;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double letterSpacing;
  final Color color;

  const _Treatment({
    required this.description,
    required this.widget,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.height,
    required this.letterSpacing,
    required this.color,
  });

  Future<void> verify(WidgetTester tester) async {
    await tester.pumpWidget(_host(widget));

    final style = _styleOf(tester, text);
    expect(style.fontSize, fontSize);
    expect(style.fontWeight, fontWeight);
    expect(style.height, height);
    expect(style.letterSpacing, letterSpacing);
    expect(style.color, color);
  }
}

const _treatments = <_Treatment>[
  _Treatment(
    description: 'paints the label treatment',
    widget: LinagoraEventInfoLabel('When'),
    text: 'When',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: LinagoraEventInfoLabel.lineHeight / 12,
    letterSpacing: 0.5,
    color: LinagoraEventInfoColors.secondary,
  ),
  _Treatment(
    description: 'paints the body treatment',
    widget: LinagoraEventInfoText('Tuesday, Jun 16'),
    text: 'Tuesday, Jun 16',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: LinagoraEventInfoText.lineHeight / 14,
    letterSpacing: 0.25,
    color: LinagoraEventInfoColors.content,
  ),
  _Treatment(
    description: 'bolds strong content without recolouring it',
    widget: LinagoraEventInfoText(
      'Alex Martin',
      emphasis: LinagoraEventInfoEmphasis.strong,
    ),
    text: 'Alex Martin',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: LinagoraEventInfoText.lineHeight / 14,
    letterSpacing: 0.25,
    color: LinagoraEventInfoColors.content,
  ),
  _Treatment(
    description: 'fades muted content to the secondary ink',
    widget: LinagoraEventInfoText(
      'alex.martin@example.invalid',
      emphasis: LinagoraEventInfoEmphasis.muted,
    ),
    text: 'alex.martin@example.invalid',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: LinagoraEventInfoText.lineHeight / 14,
    letterSpacing: 0.25,
    color: LinagoraEventInfoColors.secondary,
  ),
  _Treatment(
    description: 'paints a link value in the link blue at w500',
    widget: LinagoraEventInfoText(
      'https://meet.example.invalid/room',
      emphasis: LinagoraEventInfoEmphasis.link,
    ),
    text: 'https://meet.example.invalid/room',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: LinagoraEventInfoText.lineHeight / 14,
    letterSpacing: 0.25,
    color: LinagoraEventInfoColors.link,
  ),
];

Future<void> _colourOverride(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoText(
        'Cancelled',
        emphasis: LinagoraEventInfoEmphasis.strong,
        color: Color(0xFFFFB300),
      ),
    ),
  );

  expect(_styleOf(tester, 'Cancelled').color, const Color(0xFFFFB300));
  expect(_styleOf(tester, 'Cancelled').fontWeight, FontWeight.w600);
}

Future<void> _styleMerge(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoText(
        'Villa Good Tech',
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    ),
  );

  final style = _styleOf(tester, 'Villa Good Tech');
  expect(style.fontStyle, FontStyle.italic);
  expect(style.fontSize, 14, reason: 'the merge must not drop the treatment');
  expect(style.letterSpacing, 0.25);
}

Future<void> _linkTreatment(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(LinagoraEventInfoLink(label: 'See in Map', onPressed: () {})),
  );

  final button = tester.widget<LinagoraButton>(find.byType(LinagoraButton));
  expect(button.foregroundColor, LinagoraEventInfoColors.link);
  expect(button.padding, EdgeInsets.zero);
  expect(button.minimumHeight, 0);
  expect(button.textStyle?.fontWeight, FontWeight.w500);
  expect(button.textStyle?.fontSize, 14);
  expect(button.textStyle?.color, LinagoraEventInfoColors.link);
}

Future<void> _linkTap(WidgetTester tester) async {
  var taps = 0;
  await tester.pumpWidget(
    _host(
      LinagoraEventInfoLink(
        label: 'See all participants',
        onPressed: () => taps++,
      ),
    ),
  );

  await tester.tap(find.text('See all participants'));
  await tester.pump();

  expect(taps, 1);
}

Future<void> _linkDisabled(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const LinagoraEventInfoLink(label: 'See in Map', onPressed: null)),
  );

  expect(
    tester.widget<LinagoraButton>(find.byType(LinagoraButton)).onPressed,
    isNull,
  );
}

Future<void> _richSpanEmphasis(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEventInfoRichText(
        spans: [
          LinagoraEventInfoRichText.span(
            'Alex Martin',
            emphasis: LinagoraEventInfoEmphasis.strong,
          ),
          LinagoraEventInfoRichText.span(' has invited you in to a meeting'),
        ],
      ),
    ),
  );

  final text = tester.widget<Text>(find.byType(Text));
  final spans = (text.textSpan! as TextSpan).children!.cast<TextSpan>();

  expect(spans.first.style?.fontWeight, FontWeight.w600);
  expect(spans.last.style?.fontWeight, FontWeight.w400);
  expect(spans.last.style?.color, LinagoraEventInfoColors.content);
}

void _linkAndButtonBluesDiffer() {
  expect(
    LinagoraEventInfoColors.link,
    isNot(LinagoraEventInfoColors.buttonLabel),
    reason: 'inline links and button labels use different blues',
  );
}

Future<void> _valueTap(WidgetTester tester) async {
  var taps = 0;

  await tester.pumpWidget(
    _host(
      LinagoraEventInfoText(
        'alex.martin@example.invalid',
        emphasis: LinagoraEventInfoEmphasis.muted,
        onTap: () => taps++,
      ),
    ),
  );

  await tester.tap(find.text('alex.martin@example.invalid'));

  expect(taps, 1);
}

Future<void> _valueTapTreatment(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraEventInfoText(
        'Alex Martin',
        emphasis: LinagoraEventInfoEmphasis.strong,
        onTap: () {},
      ),
    ),
  );

  final style = _styleOf(tester, 'Alex Martin');

  expect(style.fontWeight, FontWeight.w600);
  expect(
    style.color,
    LinagoraEventInfoColors.content,
    reason: 'an actionable value keeps the emphasis it was given',
  );
}
