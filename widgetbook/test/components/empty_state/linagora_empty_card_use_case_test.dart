import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/empty_state/linagora_empty_card_use_case.dart';

void main() {
  testWidgets('default knobs reach the card', _defaultKnobs);
  testWidgets(
    'the text knobs replace the title and drop an empty message',
    _textKnobs,
  );
  testWidgets('the illustration knob removes the icon', _illustrationNone);
  testWidgets('the illustration knob can pick the mail icon', _illustrationMail);
  testWidgets('the action knob removes the button', _actionKnob);
  testWidgets('the border knob drops the outline', _borderKnob);
  testWidgets('the radius knob updates the style', _radiusKnob);
  testWidgets(
    'the background override updates the fill',
    _backgroundOverride,
  );
  testWidgets('a fixed width knob locks the card width', _fixedWidth);
  testWidgets('the dark theme picks the dark style tokens', _darkTheme);
}

Future<void> _defaultKnobs(WidgetTester tester) async {
  await _pump(tester, const {});

  final card = tester.widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard));
  expect(card.title, 'No one has access yet');
  expect(card.message, 'Add someone below to share access to your inbox.');
  expect(card.illustration, isA<SvgPicture>());
  expect(card.action, isNotNull);
  expect(card.bordered, isTrue);
  expect(card.style?.radius, 16);
  expect(card.style?.backgroundColor, Colors.white);
  expect(find.byKey(LinagoraEmptyCard.actionKey), findsOneWidget);
}

Future<void> _textKnobs(WidgetTester tester) async {
  await _pump(tester, const {
    'Title': 'Nothing here',
    'Message': '',
  });

  final card = tester.widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard));
  expect(card.title, 'Nothing here');
  expect(card.message, isNull);
}

Future<void> _illustrationNone(WidgetTester tester) async {
  await _pump(tester, const {'Illustration': 'None'});

  expect(
    tester
        .widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard))
        .illustration,
    isNull,
  );
}

Future<void> _illustrationMail(WidgetTester tester) async {
  await _pump(tester, const {'Illustration': 'Mail'});

  expect(
    tester
        .widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard))
        .illustration,
    isA<SvgPicture>(),
  );
}

Future<void> _actionKnob(WidgetTester tester) async {
  await _pump(tester, const {'Action': 'false'});

  expect(
    tester.widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard)).action,
    isNull,
  );
  expect(find.byKey(LinagoraEmptyCard.actionKey), findsNothing);
}

Future<void> _borderKnob(WidgetTester tester) async {
  await _pump(tester, const {'Border': 'false'});

  expect(
    tester.widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard)).bordered,
    isFalse,
  );
}

Future<void> _radiusKnob(WidgetTester tester) async {
  await _pump(tester, const {'Radius': '8.0'});

  expect(
    tester.widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard)).style?.radius,
    8,
  );
}

Future<void> _backgroundOverride(WidgetTester tester) async {
  await _pump(tester, const {
    'Override background': 'true',
    'Background': 'ff00aa44',
  });

  expect(
    tester
        .widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard))
        .style
        ?.backgroundColor,
    const Color(0xFF00AA44),
  );
}

Future<void> _fixedWidth(WidgetTester tester) async {
  await _pump(tester, const {
    'Match parent width': 'false',
    'Width': '320.0',
  });

  final card = tester.widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard));
  expect(card.width, 320);
  expect(tester.getSize(find.byType(LinagoraEmptyCard)).width, 320);
}

Future<void> _darkTheme(WidgetTester tester) async {
  await _pump(tester, const {}, brightness: Brightness.dark);

  final style =
      tester.widget<LinagoraEmptyCard>(find.byType(LinagoraEmptyCard)).style!;
  expect(style.backgroundColor, LinagoraEmptyCardStyle.dark().backgroundColor);
  expect(style.radius, LinagoraEmptyCardStyle.dark().radius);
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, String> knobs, {
  Brightness brightness = Brightness.light,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: WidgetbookScope(
        state: WidgetbookState(
          root: WidgetbookRoot(children: const []),
          queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
        ),
        child: const Scaffold(body: Builder(builder: linagoraEmptyCardUseCase)),
      ),
    ),
  );
}
