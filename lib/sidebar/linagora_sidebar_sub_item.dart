import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_indent.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// Indents one [child] below a sidebar folder.
///
/// The indentation is published through [LinagoraSidebarIndent] rather than
/// applied as padding, so the child row keeps the full sidebar width and only
/// its content moves. Nesting accumulates: a sub-item inside another sub-item
/// adds to the indentation already in scope.
///
/// Only a row that reads [LinagoraSidebarIndent] moves — [LinagoraSidebarItem]
/// does. A child that ignores it, such as a bare `Text` or a product's own row
/// widget, renders flush against the sidebar edge; read
/// [LinagoraSidebarIndent.of] in that row and inset its content the same way.
///
/// [LinagoraSidebarTreeList] applies this to its entries already, so reach for
/// it directly only in a custom tree layout. Icons remain the child item's
/// responsibility, so hidden product icons can be enabled later with no
/// tree-layout change.
class LinagoraSidebarSubItem extends StatelessWidget {
  static const double defaultIndent = LinagoraSpacing.base;

  const LinagoraSidebarSubItem({
    super.key,
    required this.child,
    this.depth = 1,
    this.indent = defaultIndent,
    this.maxIndent,
  }) : assert(depth > 0, 'A sidebar sub-item must have a positive depth'),
       assert(indent >= 0, 'A sidebar sub-item indent cannot be negative'),
       assert(
         maxIndent == null || maxIndent >= 0,
         'A sidebar sub-item maximum indent cannot be negative',
       );

  final Widget child;

  /// How many levels to indent by at once.
  ///
  /// Leave it at `1` when a custom tree is built by nesting: each level wraps
  /// the one below it, so the levels already add up.
  ///
  /// Set it when the tree is *flattened* into a `ListView.builder`, where
  /// every row is a sibling and carries its own level. Prefer that shape for a
  /// mailbox with many folders because only visible rows are built.
  ///
  /// Do not combine the two — a `depth` above `1` inside a nested tree indents
  /// on top of the levels already in scope.
  final int depth;

  /// Horizontal space added per level of [depth].
  final double indent;

  /// Caps the total accumulated indentation when supplied.
  ///
  /// Use it for a tree whose depth can grow without bound, so a narrow sidebar
  /// keeps enough room for every row's icon and label.
  final double? maxIndent;

  @override
  Widget build(BuildContext context) {
    final accumulatedIndent =
        LinagoraSidebarIndent.of(context) + depth * indent;
    return LinagoraSidebarIndent(
      indent: maxIndent == null
          ? accumulatedIndent
          : math.min(accumulatedIndent, maxIndent!),
      child: child,
    );
  }
}
