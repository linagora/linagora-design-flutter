import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget build({
    LinagoraReactionItemSize size = LinagoraReactionItemSize.small,
    VoidCallback? onTap,
    String name = 'Name',
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: LinagoraReactionItem(
            name: name,
            emoji: '😀',
            avatar: const ColoredBox(key: Key('avatar'), color: Colors.blue),
            size: size,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  testWidgets('small size renders a 24px avatar in a 40px row', (tester) async {
    await tester.pumpWidget(build());

    expect(tester.getSize(find.byKey(const Key('avatar'))), const Size(24, 24));
    expect(tester.getSize(find.byType(LinagoraReactionItem)).height, 40);
    expect(find.text('😀'), findsOneWidget);
  });

  testWidgets('large size renders a 40px avatar in a 56px row', (tester) async {
    await tester.pumpWidget(build(size: LinagoraReactionItemSize.large));

    expect(tester.getSize(find.byKey(const Key('avatar'))), const Size(40, 40));
    expect(tester.getSize(find.byType(LinagoraReactionItem)).height, 56);
  });

  testWidgets('tap calls onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(build(onTap: () => taps++));

    await tester.tap(find.text('Name'));

    expect(taps, 1);
  });

  testWidgets('long name does not overflow on narrow width', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 150,
            child: LinagoraReactionItem(
              name: 'A very long display name that must be ellipsized',
              emoji: '👍',
              avatar: SizedBox(),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
