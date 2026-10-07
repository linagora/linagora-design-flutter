import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  const emojis = ['❤️', '💜', '💚', '💛', '🧡', '🖤', '🤍'];

  Future<void> pump(
    WidgetTester tester, {
    required int count,
    GestureTapDownCallback? onShowAll,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: LinagoraReactions(
              reactions: [
                for (final emoji in emojis.take(count))
                  LinagoraReactionChip(emoji: emoji),
              ],
              onShowAll: onShowAll,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('up to 3 reactions are followed by the more button', (
    tester,
  ) async {
    await pump(tester, count: 3, onShowAll: (_) {});

    expect(find.byType(LinagoraReactionChip), findsNWidgets(4));
    expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);
    expect(find.textContaining('+'), findsNothing);
  });

  testWidgets('more than 3 reactions replace the more button with +N', (
    tester,
  ) async {
    var shown = 0;
    await pump(tester, count: 7, onShowAll: (_) => shown++);

    expect(find.byType(LinagoraReactionChip), findsNWidgets(4));
    expect(find.text('💛'), findsNothing);
    expect(find.byIcon(Icons.more_horiz_rounded), findsNothing);

    await tester.tap(find.text('+4'));

    expect(shown, 1);
  });

  testWidgets('the more button is hidden without onShowAll', (tester) async {
    await pump(tester, count: 2);

    expect(find.byType(LinagoraReactionChip), findsNWidgets(2));
    expect(find.byIcon(Icons.more_horiz_rounded), findsNothing);
  });

  testWidgets('7 reactions fit a single 28px row', (tester) async {
    await pump(tester, count: 7, onShowAll: (_) {});

    expect(tester.getSize(find.byType(LinagoraReactions)).height, 28);
    expect(tester.takeException(), isNull);
  });
}
