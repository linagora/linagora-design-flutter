import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget build(Widget chip) {
    return MaterialApp(
      home: Scaffold(body: Row(children: [chip])),
    );
  }

  Size chipSize(WidgetTester tester) =>
      tester.getSize(find.byType(LinagoraReactionChip));

  testWidgets('reaction without count is a 28px circle centered on its emoji', (
    tester,
  ) async {
    await tester.pumpWidget(build(const LinagoraReactionChip(emoji: '👍')));

    expect(chipSize(tester), const Size(28, 28));
    expect(
      tester.getCenter(find.text('👍')),
      tester.getCenter(find.byType(LinagoraReactionChip)),
    );
    expect(find.text('👍'), findsOneWidget);
  });

  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    testWidgets('emoji wider than its box stays centered on ${platform.name}', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = platform;
      // The glyphs of the test font are as wide as the font size: a flag is
      // made of two of them.
      await tester.pumpWidget(build(const LinagoraReactionChip(emoji: '🇫🇷')));

      final emoji = tester.getRect(find.text('🇫🇷'));
      final chip = tester.getRect(find.byType(LinagoraReactionChip));
      debugDefaultTargetPlatformOverride = null;

      expect(emoji.center.dy, chip.center.dy);
      // Apple Color Emoji is not centered in its advance: see the chip.
      if (platform == TargetPlatform.android) {
        expect(emoji.width, greaterThan(20));
        expect(emoji.center.dx, chip.center.dx);
      }
    });
  }

  testWidgets('reaction shows its count next to the emoji', (tester) async {
    await tester.pumpWidget(
      build(const LinagoraReactionChip(emoji: '👍', count: 12)),
    );

    expect(find.text('12'), findsOneWidget);
    expect(chipSize(tester).height, 28);
    expect(
      tester.getTopLeft(find.text('12')).dx,
      greaterThan(tester.getTopRight(find.text('👍')).dx),
    );
  });

  testWidgets('custom emoji image is laid out in a 20px box', (tester) async {
    await tester.pumpWidget(
      build(
        const LinagoraReactionChip.image(
          image: ColoredBox(key: Key('image'), color: Colors.blue),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('image'))), const Size(20, 20));
  });

  testWidgets('tap and long press are forwarded', (tester) async {
    var taps = 0;
    var longPresses = 0;
    await tester.pumpWidget(
      build(
        LinagoraReactionChip(
          emoji: '👍',
          onTap: () => taps++,
          onLongPress: () => longPresses++,
        ),
      ),
    );

    await tester.tap(find.byType(LinagoraReactionChip));
    await tester.longPress(find.byType(LinagoraReactionChip));

    expect(taps, 1);
    expect(longPresses, 1);
  });

  for (final count in [4, 12, 128]) {
    testWidgets('remaining "+$count" stays on a single line', (tester) async {
      await tester.pumpWidget(
        build(LinagoraReactionChip.remaining(count: count)),
      );

      final text = tester.getSize(find.text('+$count'));
      final chip = chipSize(tester);

      expect(text.height, 20);
      expect(chip.height, 28);
      expect(chip.width, greaterThanOrEqualTo(text.width + 12));
      expect(chip.width, greaterThanOrEqualTo(28));
    });
  }

  testWidgets('remaining reports the tap position', (tester) async {
    TapDownDetails? details;
    await tester.pumpWidget(
      build(
        LinagoraReactionChip.remaining(count: 4, onTapDown: (d) => details = d),
      ),
    );

    await tester.tap(find.byType(LinagoraReactionChip));

    expect(details, isNotNull);
  });

  testWidgets('more button is a 28px circle reporting the tap position', (
    tester,
  ) async {
    TapDownDetails? details;
    await tester.pumpWidget(
      build(LinagoraReactionChip.more(onTapDown: (d) => details = d)),
    );

    expect(chipSize(tester), const Size(28, 28));

    await tester.tap(find.byType(LinagoraReactionChip));

    expect(details, isNotNull);
  });

  testWidgets('semanticLabel replaces the content for screen readers', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      build(
        LinagoraReactionChip(
          emoji: '👍',
          count: 3,
          semanticLabel: 'Thumbs up, 3 reactions',
          onTap: () {},
        ),
      ),
    );

    expect(
      tester.getSemantics(find.bySemanticsLabel('Thumbs up, 3 reactions')),
      containsSemantics(isButton: true, hasTapAction: true),
    );
    expect(find.bySemanticsLabel(RegExp('3\$')), findsNothing);
    handle.dispose();
  });
}
