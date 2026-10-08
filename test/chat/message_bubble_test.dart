import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  const contentKey = Key('content');
  const reactionsKey = Key('reactions');
  const content = SizedBox(key: contentKey, width: 40, height: 40);
  const reactions = SizedBox(key: reactionsKey, width: 150, height: 28);

  Future<void> pump(WidgetTester tester, Widget bubble) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(alignment: Alignment.topLeft, child: bubble),
        ),
      ),
    );
  }

  Rect rectOf(WidgetTester tester, Key key) => tester.getRect(find.byKey(key));

  testWidgets('without reactions the bubble wraps its padded content', (
    tester,
  ) async {
    await pump(tester, const MessageBubble(child: content));

    expect(tester.getSize(find.byType(MessageBubble)), const Size(64, 48));
  });

  testWidgets('reactions overlap the bottom of the bubble and extend past it', (
    tester,
  ) async {
    await pump(
      tester,
      const MessageBubble(reactions: reactions, child: content),
    );

    final bubble = tester.getSize(find.byType(MessageBubble));
    expect(bubble, const Size(158, 48 + kMessageReactionsOverlayHeight));
    expect(rectOf(tester, reactionsKey).left, 8);
    expect(rectOf(tester, reactionsKey).bottom, bubble.height);
    expect(rectOf(tester, contentKey).left, 12);
  });

  testWidgets('isAlignedToEnd keeps the bubble at the end of wider reactions', (
    tester,
  ) async {
    await pump(
      tester,
      const MessageBubble(
        isAlignedToEnd: true,
        reactions: reactions,
        child: content,
      ),
    );

    expect(rectOf(tester, contentKey).right, 158 - 12);
    expect(rectOf(tester, reactionsKey).right, 158);
  });

  testWidgets('plain has no decoration nor padding', (tester) async {
    await pump(
      tester,
      const MessageBubble.plain(reactions: reactions, child: content),
    );

    expect(rectOf(tester, contentKey).topLeft, Offset.zero);
    expect(
      tester.getSize(find.byType(MessageBubble)).height,
      40 + kMessageReactionsOverlayHeight,
    );
    expect(find.byType(DecoratedBox), findsNothing);
  });

  testWidgets('a reactions row wider than the available width does not '
      'overflow', (tester) async {
    await pump(
      tester,
      SizedBox(
        width: 200,
        child: MessageBubble(
          reactions: LinagoraReactions(
            reactions: [
              for (final emoji in ['❤️', '💜', '💚', '💛', '🧡'])
                LinagoraReactionChip(emoji: emoji, count: 128),
            ],
            onShowAll: (_) {},
          ),
          child: content,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getRect(find.byType(LinagoraReactions)).right,
      lessThanOrEqualTo(200),
    );
    expect(find.text('+4'), findsOneWidget);
  });
}
