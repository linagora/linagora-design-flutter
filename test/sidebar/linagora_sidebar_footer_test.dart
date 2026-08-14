import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets('omits null footer slots before applying spacing', _footerSlots);
  testWidgets('collapses a footer with nothing to show', _emptyFooter);
  testWidgets('renders a full-width generic upsell button', _upsellButton);
  testWidgets('hugs a promotion asked to fit its content', _upsellHugs);
  testWidgets('disables the reload action while it is loading', _reloadAction);
  testWidgets('names and rests the reload action when idle', _idleReloadAction);
}

Future<void> _emptyFooter(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarFooter(children: [null, null]),
  );

  // Every product slot hidden means no footer, not an empty band of padding.
  expect(tester.getSize(find.byType(LinagoraSidebarFooter)).height, 0);
}

Future<void> _upsellHugs(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    LinagoraSidebarUpsellButton(
      // Short on purpose: the test font gives every glyph a full-width box.
      label: 'Go',
      icon: Icons.workspace_premium_outlined,
      expanded: false,
      minWidth: 120,
      onPressed: () {},
    ),
  );

  final size = tester.getSize(find.byType(OutlinedButton));
  expect(size.width, lessThan(sidebarWidth));
  expect(size.width, 120);
  expect(size.height, LinagoraSidebarUpsellButton.height);
}

Future<void> _idleReloadAction(WidgetTester tester) async {
  var taps = 0;
  final handle = tester.ensureSemantics();

  await pumpSidebar(
    tester,
    LinagoraSidebarStorageReloadAction(
      isLoading: true,
      semanticLabel: 'Reload storage',
      onPressed: () => taps++,
      iconWidget: const Icon(Icons.refresh),
    ),
  );
  // Mid-spin, so a controller that only stopped would freeze at an angle.
  await tester.pump(const Duration(milliseconds: 500));

  await pumpSidebar(
    tester,
    LinagoraSidebarStorageReloadAction(
      isLoading: false,
      semanticLabel: 'Reload storage',
      onPressed: () => taps++,
      iconWidget: const Icon(Icons.refresh),
    ),
  );

  final rotation = tester
      .widgetList<RotationTransition>(
        find.ancestor(
          of: find.byIcon(Icons.refresh),
          matching: find.byType(RotationTransition),
        ),
      )
      .first;
  expect(rotation.turns.value, 0);

  // Named once: two annotations would announce the label twice.
  expect(
    tester.getSemantics(find.byType(LinagoraSidebarStorageReloadAction)),
    containsSemantics(
      label: 'Reload storage',
      isButton: true,
      hasTapAction: true,
    ),
  );

  await tester.tap(find.bySemanticsLabel('Reload storage'));
  expect(taps, 1);
  handle.dispose();
}

Future<void> _footerSlots(WidgetTester tester) async {
  const firstKey = Key('first-footer-slot');
  const secondKey = Key('second-footer-slot');
  await pumpSidebar(
    tester,
    const LinagoraSidebarFooter(
      spacing: 12,
      padding: EdgeInsets.zero,
      children: [
        SizedBox(key: firstKey, height: 10),
        null,
        SizedBox(key: secondKey, height: 10),
      ],
    ),
  );

  final first = tester.getRect(find.byKey(firstKey));
  final second = tester.getRect(find.byKey(secondKey));
  expect(second.top - first.bottom, 12);
}

Future<void> _upsellButton(WidgetTester tester) async {
  var taps = 0;
  await pumpSidebar(
    tester,
    LinagoraSidebarUpsellButton(
      label: 'Increase space',
      icon: Icons.workspace_premium_outlined,
      onPressed: () => taps++,
    ),
  );

  expect(
    tester.getSize(find.byType(OutlinedButton)).height,
    LinagoraSidebarUpsellButton.height,
  );
  await tester.tap(find.text('Increase space'));
  expect(taps, 1);
}

Future<void> _reloadAction(WidgetTester tester) async {
  var taps = 0;
  await pumpSidebar(
    tester,
    LinagoraSidebarStorageReloadAction(
      isLoading: true,
      semanticLabel: 'Reload storage',
      onPressed: () => taps++,
      iconWidget: const Icon(Icons.refresh),
    ),
  );

  expect(
    find.descendant(
      of: find.byType(LinagoraSidebarStorageReloadAction),
      matching: find.byType(RotationTransition),
    ),
    findsOneWidget,
  );
  await tester.tap(find.bySemanticsLabel('Reload storage'));
  expect(taps, 0);
}
