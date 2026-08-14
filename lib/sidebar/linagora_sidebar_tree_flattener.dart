import 'package:linagora_design_flutter/sidebar/linagora_sidebar_tree_list.dart';

/// Returns the children of a product-owned tree node.
typedef LinagoraSidebarTreeChildren<T> = Iterable<T>? Function(T node);

/// Returns a stable product-owned identifier for a tree node.
///
/// IDs must be unique across one traversal. Reusing an ID — including through
/// a cycle — is rejected so keyed sidebar rows cannot silently lose state.
typedef LinagoraSidebarTreeNodeId<T> = Object Function(T node);

/// Decides whether a product-owned tree node exposes its descendants.
typedef LinagoraSidebarTreeNodeExpanded<T> = bool Function(T node);

/// Maps a product-owned ID into a namespace that is unique in one visible list.
typedef LinagoraSidebarTreeIdMapper = Object Function(Object id);

/// How to read one product-owned tree node, declared once per node type.
class LinagoraSidebarTreeAdapter<T> {
  const LinagoraSidebarTreeAdapter({
    required this.childrenOf,
    required this.idOf,
    required this.isExpanded,
  });

  final LinagoraSidebarTreeChildren<T> childrenOf;
  final LinagoraSidebarTreeNodeId<T> idOf;
  final LinagoraSidebarTreeNodeExpanded<T> isExpanded;
}

/// Converts a product-owned expanded tree into generic sidebar list entries.
///
/// The design system takes an adapter instead of a tree model: applications
/// retain their own state, hierarchy, IDs and expansion policy.
abstract final class LinagoraSidebarTreeFlattener {
  /// Walks [roots] depth-first, keeping only nodes an expanded ancestor
  /// reveals.
  ///
  /// [initialDepth] indents a whole tree, and [namespaceId] keeps IDs unique
  /// when several trees share one visible list.
  static List<LinagoraSidebarTreeListEntry<T>> flatten<T>({
    required Iterable<T> roots,
    required LinagoraSidebarTreeAdapter<T> adapter,
    int initialDepth = 0,
    LinagoraSidebarTreeIdMapper? namespaceId,
  }) {
    assert(initialDepth >= 0, 'A sidebar tree depth cannot be negative');

    return _LinagoraSidebarTreeWalk<T>(adapter, namespaceId).run(
      roots,
      initialDepth,
    );
  }
}

/// One depth-first traversal, held together so the walk state — the output,
/// the claimed IDs and the pending stack — never leaks into [flatten].
///
/// The stack replaces recursion: a product tree is only bounded by its own
/// data, and a deep one must not overflow the Dart stack.
class _LinagoraSidebarTreeWalk<T> {
  _LinagoraSidebarTreeWalk(this._adapter, this._namespaceId);

  final LinagoraSidebarTreeAdapter<T> _adapter;
  final LinagoraSidebarTreeIdMapper? _namespaceId;

  final List<LinagoraSidebarTreeListEntry<T>> _entries = [];
  final Set<Object> _visibleIds = {};
  final List<_LinagoraSidebarPendingTreeNode<T>> _pending = [];

  List<LinagoraSidebarTreeListEntry<T>> run(
    Iterable<T> roots,
    int initialDepth,
  ) {
    _pushLevel(roots, initialDepth);
    while (_pending.isNotEmpty) {
      _visit(_pending.removeLast());
    }
    return _entries;
  }

  void _visit(_LinagoraSidebarPendingTreeNode<T> node) {
    _entries.add(
      LinagoraSidebarTreeListEntry<T>(
        id: _claimId(node.data),
        data: node.data,
        depth: node.depth,
      ),
    );
    _pushLevel(_revealedChildren(node.data), node.depth + 1);
  }

  /// Stacks one sibling level back to front, so popping walks it front to back.
  void _pushLevel(Iterable<T> nodes, int depth) {
    final level = nodes.toList(growable: false);
    for (var index = level.length - 1; index >= 0; index--) {
      _pending.add(_LinagoraSidebarPendingTreeNode(level[index], depth));
    }
  }

  /// The namespaced ID of [data], rejecting one already taken by a visible row.
  Object _claimId(T data) {
    final nodeId = _adapter.idOf(data);
    final id = _namespaceId?.call(nodeId) ?? nodeId;
    if (!_visibleIds.add(id)) {
      throw ArgumentError.value(
        id,
        'id',
        'A sidebar tree needs unique IDs and cannot contain a visible cycle',
      );
    }
    return id;
  }

  /// The children [data] actually reveals: none while it is collapsed, and
  /// none when the product exposes no collection for it.
  Iterable<T> _revealedChildren(T data) {
    if (!_adapter.isExpanded(data)) return const Iterable.empty();
    return _adapter.childrenOf(data) ?? const Iterable.empty();
  }
}

class _LinagoraSidebarPendingTreeNode<T> {
  const _LinagoraSidebarPendingTreeNode(this.data, this.depth);

  final T data;
  final int depth;
}
