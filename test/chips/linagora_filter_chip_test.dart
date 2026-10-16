import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget build({required bool selected, ValueChanged<bool>? onSelected}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LinagoraFilterChip(
            label: 'External',
            selected: selected,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }

  RawChip rawChip(WidgetTester tester) =>
      tester.widget<RawChip>(find.byType(RawChip));

  testWidgets('selected chip is filled and has no outline', (tester) async {
    await tester.pumpWidget(build(selected: true, onSelected: (_) {}));
    final chip = rawChip(tester);
    const states = {WidgetState.selected};

    expect(
      chip.color?.resolve(states),
      LinagoraSysColors.material().secondaryContainer,
    );
    expect(
      (chip.side as WidgetStateBorderSide).resolve(states)?.color,
      Colors.transparent,
    );
  });

  testWidgets('has the same size whether selected or not', (tester) async {
    await tester.pumpWidget(build(selected: false, onSelected: (_) {}));
    final unselectedHeight = tester.getSize(find.byType(RawChip)).height;
    final labelLeft = tester.getTopLeft(find.text('External')).dx;
    final chipLeft = tester.getTopLeft(find.byType(RawChip)).dx;

    await tester.pumpWidget(build(selected: true, onSelected: (_) {}));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(RawChip)).height, unselectedHeight);
    expect(labelLeft - chipLeft, 16);
  });

  testWidgets('unselected chip is outlined and not filled', (tester) async {
    await tester.pumpWidget(build(selected: false, onSelected: (_) {}));
    final chip = rawChip(tester);

    expect(chip.color?.resolve({}), Colors.transparent);
    expect(
      (chip.side as WidgetStateBorderSide).resolve({})?.color,
      LinagoraSysColors.material().outline,
    );
  });

  testWidgets('unselected chip lets its background show through', (
    tester,
  ) async {
    await tester.pumpWidget(build(selected: false, onSelected: (_) {}));

    expect(
      Theme.of(tester.element(find.byType(RawChip))).canvasColor,
      Colors.transparent,
    );
  });

  testWidgets('chip is 32 high with an 8 radius', (tester) async {
    await tester.pumpWidget(build(selected: true, onSelected: (_) {}));

    expect(
      rawChip(tester).shape,
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
    final material = find.descendant(
      of: find.byType(RawChip),
      matching: find.byType(Material),
    );
    expect(tester.getSize(material.first).height, 32);
  });

  testWidgets('check mark does not grow with the chip', (tester) async {
    await tester.pumpWidget(build(selected: true, onSelected: (_) {}));
    await tester.pumpAndSettle();
    final chipLeft = tester.getTopLeft(find.byType(RawChip)).dx;
    final labelLeft = tester.getTopLeft(find.text('External')).dx;

    // 8 before the check mark, 20 for its box and 8 before the label.
    expect(labelLeft - chipLeft, 36);
  });

  testWidgets('tap reports the toggled value', (tester) async {
    bool? value;
    await tester.pumpWidget(
      build(selected: false, onSelected: (selected) => value = selected),
    );
    await tester.tap(find.text('External'));

    expect(value, isTrue);
  });

  testWidgets('is disabled without onSelected', (tester) async {
    await tester.pumpWidget(build(selected: false));

    expect(rawChip(tester).isEnabled, isFalse);
  });
}
