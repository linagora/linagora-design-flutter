import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  test('reuses a sidebar tree layout until its revision changes', () {
    const layoutPolicy = LinagoraSidebarTreeLayoutPolicy<_TreeNode>(
      adapter: _adapter,
    );
    final projection = LinagoraSidebarTreeProjection<_TreeNode>(
      layoutPolicy: layoutPolicy,
    );
    final initialRoot = _deeplyNestedTree(depth: 9);
    var visibleTreesBuildCount = 0;

    final initialOverflow = projection.resolveHorizontalOverflow(
      layoutRevision: 0,
      visibleTrees: () {
        visibleTreesBuildCount++;
        return [LinagoraSidebarVisibleTree(roots: [initialRoot])];
      },
    );

    final cachedOverflow = projection.resolveHorizontalOverflow(
      layoutRevision: 0,
      visibleTrees: () => throw StateError(
        'Visible trees must not be rebuilt for the same revision',
      ),
    );

    final updatedRoot = _deeplyNestedTree(depth: 10);
    final updatedOverflow = projection.resolveHorizontalOverflow(
      layoutRevision: 1,
      visibleTrees: () {
        visibleTreesBuildCount++;
        return [LinagoraSidebarVisibleTree(roots: [updatedRoot])];
      },
    );

    expect(
      initialOverflow,
      layoutPolicy.indent * 9 - layoutPolicy.maxInlineIndent,
    );
    expect(cachedOverflow, initialOverflow);
    expect(
      updatedOverflow,
      layoutPolicy.indent * 10 - layoutPolicy.maxInlineIndent,
    );
    expect(visibleTreesBuildCount, 2);
  });
}

const _adapter = LinagoraSidebarTreeAdapter<_TreeNode>(
  childrenOf: _childrenOf,
  idOf: _idOf,
  isExpanded: _isExpanded,
);

Iterable<_TreeNode> _childrenOf(_TreeNode node) => node.children;

Object _idOf(_TreeNode node) => node.id;

bool _isExpanded(_TreeNode node) => true;

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
  _TreeNode(this.id, {List<_TreeNode>? children}) : children = children ?? [];

  final String id;
  final List<_TreeNode> children;
}
