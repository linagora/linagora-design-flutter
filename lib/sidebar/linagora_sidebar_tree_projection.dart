import 'package:linagora_design_flutter/sidebar/linagora_sidebar_tree_layout_policy.dart';

/// Caches the derived horizontal layout for a sidebar's visible trees.
///
/// The host supplies a revision that changes only when tree shape or expansion
/// changes. Count, selection, and other row updates can then rebuild without
/// traversing every visible node to recalculate the horizontal viewport width.
class LinagoraSidebarTreeProjection<T extends Object> {
  LinagoraSidebarTreeProjection({
    required LinagoraSidebarTreeLayoutPolicy<T> layoutPolicy,
  }) : _layoutPolicy = layoutPolicy;

  final LinagoraSidebarTreeLayoutPolicy<T> _layoutPolicy;

  int? _resolvedLayoutRevision;
  double? _horizontalOverflow;

  double resolveHorizontalOverflow({
    required int layoutRevision,
    required Iterable<LinagoraSidebarVisibleTree<T>> Function() visibleTrees,
  }) {
    assert(
      layoutRevision >= 0,
      'A sidebar tree layout revision cannot be negative',
    );

    if (_resolvedLayoutRevision == layoutRevision) {
      return _horizontalOverflow!;
    }

    final horizontalOverflow = _layoutPolicy.horizontalOverflowFor(
      visibleTrees(),
    );
    _resolvedLayoutRevision = layoutRevision;
    _horizontalOverflow = horizontalOverflow;

    return horizontalOverflow;
  }
}
