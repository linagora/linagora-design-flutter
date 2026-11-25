// Figma states the widget cannot express yet (Teammail 1.1, component set
// "tabs" / "tab", variant=picker). The constructor arguments used here are a
// proposal; rename them freely, the asserted geometry and colours are Figma's.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

enum _Tab { mine, shared }

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
}
