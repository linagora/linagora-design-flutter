import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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
  return _SidebarPreviewSurface(
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

/// Stands in for the sidebar shell, so the translucent fills composite over a
/// realistic surface.
class _SidebarPreviewSurface extends StatelessWidget {
  const _SidebarPreviewSurface({required this.width, required this.child});

  /// Inset around the row, subtracted from the viewport to get the width the
  /// row can actually occupy.
  static const double padding = 16;

  /// Caps the row; the row itself fills whatever width it is given.
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ColoredBox(
      color: isDark ? const Color(0xFF272A31) : const Color(0xFFF3F6F9),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Align(
          alignment: Alignment.topLeft,
          // A cap rather than a fixed width, so a value wider than the
          // viewport simply fills it instead of overflowing.
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: child,
          ),
        ),
      ),
    );
  }
}
