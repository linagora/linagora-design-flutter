import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'stops scrolling once the drag ends mid-animation',
    _stopsScrollingWhenDragEnds,
  );
}

/// `_updateController` only removes its listener when `isDragging` flips to
/// false; it never cancels an in-flight `controller.animateTo` started by
/// `_scrollToStart`/`_scrollToEnd`. Hovering the bottom edge kicks off a
/// 1-second animation toward `maxScrollExtent`; ending the drag partway
/// through must stop it, not let it run to completion unattended.
Future<void> _stopsScrollingWhenDragEnds(WidgetTester tester) async {
  final controller = ScrollController(initialScrollOffset: 500);
  addTearDown(controller.dispose);

  Widget buildTree({required bool isDragging}) => MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 204,
        height: 200,
        child: Stack(
          children: [
            ListView(
              controller: controller,
              children: [
                for (var index = 0; index < 20; index++)
                  SizedBox(height: 50, child: Text('Row $index')),
              ],
            ),
            Positioned.fill(
              child: LinagoraSidebarAutoScrollOverlay(
                isDragging: isDragging,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  await tester.pumpWidget(buildTree(isDragging: true));
  await tester.pump();

  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(() => mouse.removePointer());
  await mouse.addPointer(location: Offset.zero);
  await tester.pump();
  await mouse.moveTo(const Offset(100, 190));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));

  final maxScrollExtent = controller.position.maxScrollExtent;

  // End the drag partway through the 1-second scroll-to-end animation,
  // without moving the pointer off the edge first.
  await tester.pumpWidget(buildTree(isDragging: false));
  await tester.pump(const Duration(milliseconds: 900));

  expect(
    controller.offset,
    isNot(closeTo(maxScrollExtent, 0.5)),
    reason:
        'ending the drag must stop the auto-scroll, but the ScrollController '
        "animation keeps running toward maxScrollExtent regardless of isDragging",
  );
}
