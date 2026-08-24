import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_tree_list_test_utils.dart';

void main() {
  testWidgets('indents flattened child content without shrinking its row', _indentsChildContent);
  testWidgets('indents custom depths from the trailing edge in right-to-left locales', _indentsRightToLeft);
  testWidgets(
    'keeps unbounded indentation while clipping deep row content',
    (tester) => _verifyUnboundedDeepIndent(tester, TextDirection.ltr),
  );
  testWidgets(
    'keeps unbounded indentation from the trailing edge under RTL',
    (tester) => _verifyUnboundedDeepIndent(tester, TextDirection.rtl),
  );
  testWidgets(
    'caps deep indentation when a maximum is supplied',
    _capsDeepIndent,
  );
  testWidgets(
    'keeps deep row controls and badges inside the sidebar',
    _keepsDeepRowAffordancesVisible,
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
  await _pumpNestedFolderTreeList(
    tester,
    const _NestedFolderTreeListConfiguration(
      nestedFolderDepth: 1,
      indent: indent,
      textDirection: TextDirection.rtl,
    ),
  );

  _expectNestedFolderIndent(
    tester,
    indent,
    TextDirection.rtl,
  );
}

Future<void> _verifyUnboundedDeepIndent(
  WidgetTester tester,
  TextDirection textDirection,
) async {
  await _pumpNestedFolderTreeList(
    tester,
    _NestedFolderTreeListConfiguration(
      nestedFolderDepth: 20,
      maxIndent: double.infinity,
      textDirection: textDirection,
    ),
  );

  _expectNestedFolderIndent(
    tester,
    20 * LinagoraSidebarSubItem.defaultIndent,
    textDirection,
  );
  expect(tester.takeException(), isNull);
}

Future<void> _capsDeepIndent(WidgetTester tester) async {
  const maxIndent = 32.0;
  await _pumpNestedFolderTreeList(
    tester,
    const _NestedFolderTreeListConfiguration(
      nestedFolderDepth: 20,
      maxIndent: maxIndent,
    ),
  );

  _expectNestedFolderIndent(tester, maxIndent, TextDirection.ltr);
  expect(tester.takeException(), isNull);
}

Future<void> _pumpNestedFolderTreeList(
  WidgetTester tester,
  _NestedFolderTreeListConfiguration configuration,
) {
  return pumpSidebarTreeList(
    tester,
    Directionality(
      textDirection: configuration.textDirection,
      child: LinagoraSidebarTreeList<String>(
        indent: configuration.indent,
        maxIndent: configuration.maxIndent,
        entries: [
          const LinagoraSidebarTreeListEntry(
            id: 'personal',
            data: 'Personal folders',
          ),
          LinagoraSidebarTreeListEntry(
            id: 'nested-folder',
            data: 'Archive',
            depth: configuration.nestedFolderDepth,
          ),
        ],
        itemBuilder: sidebarTreeListFolderItem,
      ),
    ),
  );
}

class _NestedFolderTreeListConfiguration {
  const _NestedFolderTreeListConfiguration({
    required this.nestedFolderDepth,
    this.indent = LinagoraSidebarSubItem.defaultIndent,
    this.maxIndent = LinagoraSidebarTreeList.defaultMaxIndent,
    this.textDirection = TextDirection.ltr,
  });

  final int nestedFolderDepth;
  final double indent;
  final double maxIndent;
  final TextDirection textDirection;
}

void _expectNestedFolderIndent(
  WidgetTester tester,
  double expectedIndent,
  TextDirection textDirection,
) {
  final folderLabel = tester.getRect(find.text('Personal folders'));
  final nestedFolderLabelRect = tester.getRect(find.text('Archive'));
  final actualIndent = textDirection == TextDirection.rtl
      ? folderLabel.right - nestedFolderLabelRect.right
      : nestedFolderLabelRect.left - folderLabel.left;

  expect(actualIndent, expectedIndent);
}

Future<void> _keepsDeepRowAffordancesVisible(WidgetTester tester) async {
  const label = 'A long nested folder name that must not hide controls';
  var expandTaps = 0;
  await pumpSidebarTreeList(
    tester,
    LinagoraSidebarTreeList<String>(
      maxIndent: double.infinity,
      entries: const [
        LinagoraSidebarTreeListEntry(
          id: 'archive',
          data: label,
          depth: 20,
        ),
      ],
      itemBuilder: (context, entry) => LinagoraSidebarItem(
        label: entry.data,
        icon: Icons.folder_outlined,
        badgeLabel: '12',
        expanded: false,
        onExpandToggle: () => expandTaps++,
        expandToggleLabel: 'Expand folder',
      ),
    ),
  );

  final row = sidebarTreeListRowRect(tester, label);
  final badge = tester.getRect(find.byType(LinagoraSidebarBadge));
  final control = tester.getRect(find.byType(LinagoraSidebarControl));

  expect(row.contains(badge.center), isTrue);
  expect(row.contains(control.center), isTrue);
  await tester.tap(find.byType(LinagoraSidebarControl));
  expect(expandTaps, 1);
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
