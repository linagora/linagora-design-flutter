part of 'linagora_sidebar_item.dart';

class _LinagoraSidebarItemContent extends StatelessWidget {
  const _LinagoraSidebarItemContent({
    required this.item,
    required this.style,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isInteractive,
    required this.trailing,
    required this.onHoverChanged,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isInteractive;
  final Widget? trailing;
  /// Null on platforms that do not hover.
  final ValueChanged<bool>? onHoverChanged;

  /// Dims every slot at once. Colouring them one by one let the chevron and
  /// the badge keep full strength while the label faded.
  Widget _disable(Widget child) {
    if (item.enabled) return child;
    return Opacity(opacity: style.disabledOpacity, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(style.itemBorderRadius);

    return Semantics(
      // Text and InkWell already publish the label and button role.
      selected: item.active,
      // Expanded belongs to the row: a decorative chevron has no semantics,
      // while a tappable one is a separate control. Leaves have no state.
      expanded: item.expanded,
      child: Material(
        color: backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: isInteractive ? item.onTap : null,
          onSecondaryTapDown: item.enabled ? item.onSecondaryTapDown : null,
          // Fires only for pointer devices, and only where the platform
          // hovers at all.
          onHover: item.enabled ? onHoverChanged : null,
          focusNode: item.focusNode,
          borderRadius: borderRadius,
          mouseCursor: isInteractive
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          // The row paints its own hover fill. Splash and highlight stay on
          // every platform — they are the touch feedback on mobile.
          hoverColor: Colors.transparent,
          child: _disable(
            _SidebarItemRow(
              item: item,
              style: style,
              foregroundColor: foregroundColor,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItemRow extends StatelessWidget {
  const _SidebarItemRow({
    required this.item,
    required this.style,
    required this.foregroundColor,
    required this.trailing,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;
  final Color foregroundColor;
  final Widget? trailing;

  bool get _hasLeading => item.leading != null || item.icon != null;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // Minimum, not fixed: the row grows with the text scale.
      constraints: BoxConstraints(minHeight: style.itemMinHeight),
      child: Padding(
        // Indent content only, preserving the full-width row background.
        padding: EdgeInsetsDirectional.only(
          start: style.itemHorizontalPadding + LinagoraSidebarIndent.of(context),
          end: style.itemHorizontalPadding,
        ),
        child: Row(
          children: [
            if (_hasLeading) ...[
              _SidebarItemLeading(
                leading: item.leading,
                icon: item.icon,
                color: foregroundColor,
                size: style.itemIconSize,
              ),
              SizedBox(width: style.itemSpacing),
            ],
            Expanded(
              child: _SidebarItemLabel(
                item: item,
                style: style,
                foregroundColor: foregroundColor,
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: style.itemSpacing),
              _SidebarItemTrailing(
                color: style.trailingForeground,
                iconSize: style.itemIconSize,
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The label and, for a tree node, its chevron. The text takes only the width
/// it needs so the chevron stays beside it while `trailing` keeps the far
/// right.
class _SidebarItemLabel extends StatelessWidget {
  const _SidebarItemLabel({
    required this.item,
    required this.style,
    required this.foregroundColor,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final expanded = item.expanded;

    return Row(
      children: [
        Flexible(
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: LinagoraTextTheme.material().bodyMedium?.copyWith(
              color: foregroundColor,
            ),
          ),
        ),
        if (expanded != null) ...[
          // A tappable chevron grows its box to a usable touch target, so the
          // gap shrinks by the overhang to keep the visual spacing at
          // [itemSpacing]. Clamped: a style with a spacing smaller than the
          // overhang would otherwise ask for a negative width.
          SizedBox(
            width: math.max(
              0,
              style.itemSpacing - _SidebarItemChevron.overhang(item, style),
            ),
          ),
          _SidebarItemChevron(
            expanded: expanded,
            color: style.trailingForeground,
            size: style.chevronSize,
            onToggle: item.enabled ? item.onExpandToggle : null,
            semanticLabel: item.expandToggleLabel,
          ),
        ],
      ],
    );
  }
}

class _SidebarItemLeading extends StatelessWidget {
  const _SidebarItemLeading({
    required this.leading,
    required this.icon,
    required this.color,
    required this.size,
  });

  final Widget? leading;
  final IconData? icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: leading ?? Icon(icon, size: size, color: color),
    );
  }
}

class _SidebarItemChevron extends StatelessWidget {
  const _SidebarItemChevron({
    required this.expanded,
    required this.color,
    required this.size,
    required this.onToggle,
    required this.semanticLabel,
  });

  /// Touch target for the tappable chevron. The glyph stays [size]; this is
  /// the box around it. Kept under the row height so it cannot stretch a row.
  static const double _tapTarget = 24;

  /// How far a tappable chevron's box extends past its glyph on each side.
  static double overhang(LinagoraSidebarItem item, LinagoraSidebarStyle style) {
    if (item.onExpandToggle == null || !item.enabled) return 0;
    return (_tapTarget - style.chevronSize) / 2;
  }

  final bool expanded;
  final Color color;
  final double size;
  final VoidCallback? onToggle;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
      size: size,
      color: color,
    );
    if (onToggle == null) return icon;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(
        onTap: onToggle,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: _tapTarget,
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class _SidebarItemTrailing extends StatelessWidget {
  const _SidebarItemTrailing({
    required this.color,
    required this.iconSize,
    required this.child,
  });

  final Color color;
  final double iconSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: LinagoraTextTheme.material().labelSmall?.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(color: color, size: iconSize),
        child: child,
      ),
    );
  }
}
