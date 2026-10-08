import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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

  testWidgets('a press that turns into a drag does not show all', (
    tester,
  ) async {
    var shown = 0;
    await pump(tester, count: 7, onShowAll: (_) => shown++);

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('+4')),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.moveBy(const Offset(0, 100));
    await gesture.up();

    expect(shown, 0);
  });

  testWidgets('showing all reports where the chip was tapped', (tester) async {
    TapDownDetails? details;
    await pump(tester, count: 7, onShowAll: (d) => details = d);

    final position = tester.getTopLeft(find.text('+4')) + const Offset(1, 1);
    await tester.tapAt(position);

    expect(details?.globalPosition, position);
  });

  testWidgets('showing all is reachable from the semantics tree', (
    tester,
  ) async {
    TapDownDetails? details;
    await pump(tester, count: 3, onShowAll: (d) => details = d);

    final more = find.ancestor(
      of: find.byIcon(Icons.more_horiz_rounded),
      matching: find.byType(LinagoraReactionChip),
    );
    final handle = tester.ensureSemantics();
    tester.semantics.tap(find.semantics.byAction(SemanticsAction.tap).last);
    handle.dispose();

    expect(details?.globalPosition, tester.getCenter(more));
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
