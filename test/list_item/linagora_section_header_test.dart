import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget build({String? actionLabel, VoidCallback? onActionTap}) {
    return MaterialApp(
      home: Scaffold(
        body: LinagoraSectionHeader(
          label: 'Results',
          actionLabel: actionLabel,
          onActionTap: onActionTap,
        ),
      ),
    );
  }

  testWidgets('shows the label in upper case', (tester) async {
    await tester.pumpWidget(build());

    expect(find.text('RESULTS'), findsOneWidget);
  });

  testWidgets('has no action without actionLabel', (tester) async {
    await tester.pumpWidget(build());

    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('tap on the action calls onActionTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      build(actionLabel: 'Show more', onActionTap: () => taps++),
    );
    await tester.tap(find.text('Show more'));

    expect(taps, 1);
  });

  testWidgets('is 32 high with or without the action', (tester) async {
    await tester.pumpWidget(build());
    expect(tester.getSize(find.byType(LinagoraSectionHeader)).height, 32);

    await tester.pumpWidget(
      build(actionLabel: 'Show more', onActionTap: () {}),
    );
    expect(tester.getSize(find.byType(LinagoraSectionHeader)).height, 32);
  });

  testWidgets('long label does not overflow', (tester) async {
    tester.view.physicalSize = const Size(200, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LinagoraSectionHeader(
            label: 'Suggested results' * 4,
            actionLabel: 'Show more',
            onActionTap: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
