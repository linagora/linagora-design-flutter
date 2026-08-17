import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  test('requires an accessible name for an interactive control', _requiresLabel);
  test(
    'does not allow a target smaller than its icon',
    _requiresLargeEnoughTarget,
  );
  testWidgets('uses an explicitly requested compact target', _compactTarget);
}

void _requiresLabel() {
  expect(
    () => LinagoraSidebarControl(
      icon: Icons.add,
      iconSize: 16,
      onTap: _noop,
    ),
    throwsAssertionError,
  );
}

void _requiresLargeEnoughTarget() {
  expect(
    () => LinagoraSidebarControl(
      icon: Icons.add,
      iconSize: 16.67,
      targetSize: 16.66,
    ),
    throwsAssertionError,
  );
}

Future<void> _compactTarget(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Material(
        child: Align(
          alignment: Alignment.topLeft,
          child: LinagoraSidebarControl(
            icon: Icons.add,
            iconSize: 16.67,
            targetSize: 16.67,
            semanticLabel: 'Add folder',
            onTap: _noop,
          ),
        ),
      ),
    ),
  );

  final target = find.ancestor(
    of: find.byIcon(Icons.add),
    matching: find.byType(InkResponse),
  );
  _expectSquareSize(tester.getSize(target), 16.67);
  expect(tester.getRect(find.byIcon(Icons.add)), tester.getRect(target));
}

void _expectSquareSize(Size actual, double expected) {
  expect(actual.width, closeTo(expected, 0.01));
  expect(actual.height, closeTo(expected, 0.01));
}

void _noop() {}
