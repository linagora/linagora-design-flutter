import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  const illustrationKey = Key('illustration');

  Widget build({String? description, bool compact = false}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LinagoraEmptyState(
            illustration: const SizedBox.expand(key: illustrationKey),
            title: 'Nothing to show',
            description: description,
            compact: compact,
          ),
        ),
      ),
    );
  }

  Size cardSize(WidgetTester tester) =>
      tester.getSize(find.byType(LinagoraEmptyState));

  testWidgets('shows the title and the description', (tester) async {
    await tester.pumpWidget(build(description: 'This content is hidden.'));

    expect(find.text('Nothing to show'), findsOneWidget);
    expect(find.text('This content is hidden.'), findsOneWidget);
  });

  testWidgets('is shorter without description', (tester) async {
    await tester.pumpWidget(build(description: 'This content is hidden.'));
    final height = cardSize(tester).height;

    await tester.pumpWidget(build());
    expect(cardSize(tester).height, lessThan(height));
  });

  testWidgets('default variant is 384 wide with a 180 illustration', (
    tester,
  ) async {
    await tester.pumpWidget(build());

    expect(cardSize(tester).width, 384);
    expect(tester.getSize(find.byKey(illustrationKey)), const Size(180, 180));
  });

  testWidgets('compact variant is 330 wide with a 140 illustration', (
    tester,
  ) async {
    await tester.pumpWidget(build(compact: true));

    expect(cardSize(tester).width, 330);
    expect(tester.getSize(find.byKey(illustrationKey)), const Size(140, 140));
  });

  testWidgets('shrinks to a narrow parent without overflowing', (tester) async {
    tester.view.physicalSize = const Size(280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      build(description: 'This content is hidden by the administrator.'),
    );

    expect(cardSize(tester).width, 280);
    expect(tester.takeException(), isNull);
  });
}
