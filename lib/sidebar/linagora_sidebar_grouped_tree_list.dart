import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_sub_item.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_tree_flattener.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_tree_list.dart';

/// A product-owned category row followed by one expanded tree of items.
///
/// [header] remains a widget so products can map their own category model and
/// action. This class only owns the common list flattening, ID namespacing and
/// indentation of each category's descendants.
class LinagoraSidebarTreeGroup<T> {
  const LinagoraSidebarTreeGroup({
    required this.id,
    required this.header,
    required this.roots,
    this.expanded = true,
    this.initialDepth = 1,
  }) : assert(initialDepth >= 0, 'A sidebar tree depth cannot be negative');

  final Object id;
  final Widget header;
  final Iterable<T> roots;
  final bool expanded;
  final int initialDepth;
}

/// Virtualized sidebar tree list with product-defined category headers.
///
/// Use it when several independent trees share one sidebar section. It keeps
/// category IDs distinct from item IDs and preserves the stable child-key
/// behaviour of [LinagoraSidebarSliverTreeList]. It virtualizes rendered rows,
/// while flattening product groups on each build; memoize unchanged groups in
/// the application when rebuilding a very large tree frequently.
class LinagoraSidebarSliverGroupedTreeList<T> extends StatelessWidget {
  LinagoraSidebarSliverGroupedTreeList({
    super.key,
    required this.groups,
    required this.adapter,
    required this.itemBuilder,
    this.indent = LinagoraSidebarSubItem.defaultIndent,
    this.maxIndent = LinagoraSidebarTreeList.defaultMaxIndent,
  }) : assert(indent >= 0, 'A sidebar tree list indent cannot be negative'),
       assert(
         maxIndent >= 0,
         'A sidebar tree list maximum indent cannot be negative',
       ),
       assert(
         _hasUniqueGroupIds(groups),
         'A sidebar grouped tree list needs unique group IDs',
       );

  final List<LinagoraSidebarTreeGroup<T>> groups;
  final LinagoraSidebarTreeAdapter<T> adapter;
  final LinagoraSidebarTreeListItemBuilder<T> itemBuilder;
  final double indent;
  final double maxIndent;

  @override
  Widget build(BuildContext context) {
    _requireUniqueGroupIds(groups);
    final rows = _buildRows();
    final indexById = _indexRows(rows);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildRow(context, rows[index]),
        childCount: rows.length,
        findChildIndexCallback: (key) {
          if (key is! ValueKey<Object>) return null;
          return indexById[key.value];
        },
      ),
    );
  }

  List<_LinagoraSidebarGroupedTreeRow<T>> _buildRows() {
    final rows = <_LinagoraSidebarGroupedTreeRow<T>>[];

    for (final group in groups) {
      rows.add(_LinagoraSidebarGroupedTreeRow.header(
        id: ('sidebar_group_header', group.id),
        header: group.header,
      ));
      if (!group.expanded) continue;

      final entries = LinagoraSidebarTreeFlattener.flatten(
        roots: group.roots,
        adapter: adapter,
        initialDepth: group.initialDepth,
        namespaceId: (id) => ('sidebar_group_entry', group.id, id),
      );
      rows.addAll(entries.map(_LinagoraSidebarGroupedTreeRow.item));
    }

    return rows;
  }

  Widget _buildRow(
    BuildContext context,
    _LinagoraSidebarGroupedTreeRow<T> row,
  ) {
    final header = row.header;
    if (header != null) {
      return KeyedSubtree(key: ValueKey<Object>(row.id), child: header);
    }

    final entry = row.entry!;
    final item = itemBuilder(context, entry);
    return LinagoraSidebarSubItem(
      key: ValueKey<Object>(row.id),
      depth: entry.depth,
      indent: indent,
      maxIndent: maxIndent,
      child: item,
    );
  }

  static bool _hasUniqueGroupIds<T>(List<LinagoraSidebarTreeGroup<T>> groups) {
    final ids = <Object>{};
    return groups.every((group) => ids.add(group.id));
  }

  static void _requireUniqueGroupIds<T>(
    List<LinagoraSidebarTreeGroup<T>> groups,
  ) {
    final ids = <Object>{};
    for (final group in groups) {
      if (!ids.add(group.id)) {
        throw ArgumentError.value(
          group.id,
          'groups',
          'A sidebar grouped tree list needs unique group IDs',
        );
      }
    }
  }

  static Map<Object, int> _indexRows<T>(
    List<_LinagoraSidebarGroupedTreeRow<T>> rows,
  ) {
    final indexById = <Object, int>{};
    for (var index = 0; index < rows.length; index++) {
      final id = rows[index].id;
      if (indexById.containsKey(id)) {
        throw ArgumentError.value(
          id,
          'groups',
          'A sidebar grouped tree list needs unique visible row IDs',
        );
      }
      indexById[id] = index;
    }
    return indexById;
  }
}

class _LinagoraSidebarGroupedTreeRow<T> {
  const _LinagoraSidebarGroupedTreeRow.header({
    required this.id,
    required Widget this.header,
  }) : entry = null;

  _LinagoraSidebarGroupedTreeRow.item(
    LinagoraSidebarTreeListEntry<T> this.entry,
  ) : id = entry.id,
      header = null;

  final Object id;
  final Widget? header;
  final LinagoraSidebarTreeListEntry<T>? entry;
}
