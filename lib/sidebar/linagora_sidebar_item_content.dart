part of 'linagora_sidebar_item.dart';

class _LinagoraSidebarItemContent extends StatelessWidget {
  const _LinagoraSidebarItemContent({
    required this.item,
    required this.style,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isInteractive,
    required this.hasActiveAction,
    required this.actionActivity,
    required this.suppressRowInkFeedback,
    required this.trailing,
    required this.onHoverChanged,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isInteractive;
  final bool hasActiveAction;
  final LinagoraSidebarActionActivity actionActivity;
  final bool suppressRowInkFeedback;
  final Widget? trailing;

  /// Null on platforms that do not hover.
  final _OnLinagoraSidebarItemHoverChanged? onHoverChanged;

  /// Dims every slot at once. Colouring them one by one let the chevron and
  /// the badge keep full strength while the label faded.
  Widget _disable(Widget child) {
    if (item.enabled) return child;
    return Opacity(opacity: style.disabledOpacity, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(style.itemBorderRadius);
    final suppressInkFeedback =
        hasActiveAction || suppressRowInkFeedback;

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
          onTap: isInteractive
              ? () {
                  // Trailing menu and popover actions begin their activity
                  // before this ancestor callback can run. Their press must
                  // never select the row beneath them.
                  if (!actionActivity.isActive) item.onTap?.call();
                }
              : null,
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
          // An item InkWell begins its splash on pointer-down, before a nested
          // trailing action can become active. Suppress that ancestor feedback
          // for rows that reveal actions, otherwise it briefly washes over the
          // entire item behind the action's own Material. Before an action
          // opens, focus keeps keyboard feedback on the row even when the
          // pointer is also hovering it. Once open, every row feedback state
          // stays transparent.
          splashColor: suppressInkFeedback ? Colors.transparent : null,
          highlightColor: suppressInkFeedback ? Colors.transparent : null,
          focusColor: hasActiveAction ? Colors.transparent : null,
          overlayColor: hasActiveAction
              ? const WidgetStatePropertyAll(Colors.transparent)
              : suppressRowInkFeedback
              ? WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.focused)
                      ? null
                      : Colors.transparent,
                )
              : null,
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

  bool get _hasExpandToggle =>
      item.onExpandToggle != null || item.onExpandTogglePressed != null;

  double get _expandControlOverhang {
    if (!_hasExpandToggle || !item.enabled) return 0;
    return LinagoraSidebarControl.overhang(style.chevronSize);
  }

  @override
  Widget build(BuildContext context) {
    final indent = LinagoraSidebarIndent.of(context);
    final offset = Directionality.of(context) == TextDirection.rtl
        ? -indent
        : indent;
    final expandControl = item.expanded == null
        ? null
        : _SidebarItemExpandControl(item: item, style: style);

    return ConstrainedBox(
      // Minimum, not fixed: the row grows with the text scale.
      constraints: BoxConstraints(minHeight: style.itemMinHeight),
      child: Padding(
        // Keep the row's layout width stable. A large tree indent is painted
        // inside this viewport instead of shrinking the row until it overflows.
        padding: EdgeInsetsDirectional.only(
          start: style.itemHorizontalPadding,
          end: style.itemHorizontalPadding,
        ),
        child: indent == 0
            ? _unindentedContent(expandControl)
            : _indentedContent(Offset(offset, 0), expandControl),
      ),
    );
  }

  Widget _unindentedContent(Widget? expandControl) {
    return Row(
      children: [
        if (_hasLeading) ...[
          _SidebarItemLeading(
            leading: item.leading,
            icon: item.icon,
            color: item.iconColor ?? foregroundColor,
            size: style.itemIconSize,
          ),
          SizedBox(width: style.itemSpacing),
        ],
        Expanded(
          child: _SidebarItemLabel(
            item: item,
            style: style,
            foregroundColor: foregroundColor,
            expandControl: expandControl,
            expandControlOverhang: _expandControlOverhang,
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: style.itemSpacing),
          _SidebarItemTrailing(style: style, child: trailing!),
        ],
      ],
    );
  }

  Widget _indentedContent(Offset offset, Widget? expandControl) {
    return Row(
      children: [
        Expanded(
          child: ClipRect(
            child: Transform.translate(
              offset: offset,
              child: Row(
                children: [
                  if (_hasLeading) ...[
                    _SidebarItemLeading(
                      leading: item.leading,
                      icon: item.icon,
                      color: item.iconColor ?? foregroundColor,
                      size: style.itemIconSize,
                    ),
                    SizedBox(width: style.itemSpacing),
                  ],
                  Expanded(
                    child: _SidebarItemLabel(
                      item: item,
                      style: style,
                      foregroundColor: foregroundColor,
                      expandControl: expandControl,
                      expandControlOverhang: _expandControlOverhang,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: style.itemSpacing),
          _SidebarItemTrailing(style: style, child: trailing!),
        ],
      ],
    );
  }
}

class _SidebarItemExpandControl extends StatelessWidget {
  const _SidebarItemExpandControl({
    required this.item,
    required this.style,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;

  bool get _hasExpandToggle =>
      item.onExpandToggle != null || item.onExpandTogglePressed != null;

  @override
  Widget build(BuildContext context) {
    final expanded = item.expanded!;

    return Builder(
      builder: (BuildContext controlContext) => LinagoraSidebarControl(
        icon: LinagoraSidebarControl.disclosureIcon(expanded),
        iconSize: style.chevronSize,
        color: style.trailingForeground,
        onTap: item.enabled && _hasExpandToggle
            ? () => _handleExpandToggle(controlContext)
            : null,
        semanticLabel: item.expandToggleLabel,
      ),
    );
  }

  void _handleExpandToggle(BuildContext context) {
    final shouldReveal = item.scrollIntoViewOnExpand && item.expanded == false;
    final OnLinagoraSidebarExpandTogglePressed? callback =
        item.onExpandTogglePressed;
    if (callback != null) {
      unawaited(_runExpandTogglePressed(context, callback, shouldReveal));
      return;
    }
    item.onExpandToggle?.call();
    if (shouldReveal) {
      LinagoraSidebarScrollCoordinator.scheduleReveal(context);
    }
  }

  Future<void> _runExpandTogglePressed(
    BuildContext context,
    OnLinagoraSidebarExpandTogglePressed callback,
    bool shouldReveal,
  ) async {
    final completed = await runLinagoraSidebarCallback(
      () => callback(LinagoraSidebarActionDetails.fromContext(context)),
      callbackName: 'LinagoraSidebarItem.onExpandTogglePressed',
    );
    if (completed && shouldReveal && context.mounted) {
      LinagoraSidebarScrollCoordinator.scheduleReveal(context);
    }
  }
}

/// The label and chevron are translated with the leading content while badges
/// remain anchored in the row's trailing slot.
class _SidebarItemLabel extends StatelessWidget {
  const _SidebarItemLabel({
    required this.item,
    required this.style,
    required this.foregroundColor,
    this.expandControl,
    this.expandControlOverhang = 0,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;
  final Color foregroundColor;
  final Widget? expandControl;
  final double expandControlOverhang;

  @override
  Widget build(BuildContext context) {
    final supporting = _supporting();
    if (supporting == null) return _title();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _title(),
        const SizedBox(height: LinagoraSidebarItem.supportingSpacing),
        DefaultTextStyle.merge(
          style: LinagoraTextTheme.material().bodySmall?.copyWith(
            color: foregroundColor,
          ),
          child: supporting,
        ),
      ],
    );
  }

  Widget _title() {
    final title = Text(
      item.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textHeightBehavior: LinagoraSidebarStyle.middleAligned,
      style: style.labelTextStyle.copyWith(color: foregroundColor),
    );
    final control = expandControl;
    if (control == null) return title;

    return Row(
      children: [
        Flexible(child: title),
        SizedBox(
          width: math.max(
            0,
            style.itemSpacing -
                expandControlOverhang,
          ),
        ),
        control,
      ],
    );
  }

  Widget? _supporting() {
    final content = item.supportingContent;
    if (content != null) return content;

    final text = item.supportingText;
    if (text == null) return null;
    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
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

class _SidebarItemTrailing extends StatelessWidget {
  const _SidebarItemTrailing({required this.style, required this.child});

  final LinagoraSidebarStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = style.trailingForeground;
    return DefaultTextStyle.merge(
      style: style.badgeTextStyle.copyWith(color: color),
      textHeightBehavior: LinagoraSidebarStyle.middleAligned,
      child: IconTheme.merge(
        data: IconThemeData(color: color, size: style.itemIconSize),
        child: child,
      ),
    );
  }
}
