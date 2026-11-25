import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/reaction/reaction_picker.dart';

void main() {
  Future<void> pumpPicker(WidgetTester tester, String? reacted) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ReactionsPicker(myEmojiReacted: reacted)),
        ),
      );

  Color? backgroundOf(WidgetTester tester, String emoji) {
    final box = tester.widget<Container>(
      find
          .ancestor(of: find.text(emoji), matching: find.byType(Container))
          .first,
    );
    return (box.decoration as BoxDecoration?)?.color;
  }

  testWidgets('tints and selects my reaction only', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpPicker(tester, '👍');

    expect(
      backgroundOf(tester, '👍'),
      LinagoraSysColors.material().primaryContainer,
    );
    expect(backgroundOf(tester, '😂'), isNull);
    expect(
      tester.getSemantics(find.bySemanticsLabel('👍')),
      containsSemantics(isButton: true, isSelected: true, hasTapAction: true),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('😂')),
      containsSemantics(isButton: true, isSelected: false),
    );
    semantics.dispose();
  });

  testWidgets('matches my reaction spelled with U+FE0F', (tester) async {
    await pumpPicker(tester, '👍\u{FE0F}');

    expect(
      backgroundOf(tester, '👍'),
      LinagoraSysColors.material().primaryContainer,
    );
  });

  testWidgets('tints nothing without my reaction', (tester) async {
    await pumpPicker(tester, null);

    expect(backgroundOf(tester, '👍'), isNull);
  });
}
