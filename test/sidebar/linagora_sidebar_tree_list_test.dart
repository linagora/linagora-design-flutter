import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_tree_list_test_utils.dart';

void main() {
  testWidgets('indents flattened child content without shrinking its row', _indentsChildContent);
  testWidgets('indents custom depths from the trailing edge in right-to-left locales', _indentsRightToLeft);
  testWidgets(
    'keeps unbounded indentation while clipping deep row content',
    _keepsUnboundedDeepIndent,
  );
  testWidgets(
    'scrolls only a deep tree when horizontal scrolling is enabled',
    _scrollsDeepTreeHorizontally,
  );
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

Future<void> _keepsUnboundedDeepIndent(WidgetTester tester) async {
  await pumpSidebarTreeList(
    tester,
    LinagoraSidebarTreeList<String>(
      maxIndent: double.infinity,
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
    20 * LinagoraSidebarSubItem.defaultIndent,
  );
  expect(find.byType(LinagoraSidebarTreeHorizontalScrollView), findsNothing);
  expect(tester.takeException(), isNull);
}

Future<void> _scrollsDeepTreeHorizontally(WidgetTester tester) async {
  await pumpSidebarTreeList(
    tester,
    LinagoraSidebarTreeList<String>(
      enableHorizontalScroll: true,
      maxIndent: double.infinity,
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

  final viewport = find.byWidgetPredicate(
    (widget) => widget is Scrollable && widget.axisDirection == AxisDirection.right,
  );
  final archiveLeft = tester.getRect(find.text('Archive')).left;

  expect(find.byType(LinagoraSidebarTreeHorizontalScrollView), findsOneWidget);
  expect(tester.state<ScrollableState>(viewport).position.maxScrollExtent,
      greaterThan(0));

  await tester.drag(find.text('Personal folders'), const Offset(-64, 0));
  await tester.pumpAndSettle();

  expect(tester.getRect(find.text('Archive')).left, lessThan(archiveLeft));
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
