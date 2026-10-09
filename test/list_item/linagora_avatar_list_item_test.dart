import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget build({
    String title = 'Stay in Paris',
    String? subtitle = '3976 members',
    String? trailingLabel,
    String? subtitleHeading,
    int subtitleMaxLines = 1,
    bool isTitleEmphasized = false,
    List<Widget> titleIcons = const [],
    bool selected = false,
    bool showDivider = true,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LinagoraAvatarListItem(
          avatar: const ColoredBox(color: Colors.blue),
          title: title,
          subtitle: subtitle,
          trailingLabel: trailingLabel,
          subtitleHeading: subtitleHeading,
          subtitleMaxLines: subtitleMaxLines,
          isTitleEmphasized: isTitleEmphasized,
          titleIcons: titleIcons,
          selected: selected,
          showDivider: showDivider,
          onTap: onTap,
        ),
      ),
    );
  }

  Color dividerColor(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(LinagoraAvatarListItem),
        matching: find.byType(DecoratedBox),
      ),
    );
    return ((box.decoration as BoxDecoration).border as Border).bottom.color;
  }

  testWidgets('shows title, subtitle and trailing label', (tester) async {
    await tester.pumpWidget(build(trailingLabel: '10:00'));

    expect(find.text('Stay in Paris'), findsOneWidget);
    expect(find.text('3976 members'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
  });

  testWidgets('title is semibold only when emphasized', (tester) async {
    await tester.pumpWidget(build());
    expect(
      tester.widget<Text>(find.text('Stay in Paris')).style?.fontWeight,
      FontWeight.w500,
    );

    await tester.pumpWidget(build(isTitleEmphasized: true));
    expect(
      tester.widget<Text>(find.text('Stay in Paris')).style?.fontWeight,
      FontWeight.w600,
    );
  });

  testWidgets('title icons follow the title in 20 squares', (tester) async {
    await tester.pumpWidget(
      build(titleIcons: const [Icon(Icons.push_pin_outlined)]),
    );
    final icon = find.byIcon(Icons.push_pin_outlined);

    expect(tester.getSize(icon), const Size(20, 20));
    expect(
      tester.getTopLeft(icon).dx -
          tester.getTopRight(find.text('Stay in Paris')).dx,
      4,
    );
  });

  testWidgets('subtitle heading sits between title and subtitle', (
    tester,
  ) async {
    await tester.pumpWidget(build(subtitleHeading: 'Liam'));

    expect(
      tester.getTopLeft(find.text('Liam')).dy,
      greaterThan(tester.getTopLeft(find.text('Stay in Paris')).dy),
    );
    expect(
      tester.getTopLeft(find.text('3976 members')).dy,
      greaterThan(tester.getTopLeft(find.text('Liam')).dy),
    );
  });

  testWidgets('subtitle wraps up to subtitleMaxLines', (tester) async {
    tester.view.physicalSize = const Size(300, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final subtitle = 'A long detail ' * 10;

    await tester.pumpWidget(build(subtitle: subtitle));
    final oneLine = tester.getSize(find.text(subtitle)).height;

    await tester.pumpWidget(build(subtitle: subtitle, subtitleMaxLines: 2));
    expect(tester.getSize(find.text(subtitle)).height, oneLine * 2);
  });

  testWidgets('avatar gets a 56 square', (tester) async {
    await tester.pumpWidget(build());

    expect(tester.getSize(find.byType(ColoredBox).last), const Size(56, 56));
  });

  testWidgets('keeps the same height without subtitle', (tester) async {
    await tester.pumpWidget(build());
    final height = tester.getSize(find.byType(LinagoraAvatarListItem)).height;

    await tester.pumpWidget(build(subtitle: null));
    expect(tester.getSize(find.byType(LinagoraAvatarListItem)).height, height);
  });

  testWidgets('tap calls onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(build(onTap: () => taps++));
    await tester.tap(find.text('Stay in Paris'));

    expect(taps, 1);
  });

  testWidgets('divider is hidden when selected or disabled by showDivider', (
    tester,
  ) async {
    await tester.pumpWidget(build());
    expect(dividerColor(tester), LinagoraDividerStyle.material().color);

    await tester.pumpWidget(build(selected: true));
    expect(dividerColor(tester), Colors.transparent);

    await tester.pumpWidget(build(showDivider: false));
    expect(dividerColor(tester), Colors.transparent);
  });

  testWidgets('divider is hidden while hovered', (tester) async {
    await tester.pumpWidget(build(onTap: () {}));
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.text('Stay in Paris')));
    await tester.pump();

    expect(dividerColor(tester), Colors.transparent);
  });

  testWidgets('long texts do not overflow', (tester) async {
    tester.view.physicalSize = const Size(200, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      build(
        title: 'Stay in Paris' * 5,
        subtitle: '3976 members' * 5,
        subtitleHeading: 'Liam' * 20,
        titleIcons: const [Icon(Icons.push_pin_outlined)],
        trailingLabel: '10:00',
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
