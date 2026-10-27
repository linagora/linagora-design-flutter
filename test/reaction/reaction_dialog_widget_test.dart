import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/reaction/reaction_dialog_widget.dart';

void main() {
  const messageKey = Key('message');

  Widget dialog() => const ReactionsDialogWidget(
    messageWidget: SizedBox(key: messageKey, height: 80),
    reactionWidget: SizedBox(height: 40),
    contextMenuWidget: SizedBox(height: 200),
  );

  setUp(() => KeyboardVisibilityTesting.setVisibilityForTesting(true));
  tearDown(() => KeyboardVisibilityTesting.setVisibilityForTesting(false));

  testWidgets('lays out inside a scroll view while the keyboard is visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: dialog())),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byKey(messageKey), findsOneWidget);
  });

  testWidgets('fills a bounded height while the keyboard is visible', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: dialog())));

    final column = find.descendant(
      of: find.byType(ReactionsDialogWidget),
      matching: find.byType(Column),
    );
    expect(
      tester.getSize(column).height,
      tester.getSize(find.byType(Scaffold)).height,
    );
  });
}
