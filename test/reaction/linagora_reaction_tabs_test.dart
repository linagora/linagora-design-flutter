import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  const tabs = [
    LinagoraReactionTab(label: 'All 5'),
    LinagoraReactionTab(label: '👍 3'),
    LinagoraReactionTab(
      label: '2',
      image: ColoredBox(key: Key('image'), color: Colors.blue),
    ),
  ];

  Future<void> pump(
    WidgetTester tester, {
    int selectedIndex = 0,
    ValueChanged<int>? onSelected,
    double width = 400,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: LinagoraReactionTabs(
                tabs: tabs,
                selectedIndex: selectedIndex,
                onSelected: onSelected ?? (_) {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  Finder indicator() => find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        (widget.decoration as BoxDecoration?)?.color ==
            LinagoraSysColors.material().primary,
  );

  testWidgets('is 48px high with the first label 24px from the edge', (
    tester,
  ) async {
    await pump(tester);

    expect(tester.getSize(find.byType(LinagoraReactionTabs)).height, 48);
    expect(tester.getTopLeft(find.text('All 5')).dx, 24);
    expect(tester.getSize(find.byKey(const Key('image'))), const Size(24, 24));
  });

  testWidgets('only the selected tab shows the indicator, under its label', (
    tester,
  ) async {
    await pump(tester, selectedIndex: 1);

    expect(indicator(), findsOneWidget);
    final label = tester.getRect(find.text('👍 3'));
    final bar = tester.getRect(
      find.descendant(of: indicator(), matching: find.byType(DecoratedBox)),
    );
    expect(bar.left, label.left + 2);
    expect(bar.right, label.right - 2);
    expect(bar.bottom, 48);
    expect(bar.height, 3);
  });

  testWidgets('tapping a tab reports its index', (tester) async {
    int? selected;
    await pump(tester, onSelected: (index) => selected = index);

    await tester.tap(find.text('👍 3'));

    expect(selected, 1);
  });

  testWidgets('scrolls instead of overflowing on a narrow width', (
    tester,
  ) async {
    await pump(tester, width: 100);

    expect(tester.takeException(), isNull);
  });
}
