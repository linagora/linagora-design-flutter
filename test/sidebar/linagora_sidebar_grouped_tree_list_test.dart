import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets(
    'keeps category headers and visible descendants in one virtualized list',
    _buildsGroupedTree,
  );
  testWidgets(
    'does not throw when a group has an initial depth of zero',
    _initialDepthZeroGroup,
  );
  testWidgets(
    'keeps unbounded indentation for grouped trees',
    _keepsUnboundedGroupedIndent,
  );
  testWidgets(
    'scrolls only grouped tree rows when horizontal scrolling is enabled',
    _scrollsGroupedTreeHorizontally,
  );
  test('rejects duplicate group IDs', _rejectsDuplicateGroupIds);
}

Future<void> _buildsGroupedTree(WidgetTester tester) async {
  const groups = [
    LinagoraSidebarTreeGroup<_Node>(
      id: 'personal',
      header: Text('Personal folders'),
      roots: [
        _Node('project', children: [_Node('design')]),
      ],
      expanded: true,
    ),
    LinagoraSidebarTreeGroup<_Node>(
      id: 'team',
      header: Text('Team mailboxes'),
      roots: [_Node('team-folder')],
      expanded: false,
    ),
  ];

  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: CustomScrollView(
        slivers: [
          LinagoraSidebarSliverGroupedTreeList<_Node>(
            groups: groups,
            adapter: LinagoraSidebarTreeAdapter<_Node>(
              childrenOf: (node) => node.children,
              idOf: (node) => node.id,
              isExpanded: (node) => node.id == 'project',
            ),
            itemBuilder: (context, entry) => SizedBox(
              height: 36,
              child: Text(entry.data.id),
            ),
          ),
        ],
      ),
    ),
  );

  expect(find.text('Personal folders'), findsOneWidget);
  expect(find.text('project'), findsOneWidget);
  expect(find.text('design'), findsOneWidget);
  expect(find.text('Team mailboxes'), findsOneWidget);
  expect(find.text('team-folder'), findsNothing);
}

/// `LinagoraSidebarTreeGroup.initialDepth` is only asserted `>= 0`, so a
/// group-level `initialDepth: 0` is a value the API itself declares valid.
/// `_buildRow` wraps every entry — including a depth-0 root — in
/// `LinagoraSidebarSubItem`, whose constructor asserts `depth > 0`.
/// `_SidebarTreeListRows._buildEntry` (the plain tree list's row builder)
/// special-cases `depth == 0` to skip that wrapper; the grouped list's
/// `_buildRow` has no such guard.
Future<void> _initialDepthZeroGroup(WidgetTester tester) async {
  const groups = [
    LinagoraSidebarTreeGroup<_Node>(
      id: 'root-level',
      header: Text('Root level'),
      roots: [_Node('project')],
      initialDepth: 0,
    ),
  ];

  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: CustomScrollView(
        slivers: [
          LinagoraSidebarSliverGroupedTreeList<_Node>(
            groups: groups,
            adapter: LinagoraSidebarTreeAdapter<_Node>(
              childrenOf: (node) => node.children,
              idOf: (node) => node.id,
              isExpanded: (node) => false,
            ),
            itemBuilder: (context, entry) => SizedBox(
              height: 36,
              child: Text(entry.data.id),
            ),
          ),
        ],
      ),
    ),
  );

  expect(
    tester.takeException(),
    isNull,
    reason:
        'LinagoraSidebarTreeGroup.initialDepth allows 0, but '
        'LinagoraSidebarSubItem asserts depth > 0 for every entry row',
  );
}

Future<void> _keepsUnboundedGroupedIndent(WidgetTester tester) async {
  var deepNode = const _Node('20');
  for (var depth = 19; depth >= 0; depth--) {
    deepNode = _Node('$depth', children: [deepNode]);
  }
  final groups = [
    LinagoraSidebarTreeGroup<_Node>(
      id: 'personal',
      header: const Text('Personal folders'),
      roots: [deepNode],
    ),
  ];

  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: CustomScrollView(
        slivers: [
          LinagoraSidebarSliverGroupedTreeList<_Node>(
            maxIndent: double.infinity,
            groups: groups,
            adapter: const LinagoraSidebarTreeAdapter<_Node>(
              childrenOf: _childrenOf,
              idOf: _idOf,
              isExpanded: _alwaysExpanded,
            ),
            itemBuilder: (context, entry) => LinagoraSidebarItem(
              label: entry.data.id,
              icon: Icons.folder_outlined,
            ),
          ),
        ],
      ),
    ),
  );

  final rootLeft = tester.getRect(find.text('0')).left;
  await tester.scrollUntilVisible(find.text('20'), 72);
  final deepLeft = tester.getRect(find.text('20')).left;

  expect(
    deepLeft - rootLeft,
    20 * LinagoraSidebarSubItem.defaultIndent,
  );
  expect(find.byType(LinagoraSidebarTreeHorizontalScrollView), findsNothing);
  expect(tester.takeException(), isNull);
}

Future<void> _scrollsGroupedTreeHorizontally(WidgetTester tester) async {
  const groups = [
    LinagoraSidebarTreeGroup<_Node>(
      id: 'personal',
      header: Text('Personal folders'),
      roots: [_Node('Archive')],
      initialDepth: 20,
    ),
  ];

  await pumpSidebar(
    tester,
    SizedBox(
      height: 300,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Text('Inbox')),
          LinagoraSidebarSliverGroupedTreeList<_Node>(
            groups: groups,
            adapter: const LinagoraSidebarTreeAdapter<_Node>(
              childrenOf: _childrenOf,
              idOf: _idOf,
              isExpanded: _alwaysExpanded,
            ),
            itemBuilder: (context, entry) => LinagoraSidebarItem(
              label: entry.data.id,
              icon: Icons.folder_outlined,
            ),
            maxIndent: double.infinity,
            enableHorizontalScroll: true,
          ),
          const SliverToBoxAdapter(child: Text('Storage')),
        ],
      ),
    ),
  );

  final inboxLeft = tester.getRect(find.text('Inbox')).left;
  final archiveLeft = tester.getRect(find.text('Archive')).left;

  await tester.drag(find.text('Personal folders'), const Offset(-64, 0));
  await tester.pump();

  expect(tester.getRect(find.text('Archive')).left, lessThan(archiveLeft));
  expect(tester.getRect(find.text('Inbox')).left, inboxLeft);
  expect(tester.takeException(), isNull);
}

void _rejectsDuplicateGroupIds() {
  expect(
    () => LinagoraSidebarSliverGroupedTreeList<_Node>(
      groups: const [
        LinagoraSidebarTreeGroup<_Node>(
          id: 'personal',
          header: Text('Personal folders'),
          roots: [_Node('project')],
        ),
        LinagoraSidebarTreeGroup<_Node>(
          id: 'personal',
          header: Text('Personal folders (again)'),
          roots: [_Node('archive')],
        ),
      ],
      adapter: const LinagoraSidebarTreeAdapter<_Node>(
        childrenOf: _childrenOf,
        idOf: _idOf,
        isExpanded: _alwaysExpanded,
      ),
      itemBuilder: (context, entry) => Text(entry.data.id),
    ),
    throwsAssertionError,
  );
}

Iterable<_Node> _childrenOf(_Node node) => node.children;

Object _idOf(_Node node) => node.id;

bool _alwaysExpanded(_Node node) => true;

class _Node {
  const _Node(this.id, {this.children = const []});

  final String id;
  final List<_Node> children;
}
