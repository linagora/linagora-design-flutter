import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'does not overflow with long verify label on narrow width',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SessionDeviceListItem(
                deviceName: 'Chat.linagora.com Chrome on Web',
                lastActiveText: 'Last active: 17:41',
                verified: false,
                verifyLabel: 'Verify this device right now please',
                onVerifyPressed: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );
}
