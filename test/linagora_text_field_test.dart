import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets('autofocus requests focus after first pump', (tester) async {
    final focusNode = FocusNode();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LinagoraTextField(
            label: 'Label',
            autofocus: true,
            focusNode: focusNode,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('onSubmitted receives the typed value on keyboard action', (
    tester,
  ) async {
    String? submittedValue;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LinagoraTextField(
            label: 'Label',
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => submittedValue = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'recovery-key');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(submittedValue, 'recovery-key');
  });

  testWidgets('textInputAction forwards to the inner TextField', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraTextField(
            label: 'Label',
            textInputAction: TextInputAction.go,
          ),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.textInputAction, TextInputAction.go);
  });

  testWidgets(
    'without the new params behavior is unchanged (regression guard)',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LinagoraTextField(label: 'Label')),
        ),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isFalse);
      expect(textField.textInputAction, isNull);
      expect(textField.focusNode, isNull);
      expect(textField.keyboardType, TextInputType.text);
      expect(tester.takeException(), isNull);
    },
  );
}
