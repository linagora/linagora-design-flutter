// Figma states the widget cannot express yet (Teammail 1.1, component set
// "tabs" / "tab", variant=picker). The constructor arguments used here are a
// proposal; rename them freely, the asserted geometry and colours are Figma's.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

enum _Tab { mine, shared, archived }

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

Finder _segment(_Tab tab) => find.byKey(LinagoraSegmentedTabs.segmentKey(tab));

void main() {
  testWidgets('hugs each label with 16px side padding when flex', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        LinagoraSegmentedTabs<_Tab>(
          segments: const [
            LinagoraSegment(value: _Tab.mine, label: 'By me'),
            LinagoraSegment(value: _Tab.shared, label: 'With me'),
          ],
          selected: _Tab.mine,
          onChanged: (_) {},
          hugContent: true,
        ),
      ),
    );

    for (final (tab, label) in [
      (_Tab.mine, 'By me'),
      (_Tab.shared, 'With me'),
    ]) {
      final segment = tester.getRect(_segment(tab));
      final text = tester.getRect(find.text(label));
      expect(text.left - segment.left, moreOrLessEquals(16, epsilon: 1));
      expect(segment.right - text.right, moreOrLessEquals(16, epsilon: 1));
    }
  });

  testWidgets('greys out a disabled segment and never selects it', (
    tester,
  ) async {
    final changes = <_Tab>[];
    await tester.pumpWidget(
      _host(
        LinagoraSegmentedTabs<_Tab>(
          segments: const [
            LinagoraSegment(value: _Tab.mine, label: 'By me'),
            LinagoraSegment(
              value: _Tab.shared,
              label: 'With me',
              enabled: false,
            ),
            LinagoraSegment(value: _Tab.archived, label: 'Archived'),
          ],
          selected: _Tab.mine,
          onChanged: changes.add,
        ),
      ),
    );

    // Figma state=disabed: label Text/secondary at 38%.
    expect(
      tester.widget<Text>(find.text('With me')).style?.color,
      const Color(0x61424244),
    );
    await tester.tap(_segment(_Tab.shared));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();

    expect(changes, [_Tab.archived]);
  });

  testWidgets('shows a count badge 8px after the label', (tester) async {
    await tester.pumpWidget(
      _host(
        LinagoraSegmentedTabs<_Tab>(
          segments: const [
            LinagoraSegment(value: _Tab.mine, label: 'By me'),
            LinagoraSegment(
              value: _Tab.shared,
              label: 'With me',
              badgeCount: 1,
            ),
          ],
          selected: _Tab.mine,
          onChanged: (_) {},
        ),
      ),
    );

    // Figma: 16x16 badge, 8px gap after the label, centred on the label row.
    final label = tester.getRect(find.text('With me'));
    final count = tester.getRect(find.text('1'));
    expect(count.center.dx - label.right, moreOrLessEquals(16, epsilon: 1));
    expect(count.center.dy, moreOrLessEquals(label.center.dy, epsilon: 1));
  });

  testWidgets('renders an icon-only segment with a spoken name', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        LinagoraSegmentedTabs<_Tab>(
          segments: const [
            LinagoraSegment.icon(
              value: _Tab.mine,
              icon: Icon(Icons.inbox_outlined),
              semanticLabel: 'Inbox',
            ),
            LinagoraSegment(value: _Tab.shared, label: 'With me'),
          ],
          selected: _Tab.mine,
          onChanged: (_) {},
        ),
      ),
    );

    expect(
      find.descendant(of: _segment(_Tab.mine), matching: find.byType(Text)),
      findsNothing,
    );
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.bySemanticsLabel('Inbox'), findsOneWidget);
    semantics.dispose();
  });
}
