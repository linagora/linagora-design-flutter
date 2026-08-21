import 'dart:collection';

import 'package:linagora_design_flutter/sidebar/linagora_sidebar_sub_item.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_tree_flattener.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_tree_list.dart';

/// One product-owned tree visible in a sidebar and the depth at which it starts.
///
/// Use [initialDepth] for trees displayed beneath a category row that is not
/// itself part of the tree.
class LinagoraSidebarVisibleTree<T extends Object> {
  const LinagoraSidebarVisibleTree({
    required this.roots,
    this.initialDepth = 0,
  }) : assert(initialDepth >= 0, 'A sidebar tree depth cannot be negative');

  final Iterable<T> roots;
  final int initialDepth;
}

/// Calculates the horizontal overflow required by expanded sidebar trees.
///
/// The layout policy uses the same [adapter] contract as
/// [LinagoraSidebarTreeFlattener], keeping expansion semantics consistent
/// between row construction and overflow measurement. It does not own product
/// tree state or widgets.
class LinagoraSidebarTreeLayoutPolicy<T extends Object> {
  const LinagoraSidebarTreeLayoutPolicy({
    required this.adapter,
    this.indent = LinagoraSidebarSubItem.defaultIndent,
    this.maxInlineIndent = LinagoraSidebarTreeList.defaultMaxIndent,
  }) : assert(indent > 0, 'A sidebar tree indent must be positive'),
       assert(
         maxInlineIndent >= 0,
         'A sidebar tree maximum inline indent cannot be negative',
       );

  final LinagoraSidebarTreeAdapter<T> adapter;
  final double indent;
  final double maxInlineIndent;

  /// The width required beyond the inline sidebar width for visible indents.
  double horizontalOverflowFor(Iterable<LinagoraSidebarVisibleTree<T>> trees) {
    final deepestIndent = maximumVisibleDepth(trees) * indent;

    return deepestIndent > maxInlineIndent
        ? deepestIndent - maxInlineIndent
        : 0;
  }

  /// Returns the greatest depth exposed by expanded tree nodes.
  ///
  /// The traversal is iterative, so arbitrary product-tree depth cannot
  /// overflow the Dart call stack. The active-path set skips malformed circular
  /// references while still measuring a shared node in another valid branch.
  int maximumVisibleDepth(Iterable<LinagoraSidebarVisibleTree<T>> trees) {
    final activeNodes = HashSet<T>.identity();
    final pendingNodes = _initialTraversalSteps(trees);

    return _measureMaximumDepth(pendingNodes, activeNodes);
  }

  List<_LinagoraSidebarTreeTraversalStep<T>> _initialTraversalSteps(
    Iterable<LinagoraSidebarVisibleTree<T>> trees,
  ) => trees.expand(_entryStepsForTree).toList();

  Iterable<_LinagoraSidebarTreeTraversalStep<T>> _entryStepsForTree(
    LinagoraSidebarVisibleTree<T> tree,
  ) => tree.roots.map(
    (root) => _LinagoraSidebarTreeTraversalStep.enter(
      root,
      tree.initialDepth,
    ),
  );

  int _measureMaximumDepth(
    List<_LinagoraSidebarTreeTraversalStep<T>> pendingNodes,
    Set<T> activeNodes,
  ) {
    var maximumDepth = 0;

    while (pendingNodes.isNotEmpty) {
      final step = pendingNodes.removeLast();
      final node = step.node;
      if (step.isExit) {
        activeNodes.remove(node);
        continue;
      }

      if (!activeNodes.add(node)) continue;

      if (step.depth > maximumDepth) maximumDepth = step.depth;

      final children = _visibleChildrenFor(node);
      if (children == null) {
        activeNodes.remove(node);
        continue;
      }

      pendingNodes.add(_LinagoraSidebarTreeTraversalStep.exit(node));
      _enqueueChildren(pendingNodes, children, step.depth + 1);
    }

    return maximumDepth;
  }

  Iterable<T>? _visibleChildrenFor(T node) {
    if (!adapter.isExpanded(node)) return null;
    return adapter.childrenOf(node);
  }

  void _enqueueChildren(
    List<_LinagoraSidebarTreeTraversalStep<T>> pendingNodes,
    Iterable<T> children,
    int depth,
  ) {
    final siblings = children.toList(growable: false);
    for (var index = siblings.length - 1; index >= 0; index--) {
      pendingNodes.add(_LinagoraSidebarTreeTraversalStep.enter(
        siblings[index],
        depth,
      ));
    }
  }
}

class _LinagoraSidebarTreeTraversalStep<T extends Object> {
  const _LinagoraSidebarTreeTraversalStep.enter(this.node, this.depth)
      : isExit = false;

  const _LinagoraSidebarTreeTraversalStep.exit(this.node)
      : depth = 0,
        isExit = true;

  final T node;
  final int depth;
  final bool isExit;
}
