import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_item_action_scope.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';

/// A compact group of actions for a sidebar item's trailing slot.
///
/// The group owns the shared activity scope. While a menu or popover is open,
/// it keeps only that trigger visible without keeping the row hovered.
@immutable
class LinagoraSidebarItemActionEntry {
  const LinagoraSidebarItemActionEntry({
    required this.id,
    required this.child,
  });

  /// Stable identifier used to preserve action state when actions reorder.
  final Object id;

  final Widget child;
}

class LinagoraSidebarItemActions extends StatefulWidget {
  const LinagoraSidebarItemActions({
    super.key,
    required this.actions,
    this.style,
  });

  /// Stable action entries. Their IDs must be unique within this group.
  final List<LinagoraSidebarItemActionEntry> actions;
  final LinagoraSidebarStyle? style;

  @override
  State<LinagoraSidebarItemActions> createState() =>
      _LinagoraSidebarItemActionsState();
}

class _LinagoraSidebarItemActionsState extends State<LinagoraSidebarItemActions> {
  final LinagoraSidebarActionActivity _activity =
      LinagoraSidebarActionActivity();
  final Map<Object, Object> _actionSlotsById = <Object, Object>{};

  @override
  void initState() {
    super.initState();
    _syncActionSlots();
  }

  @override
  void didUpdateWidget(covariant LinagoraSidebarItemActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncActionSlots();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? LinagoraSidebarStyle.of(context);
    final rowActivity = LinagoraSidebarItemActionScope.maybeOf(context);
    final activity = rowActivity ?? _activity;
    final entries = widget.actions;
    final row = ListenableBuilder(
      listenable: activity,
      builder: (context, child) {
        final activeAction = activity.activeAction;
        final showOnlyActive = activity.isActive && activeAction != null;
        final actions = <Widget>[
          for (final entry in entries)
            _actionSlot(entry, activeAction, showOnlyActive),
        ];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < actions.length; index++) ...[
              if (index > 0) SizedBox(width: style.itemSpacing),
              actions[index],
            ],
          ],
        );
      },
    );

    // A sidebar item already owns the activity that controls its trailing
    // visibility. Outside an item, the group remains independently reusable.
    if (LinagoraSidebarItemActionScope.maybeOf(context) != null) return row;
    return LinagoraSidebarItemActionScope(activity: _activity, child: row);
  }

  Widget _actionSlot(
    LinagoraSidebarItemActionEntry entry,
    Object? activeAction,
    bool showOnlyActive,
  ) {
    final slot = _actionSlotsById[entry.id]!;
    final isHidden =
        showOnlyActive && !identical(slot, activeAction);
    return KeyedSubtree(
      key: ValueKey(slot),
      child: ExcludeSemantics(
        excluding: isHidden,
        child: IgnorePointer(
          ignoring: isHidden,
          child: Visibility(
            visible: !isHidden,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: LinagoraSidebarActionSlotScope(
              action: slot,
              child: entry.child,
            ),
          ),
        ),
      ),
    );
  }

  void _syncActionSlots() {
    final entries = widget.actions;
    final ids = <Object>{};
    for (final entry in entries) {
      if (!ids.add(entry.id)) {
        throw ArgumentError.value(
          entry.id,
          'actions',
          'A sidebar item action group needs unique action IDs',
        );
      }
    }
    _actionSlotsById.removeWhere((id, slot) => !ids.contains(id));
    for (final entry in entries) {
      _actionSlotsById.putIfAbsent(entry.id, Object.new);
    }
  }

  @override
  void dispose() {
    _activity.dispose();
    super.dispose();
  }
}
