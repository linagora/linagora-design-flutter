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
    child: LinagoraSidebarItem(
      label: content.label,
      icon: content.icon,
      active: state.active,
      hovered: state.hover,
      badgeLabel: content.badgeLabel,
      expanded: content.expanded,
      onExpandToggle: content.expanded == null ? null : () {},
      expandToggleLabel: content.expandToggleLabel,
      hoverTrailing: affordances.hoverTrailing,
      enabled: state.enabled,
      onTap: () {},
    ),
  );
}
