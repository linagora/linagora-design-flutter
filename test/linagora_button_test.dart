import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets('xs renders a 32px stadium text button', _xsTextButton);
  testWidgets('text variant renders a TextButton', _textVariant);
}

Future<void> _xsTextButton(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Clean',
      variant: LinagoraButtonVariant.text,
      size: LinagoraButtonSize.xs,
      onPressed: _noop,
    ),
  );

  expect(tester.getSize(find.byType(TextButton)).height, 32);

  final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
  expect(
    style.shape?.resolve({}),
    isA<StadiumBorder>(),
  );
  expect(
    style.padding?.resolve({}),
    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  );
}

Future<void> _textVariant(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Clean',
      variant: LinagoraButtonVariant.text,
      onPressed: _noop,
    ),
  );

  expect(find.byType(TextButton), findsOneWidget);
  expect(find.byType(FilledButton), findsNothing);
  expect(find.byType(OutlinedButton), findsNothing);
}

Future<void> _pump(WidgetTester tester, Widget button) {
  return tester.pumpWidget(
    MaterialApp(home: Scaffold(body: Center(child: button))),
  );
}

void _noop() {}
