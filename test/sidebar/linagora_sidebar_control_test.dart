import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  test('requires an accessible name for an interactive control', _requiresLabel);
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

void _noop() {}
