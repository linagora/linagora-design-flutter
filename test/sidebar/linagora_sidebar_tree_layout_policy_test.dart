import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  const policy = LinagoraSidebarTreeLayoutPolicy<_TreeNode>(
    adapter: _adapter,
  );

  group('LinagoraSidebarTreeLayoutPolicy', () {
    test('does not add overflow up to the inline indent limit', () {
      final root = _deeplyNestedTree(depth: 8);

      expect(
        policy.maximumVisibleDepth([
          LinagoraSidebarVisibleTree(roots: [root]),
        ]),
        8,
      );
      expect(
        policy.horizontalOverflowFor([
          LinagoraSidebarVisibleTree(roots: [root]),
        ]),
        0,
      );
    });

    test('adds only the indent beyond the inline limit', () {
      final root = _deeplyNestedTree(depth: 9);

      expect(
        policy.horizontalOverflowFor([
          LinagoraSidebarVisibleTree(roots: [root]),
        ]),
        policy.indent * 9 - policy.maxInlineIndent,
      );
    });

    test('does not count descendants hidden by a collapsed node', () {
      final root = _TreeNode(
        'collapsed',
        expanded: false,
        children: [_deeplyNestedTree(depth: 12)],
      );

      expect(
        policy.maximumVisibleDepth([
          LinagoraSidebarVisibleTree(roots: [root], initialDepth: 1),
        ]),
        1,
      );
    });

    test('keeps category root indentation in the visible depth', () {
      final defaultRoot = _TreeNode('default');
      final categoryRoot = _deeplyNestedTree(depth: 2);

      expect(
        policy.maximumVisibleDepth([
          LinagoraSidebarVisibleTree(roots: [defaultRoot]),
          LinagoraSidebarVisibleTree(roots: [categoryRoot], initialDepth: 1),
        ]),
        3,
      );
    });

    test('handles a very deep tree without recursive stack growth', () {
      final root = _deeplyNestedTree(depth: 1000);

      expect(
        policy.maximumVisibleDepth([
          LinagoraSidebarVisibleTree(roots: [root]),
        ]),
        1000,
      );
    });

    test('terminates on a malformed circular reference', () {
      final root = _TreeNode('cycle');
      root.children.add(root);

      expect(
        policy.maximumVisibleDepth([
          LinagoraSidebarVisibleTree(roots: [root]),
        ]),
        0,
      );
    });

    test('measures a shared node in each non-circular branch', () {
      final shared = _TreeNode('shared');
      final shallowBranch = _TreeNode('shallow', children: [shared]);
      final deepBranch = _TreeNode(
        'deep',
        children: [
          _TreeNode('nested', children: [shared]),
        ],
      );

      expect(
        policy.maximumVisibleDepth([
          LinagoraSidebarVisibleTree(roots: [shallowBranch, deepBranch]),
        ]),
        2,
      );
    });

    test('supports a compact policy without hidden layout constants', () {
      const compactPolicy = LinagoraSidebarTreeLayoutPolicy<_TreeNode>(
        adapter: _adapter,
        indent: 16,
        maxInlineIndent: 32,
      );
      final root = _deeplyNestedTree(depth: 3);

      expect(
        compactPolicy.horizontalOverflowFor([
          LinagoraSidebarVisibleTree(roots: [root]),
        ]),
        16,
      );
    });
  });
}

const _adapter = LinagoraSidebarTreeAdapter<_TreeNode>(
  childrenOf: _childrenOf,
  idOf: _idOf,
  isExpanded: _isExpanded,
);

Iterable<_TreeNode> _childrenOf(_TreeNode node) => node.children;

Object _idOf(_TreeNode node) => node.id;

bool _isExpanded(_TreeNode node) => node.expanded;

_TreeNode _deeplyNestedTree({required int depth}) {
  final root = _TreeNode('node-0');
  var currentNode = root;

  for (var level = 1; level <= depth; level++) {
    final child = _TreeNode('node-$level');
    currentNode.children.add(child);
    currentNode = child;
  }

  return root;
}

class _TreeNode {
  _TreeNode(this.id, {List<_TreeNode>? children, this.expanded = true})
      : children = children ?? [];

  final String id;
  final bool expanded;
  final List<_TreeNode> children;
}
