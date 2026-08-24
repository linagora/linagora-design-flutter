import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_tree_list_test_utils.dart';

/// `LinagoraSidebarSliverTreeList` shares `_SidebarTreeListRows` with the box
/// variant covered in `linagora_sidebar_tree_list_test.dart`, but had no test
/// of its own building it directly: nothing proved its sliver delegate,
/// indentation, or duplicate-ID rejection actually worked in a host-owned
/// scroll view.
void main() {
  testWidgets(
    'indents flattened rows in a host-owned viewport',
    _indentsChildContentInSliver,
  );
  testWidgets(
    'keeps unbounded indentation in a host-owned viewport',
    _keepsUnboundedDeepIndentInSliver,
  );
  test('rejects invalid tree list dimensions', _rejectsInvalidSliverDimensions);
}

Future<void> _indentsChildContentInSliver(WidgetTester tester) async {
  await pumpSidebarTreeList(
    tester,
    CustomScrollView(
      slivers: [
        LinagoraSidebarSliverTreeList<String>(
          entries: const [
            LinagoraSidebarTreeListEntry(id: 'personal', data: 'Personal folders'),
            LinagoraSidebarTreeListEntry(
              id: 'project',
              data: 'Project',
              depth: 1,
            ),
          ],
          itemBuilder: sidebarTreeListFolderItem,
        ),
      ],
    ),
  );

  final folderLabel = tester.getRect(find.text('Personal folders'));
  final childLabel = tester.getRect(find.text('Project'));

  expect(
    childLabel.left - folderLabel.left,
    LinagoraSidebarSubItem.defaultIndent,
  );
  expect(find.byKey(const ValueKey<Object>('project')), findsOneWidget);
}

Future<void> _keepsUnboundedDeepIndentInSliver(WidgetTester tester) async {
  await pumpSidebarTreeList(
    tester,
    CustomScrollView(
      slivers: [
        LinagoraSidebarSliverTreeList<String>(
          maxIndent: double.infinity,
          entries: const [
            LinagoraSidebarTreeListEntry(
              id: 'personal',
              data: 'Personal folders',
            ),
            LinagoraSidebarTreeListEntry(
              id: 'archive',
              data: 'Archive',
              depth: 20,
            ),
          ],
          itemBuilder: sidebarTreeListFolderItem,
        ),
      ],
    ),
  );

  final folderLabel = tester.getRect(find.text('Personal folders'));
  final deepLabel = tester.getRect(find.text('Archive'));

  expect(
    deepLabel.left - folderLabel.left,
    20 * LinagoraSidebarSubItem.defaultIndent,
  );
  expect(tester.takeException(), isNull);
}

void _rejectsInvalidSliverDimensions() {
  expect(
    () => LinagoraSidebarSliverTreeList<String>(
      entries: const [
        LinagoraSidebarTreeListEntry(id: 'folder', data: 'First'),
        LinagoraSidebarTreeListEntry(id: 'folder', data: 'Second'),
      ],
      itemBuilder: (_, entry) => Text(entry.data),
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraSidebarSliverTreeList<String>(
      entries: const [],
      indent: -1,
      itemBuilder: (_, entry) => Text(entry.data),
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraSidebarSliverTreeList<String>(
      entries: const [],
      maxIndent: -1,
      itemBuilder: (_, entry) => Text(entry.data),
    ),
    throwsAssertionError,
  );
}
