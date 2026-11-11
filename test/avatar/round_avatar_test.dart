import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('RoundAvatar', () {
    testWidgets('keeps the default two characters', _keepsDefaultTwo);
    testWidgets('truncates the text to maxChar', _truncatesToMaxChar);
    testWidgets('keeps a multi-code-unit character whole', _keepsGrapheme);
  });
}

Future<void> _keepsDefaultTwo(WidgetTester tester) async {
  await tester.pumpWidget(_host(const RoundAvatar(text: 'NHK')));

  expect(find.text('NH'), findsOneWidget);
}

Future<void> _truncatesToMaxChar(WidgetTester tester) async {
  await tester.pumpWidget(_host(const RoundAvatar(text: 'NH', maxChar: 1)));

  expect(find.text('N'), findsOneWidget);
  expect(find.text('NH'), findsNothing);
}

Future<void> _keepsGrapheme(WidgetTester tester) async {
  await tester.pumpWidget(_host(const RoundAvatar(text: '👩‍💻D', maxChar: 1)));

  expect(find.text('👩‍💻'), findsOneWidget);
}
