import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/chat/bubble_with_reactions.dart';

void main() {
  const bubbleKey = Key('bubble');
  const reactionsKey = Key('reactions');

  Future<void> pump(
    WidgetTester tester, {
    required double bubbleWidth,
    required double reactionsWidth,
    required bool isBubbleAlignedToEnd,
    TextDirection textDirection = TextDirection.ltr,
    VoidCallback? onReactionsTap,
  }) {
    return tester.pumpWidget(
      Directionality(
        textDirection: textDirection,
        child: Align(
          alignment: Alignment.topLeft,
          child: BubbleWithReactions(
            isBubbleAlignedToEnd: isBubbleAlignedToEnd,
            bubble: SizedBox(key: bubbleKey, width: bubbleWidth, height: 60),
            reactions: GestureDetector(
              key: reactionsKey,
              behavior: HitTestBehavior.opaque,
              onTap: onReactionsTap,
              child: SizedBox(width: reactionsWidth, height: 28),
            ),
          ),
        ),
      ),
    );
  }

  Rect rectOf(WidgetTester tester, Key key) => tester.getRect(find.byKey(key));

  testWidgets('reactions narrower than the bubble sit 8px after its start', (
    tester,
  ) async {
    for (final isBubbleAlignedToEnd in [false, true]) {
      await pump(
        tester,
        bubbleWidth: 200,
        reactionsWidth: 100,
        isBubbleAlignedToEnd: isBubbleAlignedToEnd,
      );

      expect(tester.getSize(find.byType(BubbleWithReactions)).width, 200);
      expect(rectOf(tester, bubbleKey).left, 0);
      expect(rectOf(tester, reactionsKey).left, 8);
      expect(rectOf(tester, reactionsKey).bottom, 60);
    }
  });

  testWidgets('wider reactions extend past the end of a start-aligned bubble', (
    tester,
  ) async {
    await pump(
      tester,
      bubbleWidth: 60,
      reactionsWidth: 150,
      isBubbleAlignedToEnd: false,
    );

    expect(tester.getSize(find.byType(BubbleWithReactions)).width, 158);
    expect(rectOf(tester, bubbleKey).left, 0);
    expect(rectOf(tester, reactionsKey).left, 8);
  });

  testWidgets(
    'wider reactions extend past the start of an end-aligned bubble',
    (tester) async {
      await pump(
        tester,
        bubbleWidth: 60,
        reactionsWidth: 150,
        isBubbleAlignedToEnd: true,
      );

      expect(rectOf(tester, bubbleKey).right, 158);
      expect(rectOf(tester, reactionsKey).right, 158);
    },
  );

  testWidgets('layout is mirrored in RTL', (tester) async {
    await pump(
      tester,
      bubbleWidth: 60,
      reactionsWidth: 150,
      isBubbleAlignedToEnd: false,
      textDirection: TextDirection.rtl,
    );

    expect(rectOf(tester, bubbleKey).right, 158);
    expect(rectOf(tester, reactionsKey).right, 150);
  });

  testWidgets('reactions outside the bubble stay tappable', (tester) async {
    var taps = 0;
    await pump(
      tester,
      bubbleWidth: 60,
      reactionsWidth: 150,
      isBubbleAlignedToEnd: false,
      onReactionsTap: () => taps++,
    );

    await tester.tapAt(const Offset(150, 50));

    expect(taps, 1);
  });
}
