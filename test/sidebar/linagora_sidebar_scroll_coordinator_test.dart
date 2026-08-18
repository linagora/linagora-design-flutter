import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets(
    'does not throw when the revealed target sits outside the '
    "controller's own viewport",
    _revealOutsideSharedViewport,
  );
}

/// `scheduleReveal` only guards on `controller.hasClients` before calling
/// `RenderAbstractViewport.of(renderObject)`, which throws a `FlutterError`
/// when `renderObject` has no `RenderAbstractViewport` ancestor. A row that
/// expands outside the scrollable the coordinator's controller belongs to —
/// e.g. below a nested `ListView` rather than inside it — hits exactly that.
Future<void> _revealOutsideSharedViewport(WidgetTester tester) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  var expanded = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: sidebarWidth,
          height: 300,
          child: LinagoraSidebarScrollCoordinator(
            controller: controller,
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView(
                      controller: controller,
                      children: List.generate(
                        10,
                        (index) => SizedBox(height: 30, child: Text('Row $index')),
                      ),
                    ),
                  ),
                  LinagoraSidebarItem(
                    label: 'Projects',
                    expanded: expanded,
                    expandToggleLabel: expanded ? 'Collapse' : 'Expand',
                    scrollIntoViewOnExpand: true,
                    onExpandTogglePressed: (_) async {
                      setState(() => expanded = true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
  await tester.pump();

  expect(expanded, isTrue);
  expect(
    tester.takeException(),
    isNull,
    reason:
        "scheduleReveal must not throw when the target isn't a descendant "
        "of the controller's own viewport",
  );
}
