import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  for (final treatment in _treatments) {
    testWidgets(treatment.description, treatment.verify);
  }
  testWidgets('honours label presentation overrides', _labelOverrides);
  testWidgets('prefers an explicit colour over the emphasis', _colourOverride);
  testWidgets(
    'merges a caller style over the resolved treatment',
    _styleMerge,
  );
  testWidgets('renders a link in the link blue at w500', _linkTreatment);
  testWidgets('reports a link tap', _linkTap);
  testWidgets('disables a link with no callback', _linkDisabled);
  testWidgets('forwards custom link presentation', _customLinkPresentation);
  testWidgets('reports a tap on an actionable value', _valueTap);
  testWidgets('activates an actionable value from the keyboard', _valueKeyboard);
  testWidgets('exposes actionable value semantics', _valueSemantics);
  testWidgets('keeps its treatment while actionable', _valueTapTreatment);
  testWidgets('carries emphasis into a rich span', _richSpanEmphasis);
  testWidgets('forwards rich text presentation', _richTextPresentation);
  test('keeps the link and button blues distinct', _linkAndButtonBluesDiffer);
  test('rejects invalid link icon spacing', _rejectsInvalidLinkIconSpacing);
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
    expect(
      (
        fontSize: style.fontSize,
        fontWeight: style.fontWeight,
        height: style.height,
        letterSpacing: style.letterSpacing,
        color: style.color,
      ),
      (
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      ),
    );
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

Future<void> _labelOverrides(WidgetTester tester) async {
  const customColor = Color(0xFF123456);
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoLabel(
        'A long localised label',
        color: customColor,
        style: TextStyle(fontStyle: FontStyle.italic),
        maxLines: 2,
        overflow: TextOverflow.fade,
      ),
    ),
  );

  final label = tester.widget<Text>(find.text('A long localised label'));
  expect(
    (
      maxLines: label.maxLines,
      overflow: label.overflow,
      color: label.style?.color,
      fontStyle: label.style?.fontStyle,
      fontWeight: label.style?.fontWeight,
    ),
    const (
      maxLines: 2,
      overflow: TextOverflow.fade,
      color: customColor,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
    ),
  );
}

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
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );

  final text = tester.widget<Text>(find.text('Villa Good Tech'));
  final style = text.style!;
  expect(
    (
      fontStyle: style.fontStyle,
      fontSize: style.fontSize,
      letterSpacing: style.letterSpacing,
      maxLines: text.maxLines,
      overflow: text.overflow,
    ),
    const (
      fontStyle: FontStyle.italic,
      fontSize: 14,
      letterSpacing: 0.25,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    reason: 'the merge must not drop the treatment or its overrides',
  );
}

Future<void> _linkTreatment(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(LinagoraEventInfoLink(label: 'See in Map', onPressed: () {})),
  );

  final button = tester.widget<LinagoraButton>(find.byType(LinagoraButton));
  expect(
    (
      foregroundColor: button.foregroundColor,
      padding: button.padding,
      minimumHeight: button.minimumHeight,
      fontWeight: button.textStyle?.fontWeight,
      fontSize: button.textStyle?.fontSize,
      textColor: button.textStyle?.color,
    ),
    const (
      foregroundColor: LinagoraEventInfoColors.link,
      padding: EdgeInsets.zero,
      minimumHeight: 0,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      textColor: LinagoraEventInfoColors.link,
    ),
  );
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
    _host(
      const LinagoraEventInfoLink(
        label: 'See in Map',
        icon: Icons.map,
        onPressed: null,
      ),
    ),
  );

  final wrapper = tester.widget<LinagoraButton>(find.byType(LinagoraButton));
  final button = tester.widget<TextButton>(find.byType(TextButton));
  const disabled = {WidgetState.disabled};

  expect(wrapper.onPressed, isNull);
  expect(
    button.style?.foregroundColor?.resolve(disabled),
    LinagoraEventInfoColors.disabledAction,
  );
  expect(
    tester.widget<Icon>(find.byIcon(Icons.map)).color,
    LinagoraEventInfoColors.disabledAction,
  );
}

Future<void> _customLinkPresentation(WidgetTester tester) async {
  const customIconKey = Key('custom-link-icon');
  const customColor = Color(0xFF654321);
  const disabledColor = Color(0xFF999999);
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoLink(
        label: 'Open venue',
        onPressed: _noop,
        icon: Icons.map,
        iconWidget: SizedBox.square(dimension: 12, key: customIconKey),
        iconSpacing: 9,
        color: customColor,
        disabledColor: disabledColor,
        textStyle: TextStyle(fontStyle: FontStyle.italic),
        tooltip: 'Open the venue map',
      ),
    ),
  );

  final button = tester.widget<LinagoraButton>(find.byType(LinagoraButton));
  expect(
    (
      icon: button.icon,
      iconKey: button.iconWidget?.key,
      iconSpacing: button.iconSpacing,
      foregroundColor: button.foregroundColor,
      disabledForegroundColor: button.disabledForegroundColor,
      fontStyle: button.textStyle?.fontStyle,
      fontWeight: button.textStyle?.fontWeight,
      customIconCount: find.byKey(customIconKey).evaluate().length,
      defaultIconCount: find.byIcon(Icons.map).evaluate().length,
      tooltipCount: find
          .byTooltip('Open the venue map')
          .evaluate()
          .length,
    ),
    const (
      icon: Icons.map,
      iconKey: customIconKey,
      iconSpacing: 9,
      foregroundColor: customColor,
      disabledForegroundColor: disabledColor,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      customIconCount: 1,
      defaultIconCount: 0,
      tooltipCount: 1,
    ),
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
          LinagoraEventInfoRichText.span(
            ' from the design team',
            emphasis: LinagoraEventInfoEmphasis.muted,
            color: Colors.purple,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    ),
  );

  final text = tester.widget<Text>(find.byType(Text));
  final spans = (text.textSpan! as TextSpan).children!.cast<TextSpan>();

  expect(
    (
      firstWeight: spans.first.style?.fontWeight,
      lastWeight: spans.last.style?.fontWeight,
      middleColor: spans[1].style?.color,
      lastColor: spans.last.style?.color,
      lastFontStyle: spans.last.style?.fontStyle,
    ),
    const (
      firstWeight: FontWeight.w600,
      lastWeight: FontWeight.w400,
      middleColor: LinagoraEventInfoColors.content,
      lastColor: Colors.purple,
      lastFontStyle: FontStyle.italic,
    ),
  );
}

Future<void> _richTextPresentation(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraEventInfoRichText(
        spans: [TextSpan(text: 'A long event description')],
        emphasis: LinagoraEventInfoEmphasis.muted,
        style: TextStyle(fontStyle: FontStyle.italic),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    ),
  );

  final text = tester.widget<Text>(find.byType(Text));
  expect(
    (
      maxLines: text.maxLines,
      overflow: text.overflow,
      textAlign: text.textAlign,
      color: text.style?.color,
      fontStyle: text.style?.fontStyle,
    ),
    const (
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      color: LinagoraEventInfoColors.secondary,
      fontStyle: FontStyle.italic,
    ),
  );
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

Future<void> _valueKeyboard(WidgetTester tester) async {
  var activations = 0;

  await tester.pumpWidget(
    _host(
      LinagoraEventInfoText(
        'alex.martin@example.invalid',
        onTap: () => activations++,
      ),
    ),
  );

  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  expect(
    Focus.of(tester.element(find.text('alex.martin@example.invalid'))).hasFocus,
    isTrue,
  );

  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.sendKeyEvent(LogicalKeyboardKey.space);

  expect(activations, 2);
}

Future<void> _valueSemantics(WidgetTester tester) async {
  final semantics = tester.ensureSemantics();
  try {
    await tester.pumpWidget(
      _host(
        LinagoraEventInfoText(
          'alex.martin@example.invalid',
          onTap: () {},
        ),
      ),
    );

    expect(
      tester.getSemantics(
        find.bySemanticsLabel('alex.martin@example.invalid'),
      ),
      matchesSemantics(
        label: 'alex.martin@example.invalid',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );
  } finally {
    semantics.dispose();
  }
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

void _rejectsInvalidLinkIconSpacing() {
  const invalid = [
    -1.0,
    double.nan,
    double.infinity,
    double.negativeInfinity,
  ];

  for (final value in invalid) {
    expect(
      () => LinagoraEventInfoLink(
        label: 'Link',
        onPressed: _noop,
        iconSpacing: value,
      ),
      throwsAssertionError,
      reason: 'Invalid icon spacing $value must be rejected',
    );
  }
}

void _noop() {}
