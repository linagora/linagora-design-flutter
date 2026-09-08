import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets('uses the warning token and exposes its message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LinagoraEventConflictIndicator(
          message: 'Conflicts with another event',
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.error));
    expect(icon.size, LinagoraEventConflictIndicator.defaultSize);
    expect(icon.color, LinagoraSysColors.material().warning);
    expect(find.byTooltip('Conflicts with another event'), findsOneWidget);
  });

  testWidgets('accepts visual overrides', (WidgetTester tester) async {
    const color = Color(0xFF123456);

    await tester.pumpWidget(
      const MaterialApp(
        home: LinagoraEventConflictIndicator(
          message: 'Conflict',
          size: 16,
          color: color,
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.error));
    expect(icon.size, 16);
    expect(icon.color, color);
  });

  test('rejects a non-positive size', () {
    expect(
      () => LinagoraEventConflictIndicator(message: 'Conflict', size: 0),
      throwsAssertionError,
    );
  });
}
