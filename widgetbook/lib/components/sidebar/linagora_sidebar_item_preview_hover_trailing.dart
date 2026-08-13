part of 'linagora_sidebar_item_use_case.dart';

/// The controls a row reveals on hover: the action button, then the overflow
/// icon.
class _SidebarItemHoverTrailing extends StatelessWidget {
  const _SidebarItemHoverTrailing({
    required this.showIcon,
    required this.showButton,
    required this.buttonLabel,
  });

  static const double _gap = 4;

  final bool showIcon;
  final bool showButton;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    final style = LinagoraSidebarStyle.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: _gap,
      children: [
        if (showButton) _SidebarItemAction(label: buttonLabel, style: style),
        if (showIcon)
          LinagoraIconButton(
            icon: Icons.more_vert,
            iconSize: 16,
            color: style.trailingForeground,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // The defaults suppress the overlay and squash the box to 24x16;
            // both are needed for a circular ripple.
            visualDensity: VisualDensity.standard,
            overlayColor: style.selectedBackground,
            onPressed: () {},
          ),
      ],
    );
  }
}

/// A row action at the shared button's smallest size. [LinagoraButton] takes
/// its foreground from the ambient scheme, so the muted colour arrives that
/// way rather than as a parameter.
class _SidebarItemAction extends StatelessWidget {
  const _SidebarItemAction({required this.label, required this.style});

  /// Ceiling for the action, so a long label ellipsises inside the button
  /// rather than pushing the row's own label out of the way.
  static const double maxWidth = 96;

  final String label;
  final LinagoraSidebarStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      child: Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: style.trailingForeground,
          ),
        ),
        child: LinagoraButton(
          label: label,
          variant: LinagoraButtonVariant.text,
          size: LinagoraButtonSize.xs,
          onPressed: () {},
        ),
      ),
    );
  }
}
