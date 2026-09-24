import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget build({
    required bool selected,
    VoidCallback? onTap,
    bool showDivider = true,
    bool enabled = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LinagoraRadioItem(
          title: 'Public',
          selected: selected,
          onTap: onTap,
          showDivider: showDivider,
          enabled: enabled,
        ),
      ),
    );
  }

  testWidgets('shows the check mark only when selected', (tester) async {
    await tester.pumpWidget(build(selected: true, onTap: () {}));
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.pumpWidget(build(selected: false, onTap: () {}));
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('keeps the label width whether selected or not', (tester) async {
    await tester.pumpWidget(build(selected: true, onTap: () {}));
    final selectedWidth = tester.getSize(find.byType(Divider)).width;

    await tester.pumpWidget(build(selected: false, onTap: () {}));
    expect(tester.getSize(find.byType(Divider)).width, selectedWidth);
  });

  testWidgets('divider stops before the check mark', (tester) async {
    await tester.pumpWidget(build(selected: true, onTap: () {}));

    expect(
      tester.getTopRight(find.byType(Divider)).dx,
      lessThan(tester.getTopLeft(find.byIcon(Icons.check)).dx),
    );
  });

  testWidgets('hides the divider when showDivider is false', (tester) async {
    await tester.pumpWidget(
      build(selected: false, onTap: () {}, showDivider: false),
    );
    expect(find.byType(Divider), findsNothing);
  });

  testWidgets('tap calls onTap unless disabled', (tester) async {
    var taps = 0;
    await tester.pumpWidget(build(selected: false, onTap: () => taps++));
    await tester.tap(find.text('Public'));
    expect(taps, 1);

    await tester.pumpWidget(
      build(selected: false, onTap: () => taps++, enabled: false),
    );
    await tester.tap(find.text('Public'));
    expect(taps, 1);
  });

  testWidgets('exposes radio semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(build(selected: true, onTap: () {}));

    expect(
      tester.getSemantics(find.text('Public')),
      matchesSemantics(
        label: 'Public',
        hasCheckedState: true,
        isChecked: true,
        isInMutuallyExclusiveGroup: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });
}
