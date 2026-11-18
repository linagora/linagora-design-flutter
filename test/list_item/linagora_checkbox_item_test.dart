import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget build({
    required bool value,
    ValueChanged<bool>? onChanged,
    String? subtitle,
    Widget? leading,
    bool showDivider = true,
    bool enabled = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LinagoraCheckboxItem(
          title: 'Work',
          subtitle: subtitle,
          leading: leading,
          value: value,
          onChanged: onChanged,
          showDivider: showDivider,
          enabled: enabled,
        ),
      ),
    );
  }

  Checkbox checkbox(WidgetTester tester) =>
      tester.widget<Checkbox>(find.byType(Checkbox));

  testWidgets('is 57 high with a title and a divider', (tester) async {
    await tester.pumpWidget(build(value: false, onChanged: (_) {}));
    expect(tester.getSize(find.byType(LinagoraCheckboxItem)).height, 57);
  });

  testWidgets('fills the checked box with the primary colour', (tester) async {
    await tester.pumpWidget(build(value: true, onChanged: (_) {}));
    expect(checkbox(tester).value, isTrue);
    expect(
      checkbox(tester).fillColor?.resolve({WidgetState.selected}),
      LinagoraSysColors.material().primary,
    );
  });

  testWidgets('tap toggles the value unless disabled', (tester) async {
    final values = <bool>[];
    await tester.pumpWidget(build(value: false, onChanged: values.add));
    await tester.tap(find.text('Work'));
    expect(values, [true]);

    await tester.pumpWidget(build(value: true, onChanged: values.add));
    await tester.tap(find.byType(Checkbox), warnIfMissed: false);
    expect(values, [true, false]);

    await tester.pumpWidget(
      build(value: false, onChanged: values.add, enabled: false),
    );
    await tester.tap(find.text('Work'));
    expect(values, [true, false]);
    expect(checkbox(tester).onChanged, isNull);
  });

  testWidgets('divider stops before the checkbox', (tester) async {
    await tester.pumpWidget(build(value: true, onChanged: (_) {}));
    expect(
      tester.getTopRight(find.byType(Divider)).dx,
      lessThan(tester.getTopLeft(find.byType(Checkbox)).dx),
    );
  });

  testWidgets('shows the subtitle and leading widget', (tester) async {
    await tester.pumpWidget(
      build(
        value: false,
        onChanged: (_) {},
        subtitle: '3 chats',
        leading: const SizedBox.square(key: ValueKey('leading'), dimension: 40),
        showDivider: false,
      ),
    );
    expect(find.text('3 chats'), findsOneWidget);
    expect(
      tester.getTopRight(find.byKey(const ValueKey('leading'))).dx,
      lessThan(tester.getTopLeft(find.text('Work')).dx),
    );
    expect(find.byType(Divider), findsNothing);
  });

  testWidgets('exposes checkbox semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(build(value: true, onChanged: (_) {}));

    expect(
      tester.getSemantics(find.text('Work')),
      matchesSemantics(
        label: 'Work',
        hasCheckedState: true,
        isChecked: true,
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
