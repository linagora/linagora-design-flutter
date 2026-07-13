import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'banner does not overflow with long action label on narrow width',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: LinagoraBanner(
                message: 'Encrypted messages may be unavailable because '
                    'some of your devices are out of sync',
                actionLabel: 'Verify this device now please',
                onActionPressed: () {},
                onDismiss: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('banner accepts a custom icon widget (svg/png stand-in)',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LinagoraBanner(
            message: 'Custom icon test',
            iconWidget: const FlutterLogo(),
            onDismiss: () {},
            dismissIconWidget: const Icon(Icons.cancel),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(FlutterLogo), findsOneWidget);
  });
}
