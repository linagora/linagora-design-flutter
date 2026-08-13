import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_sub_item.dart';

/// Builds one row from a visible [LinagoraSidebarTreeListEntry].
typedef LinagoraSidebarTreeListItemBuilder<T> = Widget Function(
  BuildContext context,
  LinagoraSidebarTreeListEntry<T> entry,
);

/// Data for one visible row in [LinagoraSidebarTreeList].
///
/// The application flattens its folder hierarchy and omits descendants of
/// collapsed folders before passing entries to the list. [id] must be unique
/// within that visible list so Flutter can retain the row's element when a
/// sibling is inserted, removed, or reordered.
class LinagoraSidebarTreeListEntry<T> {
  const LinagoraSidebarTreeListEntry({
    required this.id,
    required this.data,
    this.depth = 0,
  }) : assert(depth >= 0, 'A sidebar tree list depth cannot be negative');

  /// Stable application identifier for this row.
  final Object id;

  /// Product data consumed by [LinagoraSidebarTreeList.itemBuilder].
  final T data;

  /// Zero for a root row, then one for each nesting level below it.
  final int depth;
}

/// A virtualized, flattened sidebar tree for production-sized folder lists.
///
/// This widget deliberately does not own expansion state or traverse a node
/// hierarchy. The product owns its expanded folder IDs, derives [entries] from
/// them, and rebuilds the list after a disclosure toggle. As a result the
/// state survives route changes, tabs, and restoration when the product
/// persists it, while [ListView.builder] creates only rows near the viewport.
///
/// Give this widget a [PageStorageKey] to restore its scroll offset while its
/// surrounding [PageStorage] bucket remains alive, or provide [controller]
/// when the product needs to own and restore the offset itself. It must be in
/// a bounded vertical region, for example an [Expanded] or [SizedBox].
class LinagoraSidebarTreeList<T> extends StatelessWidget {
  /// The maximum content indentation used by default for deep folder trees.
  static const double defaultMaxIndent =
      LinagoraSidebarSubItem.defaultIndent * 8;

  LinagoraSidebarTreeList({
    super.key,
    required this.entries,
    required this.itemBuilder,
    this.controller,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.primary,
    this.cacheExtent,
    this.indent = LinagoraSidebarSubItem.defaultIndent,
    this.maxIndent = defaultMaxIndent,
  }) : assert(indent >= 0, 'A sidebar tree list indent cannot be negative'),
       assert(
         maxIndent >= 0,
         'A sidebar tree list maximum indent cannot be negative',
       ),
       assert(
         _hasUniqueEntryIds(entries),
         'A sidebar tree list needs unique entry IDs',
       );

  /// The already-visible tree rows, in their visual order.
  final List<LinagoraSidebarTreeListEntry<T>> entries;

  /// Builds the actual row, normally a [LinagoraSidebarItem].
  final LinagoraSidebarTreeListItemBuilder<T> itemBuilder;

  /// Lets the product read, restore, or programmatically move the list.
  final ScrollController? controller;

  final EdgeInsetsGeometry padding;

  final ScrollPhysics? physics;

  final bool? primary;

  final double? cacheExtent;

  /// Horizontal content indentation added for every [depth] level.
  final double indent;

  /// Maximum accumulated content indentation for a nested row.
  ///
  /// Folder protocols allow arbitrary depths, but a fixed-width sidebar must
  /// preserve enough room for row content. Increase this when the host sidebar
  /// is wider, lower it for a more compact hierarchy, or pass
  /// [double.infinity] when the host guarantees a bounded depth and wants
  /// every level to stay distinguishable.
  final double maxIndent;

  /// Maps a row key back to its position so the sliver can move an existing
  /// element instead of rebuilding it. It is created lazily when Flutter
  /// updates keyed children.
  late final Map<Object, int> _indexById = {
    for (var index = 0; index < entries.length; index++)
      entries[index].id: index,
  };

  @override
  Widget build(BuildContext context) {
    // [key] identifies this widget and must not be repeated on the list it
    // builds: a GlobalKey would then be claimed twice and throw. A
    // PageStorageKey still reaches the scroll position from up here.
    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      primary: primary,
      cacheExtent: cacheExtent,
      itemCount: entries.length,
      itemBuilder: _buildEntry,
      findChildIndexCallback: _findEntryIndex,
    );
  }

  /// Without this the sliver matches children by index alone, so inserting or
  /// removing one row rebuilds every row after it from scratch — losing hover,
  /// focus and any state a product row holds — even though each carries a
  /// stable key.
  int? _findEntryIndex(Key key) {
    if (key is! ValueKey<Object>) return null;
    return _indexById[key.value];
  }

  Widget _buildEntry(BuildContext context, int index) {
    final entry = entries[index];
    final row = itemBuilder(context, entry);
    final rowKey = ValueKey<Object>(entry.id);

    if (entry.depth == 0) {
      return KeyedSubtree(key: rowKey, child: row);
    }

    return LinagoraSidebarSubItem(
      key: rowKey,
      depth: entry.depth,
      indent: indent,
      maxIndent: maxIndent,
      child: row,
    );
  }

  static bool _hasUniqueEntryIds<T>(
    List<LinagoraSidebarTreeListEntry<T>> entries,
  ) {
    final ids = <Object>{};
    return entries.every((entry) => ids.add(entry.id));
  }
}
