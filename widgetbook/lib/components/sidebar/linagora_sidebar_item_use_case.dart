import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

part 'linagora_sidebar_item_preview_configuration.dart';
part 'linagora_sidebar_item_preview_hover_trailing.dart';

@widgetbook.UseCase(name: 'Default', type: LinagoraSidebarItem)
Widget linagoraSidebarItemUseCase(BuildContext context) {
  final state = _SidebarItemState.fromKnobs(context);
  final content = _SidebarItemContent.fromKnobs(context);
  final affordances = _SidebarItemAffordances.fromKnobs(
    context,
    hover: state.hover,
  );

  return switch (state.variant) {
    _SidebarItemVariant.primary => _primaryPreview(state, content, affordances),
  };
}

Widget _primaryPreview(
  _SidebarItemState state,
  _SidebarItemContent content,
  _SidebarItemAffordances affordances,
) {
  return SidebarPreviewSurface(
    width: state.width,
    child: _SidebarItemPreview(
      state: state,
      content: content,
      affordances: affordances,
    ),
  );
}

/// Interactive preview for supporting slots, generic drops, and anchor-aware
/// item actions. The values still come from knobs; this state only displays
/// the intent callbacks that a product would receive.
class _SidebarItemPreview extends StatefulWidget {
  const _SidebarItemPreview({
    required this.state,
    required this.content,
    required this.affordances,
  });

  final _SidebarItemState state;
  final _SidebarItemContent content;
  final _SidebarItemAffordances affordances;

  @override
  State<_SidebarItemPreview> createState() => _SidebarItemPreviewState();
}

class _SidebarItemPreviewState extends State<_SidebarItemPreview> {
  String? _event;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final content = widget.content;
    final item = LinagoraSidebarItem(
      label: content.label,
      icon: content.icon,
      supportingText: content.supportingText,
      supportingContent: content.supportingContent,
      active: state.active,
      hovered: state.hover,
      badgeLabel: content.badgeLabel,
      expanded: content.expanded,
      onExpandToggle: content.expanded == null ? null : _toggle,
      expandToggleLabel: content.expandToggleLabel,
      trailing: state.showAnchorAction
          ? LinagoraSidebarItemAction(
              semanticLabel: 'Show action anchor',
              onPressed: _showActionAnchor,
              child: const Icon(Icons.more_horiz),
            )
          : null,
      hoverTrailing: widget.affordances.hoverTrailing,
      enabled: state.enabled,
      onTap: _select,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.showDropTarget)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Draggable<_SidebarPreviewDropData>(
              data: _SidebarPreviewDropData('Preview message'),
              feedback: Material(
                color: Colors.transparent,
                child: Chip(label: Text('Preview message')),
              ),
              child: Chip(label: Text('Drag a message onto the row')),
            ),
          ),
        state.showDropTarget
            ? LinagoraSidebarItemDropTarget<_SidebarPreviewDropData>(
                onWillAcceptDrop: _willAcceptDrop,
                onDrop: _acceptDrop,
                child: item,
              )
            : item,
        if (_event != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_event!),
          ),
      ],
    );
  }

  void _toggle() => setState(() => _event = 'Chevron action pressed');

  void _select() => setState(() => _event = 'Row action pressed');

  bool _willAcceptDrop(
      LinagoraSidebarItemDropDetails<_SidebarPreviewDropData> details) {
    return details.data.label.isNotEmpty;
  }

  void _acceptDrop(
    LinagoraSidebarItemDropDetails<_SidebarPreviewDropData> details,
  ) {
    setState(() => _event = 'Dropped: ${details.data.label}');
  }

  Future<void> _showActionAnchor(LinagoraSidebarActionDetails details) async {
    setState(
      () =>
          _event = 'Action anchor: ${details.anchor.left.toStringAsFixed(0)}, '
              '${details.anchor.top.toStringAsFixed(0)}',
    );
  }
}

class _SidebarPreviewDropData {
  const _SidebarPreviewDropData(this.label);

  final String label;
}
