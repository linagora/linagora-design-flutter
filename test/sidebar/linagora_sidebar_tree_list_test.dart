import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_tree_list_test_utils.dart';

void main() {
  testWidgets('indents flattened child content without shrinking its row', _indentsChildContent);
  testWidgets('indents custom depths from the trailing edge in right-to-left locales', _indentsRightToLeft);
  testWidgets('caps deep indentation to preserve row content', _capsDeepIndent);
  testWidgets('lets the application control visible descendants', _usesApplicationExpansion);
  test('rejects invalid tree list dimensions', _rejectsInvalidDimensions);
}

Future<void> _indentsChildContent(WidgetTester tester) async {
  await pumpSidebarTreeList(
    tester,
    LinagoraSidebarTreeList<String>(
      entries: const [
        LinagoraSidebarTreeListEntry(id: 'personal', data: 'Personal folders'),
        LinagoraSidebarTreeListEntry(
          id: 'project',
          data: 'Project',
          depth: 1,
        ),
        LinagoraSidebarTreeListEntry(
          id: 'archive',
          data: 'Archive',
          depth: 3,
        ),
      ],
      itemBuilder: sidebarTreeListFolderItem,
    ),
  );

  final folderLabel = tester.getRect(find.text('Personal folders'));
  final childLabel = tester.getRect(find.text('Project'));

  expect(
    childLabel.left - folderLabel.left,
    LinagoraSidebarSubItem.defaultIndent,
  );
  final folderRow = sidebarTreeListRowRect(tester, 'Personal folders');
  final childRow = sidebarTreeListRowRect(tester, 'Project');
  expect(childRow.left, folderRow.left);
  expect(childRow.width, folderRow.width);
  expect(
    tester.getRect(find.text('Archive')).left - folderLabel.left,
    3 * LinagoraSidebarSubItem.defaultIndent,
  );
  expect(find.byKey(const ValueKey<Object>('project')), findsOneWidget);
}

Future<void> _indentsRightToLeft(WidgetTester tester) async {
  const indent = 12.0;
  await pumpSidebarTreeList(
    tester,
    Directionality(
      textDirection: TextDirection.rtl,
      child: LinagoraSidebarTreeList<String>(
        indent: indent,
        entries: const [
          LinagoraSidebarTreeListEntry(
            id: 'personal',
            data: 'Personal folders',
          ),
          LinagoraSidebarTreeListEntry(
            id: 'project',
            data: 'Project',
            depth: 1,
          ),
        ],
        itemBuilder: sidebarTreeListFolderItem,
      ),
    ),
  );

  final folderLabel = tester.getRect(find.text('Personal folders'));
  final childLabel = tester.getRect(find.text('Project'));

  expect(
    folderLabel.right - childLabel.right,
    indent,
  );
}

/// Folder protocols allow unbounded nesting while the sidebar keeps a fixed
/// width. Uncapped, `depth * indent` pushed the leading icon out of a 204px row
/// and it overflowed, so the indent has to flatten instead of growing.
Future<void> _capsDeepIndent(WidgetTester tester) async {
  await pumpSidebarTreeList(
    tester,
    LinagoraSidebarTreeList<String>(
      entries: const [
        LinagoraSidebarTreeListEntry(id: 'personal', data: 'Personal folders'),
        LinagoraSidebarTreeListEntry(
          id: 'archive',
          data: 'Archive',
          depth: 20,
        ),
      ],
      itemBuilder: sidebarTreeListFolderItem,
    ),
  );

  final folderLabel = tester.getRect(find.text('Personal folders'));
  final deepLabel = tester.getRect(find.text('Archive'));

  expect(
    deepLabel.left - folderLabel.left,
    LinagoraSidebarTreeList.defaultMaxIndent,
  );
  expect(tester.takeException(), isNull);
}

Future<void> _usesApplicationExpansion(WidgetTester tester) async {
  await pumpSidebarTreeList(tester, const _ControlledTreeList());

  expect(find.text('Project'), findsNothing);

  await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
  await tester.pump();

  expect(find.text('Project'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
  await tester.pump();

  expect(find.text('Project'), findsNothing);
}

void _rejectsInvalidDimensions() {
  expect(
    () => LinagoraSidebarTreeListEntry(
      id: 'folder',
      data: 'Folder',
      depth: -1,
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraSidebarTreeList<String>(
      entries: const [
        LinagoraSidebarTreeListEntry(id: 'folder', data: 'First'),
        LinagoraSidebarTreeListEntry(id: 'folder', data: 'Second'),
      ],
      itemBuilder: (_, entry) => Text(entry.data),
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraSidebarTreeList<String>(
      entries: const [],
      indent: -1,
      itemBuilder: (_, entry) => Text(entry.data),
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraSidebarTreeList<String>(
      entries: const [],
      maxIndent: -1,
      itemBuilder: (_, entry) => Text(entry.data),
    ),
    throwsAssertionError,
  );
  expect(
    () => LinagoraSidebarSubItem(depth: 0, child: const SizedBox()),
    throwsAssertionError,
  );
}

class _ControlledTreeList extends StatefulWidget {
  const _ControlledTreeList();

  @override
  State<_ControlledTreeList> createState() => _ControlledTreeListState();
}

class _ControlledTreeListState extends State<_ControlledTreeList> {
  bool _personalFoldersExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LinagoraSidebarTreeList<String>(
      entries: [
        const LinagoraSidebarTreeListEntry(
          id: 'personal',
          data: 'Personal folders',
        ),
        if (_personalFoldersExpanded)
          const LinagoraSidebarTreeListEntry(
            id: 'project',
            data: 'Project',
            depth: 1,
          ),
      ],
      itemBuilder: _buildFolder,
    );
  }

  Widget _buildFolder(
    BuildContext context,
    LinagoraSidebarTreeListEntry<String> entry,
  ) {
    final isPersonalFolders = entry.id == 'personal';
    return LinagoraSidebarItem(
      label: entry.data,
      icon: Icons.folder_outlined,
      expanded: isPersonalFolders ? _personalFoldersExpanded : null,
      onExpandToggle: isPersonalFolders ? _togglePersonalFolders : null,
      expandToggleLabel: isPersonalFolders
          ? (_personalFoldersExpanded ? 'Collapse folders' : 'Expand folders')
          : null,
    );
  }

  void _togglePersonalFolders() {
    setState(() => _personalFoldersExpanded = !_personalFoldersExpanded);
  }
}
