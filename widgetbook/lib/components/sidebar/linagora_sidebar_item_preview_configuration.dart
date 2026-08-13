part of 'linagora_sidebar_item_use_case.dart';

/// Knobs are registered while the use case builds, so a knob that only applies
/// under another one is registered only when that one is on. It then leaves
/// the panel entirely rather than sitting there doing nothing.
class _SidebarItemState {
  const _SidebarItemState({
    required this.variant,
    required this.active,
    required this.hover,
    required this.enabled,
    required this.width,
  });

  final _SidebarItemVariant variant;
  final bool active;

  /// Forces the visual hover state in the preview.
  final bool hover;

  final bool enabled;

  /// Caps the row. The Figma reference is 204px wide.
  final double width;

  factory _SidebarItemState.fromKnobs(BuildContext context) {
    return _SidebarItemState(
      variant: context.knobs.object.dropdown<_SidebarItemVariant>(
        label: 'variant',
        options: _SidebarItemVariant.values,
        initialOption: _SidebarItemVariant.primary,
        labelBuilder: (variant) => variant.label,
      ),
      active: context.knobs.boolean(label: 'active', initialValue: false),
      hover: context.knobs.boolean(label: 'hover', initialValue: false),
      enabled: context.knobs.boolean(label: 'enabled', initialValue: true),
      width: SidebarPreviewSurface.widthKnob(context),
    );
  }
}

class _SidebarItemContent {
  const _SidebarItemContent({
    required this.label,
    required this.icon,
    required this.badgeLabel,
    required this.expanded,
  });

  final String label;

  /// Null when the leading icon is switched off.
  final IconData? icon;

  /// Null when the badge is switched off.
  final String? badgeLabel;

  /// Null when the chevron is switched off, which is also what tells the row
  /// it is a leaf rather than a tree node.
  final bool? expanded;

  factory _SidebarItemContent.fromKnobs(BuildContext context) {
    final label = context.knobs.string(label: 'label', initialValue: 'Inbox');

    final showLeftIcon = context.knobs.boolean(
      label: 'Show left icon',
      initialValue: true,
    );
    final icon = showLeftIcon
        ? context.knobs.object
              .dropdown<_SidebarItemIcon>(
                label: 'Swap icon',
                options: _SidebarItemIcon.values,
                initialOption: _SidebarItemIcon.inbox,
                labelBuilder: (icon) => icon.label,
              )
              .icon
        : null;

    final showChevron = context.knobs.boolean(
      label: 'Show chevron',
      initialValue: false,
    );
    final expanded = showChevron
        ? context.knobs.boolean(label: 'expanded', initialValue: true)
        : null;

    final showBadge = context.knobs.boolean(label: 'badge', initialValue: true);
    final badgeLabel = showBadge
        ? context.knobs.string(label: 'badge label', initialValue: '999+')
        : null;

    return _SidebarItemContent(
      label: label,
      icon: icon,
      badgeLabel: badgeLabel,
      expanded: expanded,
    );
  }

  String? get expandToggleLabel {
    final expanded = this.expanded;
    if (expanded == null) return null;
    return expanded ? 'Collapse' : 'Expand';
  }
}

/// The controls revealed on hover, so their knobs only exist while `hover` is
/// on.
class _SidebarItemAffordances {
  const _SidebarItemAffordances({
    required this.showIcon,
    required this.showButton,
    required this.buttonLabel,
  });

  const _SidebarItemAffordances.none()
    : showIcon = false,
      showButton = false,
      buttonLabel = '';

  final bool showIcon;
  final bool showButton;
  final String buttonLabel;

  factory _SidebarItemAffordances.fromKnobs(
    BuildContext context, {
    required bool hover,
  }) {
    if (!hover) return const _SidebarItemAffordances.none();

    final showIcon = context.knobs.boolean(
      label: 'Show icon',
      initialValue: false,
    );
    final showButton = context.knobs.boolean(
      label: 'Show button',
      initialValue: false,
    );
    final buttonLabel = showButton
        ? context.knobs.string(label: 'button label', initialValue: 'Clean')
        : '';

    return _SidebarItemAffordances(
      showIcon: showIcon,
      showButton: showButton,
      buttonLabel: buttonLabel,
    );
  }

  Widget? get hoverTrailing {
    if (isEmpty) return null;
    return _SidebarItemHoverTrailing(
      showIcon: showIcon,
      showButton: showButton,
      buttonLabel: buttonLabel,
    );
  }

  bool get isEmpty => !showIcon && !showButton;
}

enum _SidebarItemVariant {
  primary('primary');

  const _SidebarItemVariant(this.label);

  final String label;
}

enum _SidebarItemIcon {
  inbox('inbox_16_noborder', Icons.inbox_outlined),
  starred('starred_16_noborder', Icons.star_border),
  actionRequired('action_required_16_noborder', Icons.schedule_outlined),
  sent('sent_16_noborder', Icons.send_outlined),
  spam('spam_16_noborder', Icons.report_outlined);

  const _SidebarItemIcon(this.label, this.icon);

  final String label;
  final IconData icon;
}
