import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets(
    'keeps category headers and visible descendants in one virtualized list',
    _buildsGroupedTree,
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

class _Node {
  const _Node(this.id, {this.children = const []});

  final String id;
  final List<_Node> children;
}
