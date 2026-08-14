import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  test('flattens only expanded descendants with their visual depth', _expandedTree);
  test('preserves root and sibling order', _siblingOrder);
  test('maps IDs into a product-provided namespace', _namespaceIds);
  test('accepts an empty or childless tree', _degenerateTrees);
  test('rejects duplicate visible IDs', _duplicateIds);
  test('flattens a deeply nested tree without recursion', _deepTree);
}

const _adapter = LinagoraSidebarTreeAdapter<_TreeNode>(
  childrenOf: _childrenOf,
  idOf: _idOf,
  isExpanded: _isExpanded,
);

Iterable<_TreeNode>? _childrenOf(_TreeNode node) => node.children;

Object _idOf(_TreeNode node) => node.id;

bool _isExpanded(_TreeNode node) => node.id != 'collapsed';

void _expandedTree() {
  const tree = _TreeNode(
    'root',
    children: [
      _TreeNode('expanded', children: [_TreeNode('leaf')]),
      _TreeNode('collapsed', children: [_TreeNode('hidden')]),
    ],
  );

  final entries = LinagoraSidebarTreeFlattener.flatten<_TreeNode>(
    roots: [tree],
    adapter: _adapter,
    initialDepth: 1,
  );

  expect(entries.map((entry) => entry.id), ['root', 'expanded', 'leaf', 'collapsed']);
  expect(entries.map((entry) => entry.depth), [1, 2, 3, 2]);
}

void _siblingOrder() {
  const roots = [
    _TreeNode('first', children: [_TreeNode('first-child')]),
    _TreeNode('second', children: [_TreeNode('second-child')]),
  ];

  final entries = LinagoraSidebarTreeFlattener.flatten<_TreeNode>(
    roots: roots,
    adapter: _adapter,
  );

  expect(
    entries.map((entry) => entry.id),
    ['first', 'first-child', 'second', 'second-child'],
  );
}

void _namespaceIds() {
  final entries = LinagoraSidebarTreeFlattener.flatten<_TreeNode>(
    roots: const [_TreeNode('root')],
    adapter: _adapter,
    namespaceId: (id) => 'team:$id',
  );

  expect(entries.single.id, 'team:root');
}

/// A product whose tree is still loading, or whose node exposes no children
/// collection, must not become a special case at the call site.
void _degenerateTrees() {
  expect(
    LinagoraSidebarTreeFlattener.flatten<_TreeNode>(
      roots: const [],
      adapter: _adapter,
    ),
    isEmpty,
  );

  final entries = LinagoraSidebarTreeFlattener.flatten<_TreeNode>(
    roots: const [_TreeNode('root')],
    adapter: const LinagoraSidebarTreeAdapter<_TreeNode>(
      childrenOf: _noChildren,
      idOf: _idOf,
      isExpanded: _alwaysExpanded,
    ),
  );

  expect(entries.single.id, 'root');
  expect(entries.single.depth, 0);
}

void _duplicateIds() {
  expect(
    () => LinagoraSidebarTreeFlattener.flatten<_TreeNode>(
      roots: const [_TreeNode('same'), _TreeNode('same')],
      adapter: _adapter,
    ),
    throwsArgumentError,
  );
}

void _deepTree() {
  final root = _TreeNode(
    '0',
    children: List<_TreeNode>.empty(growable: true),
  );
  var parent = root;
  for (var depth = 1; depth < 10000; depth++) {
    final child = _TreeNode('$depth', children: []);
    parent.children.add(child);
    parent = child;
  }

  final entries = LinagoraSidebarTreeFlattener.flatten<_TreeNode>(
    roots: [root],
    adapter: _adapter,
  );

  expect(entries, hasLength(10000));
  expect(entries.last.id, '9999');
  expect(entries.last.depth, 9999);
}

Iterable<_TreeNode>? _noChildren(_TreeNode node) => null;

bool _alwaysExpanded(_TreeNode node) => true;

class _TreeNode {
  const _TreeNode(this.id, {this.children = const []});

  final String id;
  final List<_TreeNode> children;
}
