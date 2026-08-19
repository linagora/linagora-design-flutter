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

class _Node {
  const _Node(this.id, {this.children = const []});

  final String id;
  final List<_Node> children;
}
