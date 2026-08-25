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
          child: expandControl == null || _expandControlOverhang == 0
              ? _translatedIndentedContent(
                  offset,
                  expandControl: expandControl,
                )
              : LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    children: [
                      _translatedIndentedContent(
                        offset,
                        reserveExpandControl: true,
                      ),
                      _SidebarItemPositionedExpandControl(
                        item: item,
                        style: style,
                        control: expandControl,
                        contentWidth: constraints.maxWidth,
                        leadingWidth: _hasLeading
                            ? style.itemIconSize + style.itemSpacing
                            : 0,
                        contentOffset: offset,
                        expandControlOverhang: _expandControlOverhang,
                      ),
                    ],
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

  Widget _translatedIndentedContent(
    Offset offset, {
    Widget? expandControl,
    bool reserveExpandControl = false,
  }) {
    return ClipRect(
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
                reserveExpandControl: reserveExpandControl,
              ),
            ),
          ],
        ),
      ),
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

/// The label moves with the leading content while badges stay anchored in the
/// row's trailing slot. An interactive chevron follows the label until it
/// reaches the row edge, where it remains available instead of being clipped.
class _SidebarItemLabel extends StatelessWidget {
  const _SidebarItemLabel({
    required this.item,
    required this.style,
    required this.foregroundColor,
    this.expandControl,
    this.expandControlOverhang = 0,
    this.reserveExpandControl = false,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;
  final Color foregroundColor;
  final Widget? expandControl;
  final double expandControlOverhang;
  final bool reserveExpandControl;

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
    if (control == null && !reserveExpandControl) return title;

    final double gap = math.max(
      0,
      style.itemSpacing - expandControlOverhang,
    );
    return Row(
      children: [
        Flexible(child: title),
        SizedBox(width: gap),
        control ??
            SizedBox(
              width: style.chevronSize + expandControlOverhang * 2,
            ),
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

class _SidebarItemPositionedExpandControl extends StatelessWidget {
  const _SidebarItemPositionedExpandControl({
    required this.item,
    required this.style,
    required this.control,
    required this.contentWidth,
    required this.leadingWidth,
    required this.contentOffset,
    required this.expandControlOverhang,
  });

  final LinagoraSidebarItem item;
  final LinagoraSidebarStyle style;
  final Widget control;
  final double contentWidth;
  final double leadingWidth;
  final Offset contentOffset;
  final double expandControlOverhang;

  @override
  Widget build(BuildContext context) {
    final double gap = math.max(
      0,
      style.itemSpacing - expandControlOverhang,
    );
    final controlWidth = style.chevronSize + expandControlOverhang * 2;
    final double labelWidth = math.max(0, contentWidth - leadingWidth);
    final double maxTitleWidth = math.max(0, labelWidth - gap - controlWidth);
    final painter = TextPainter(
      text: TextSpan(text: item.label, style: style.labelTextStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
      ellipsis: '\u2026',
    );
    try {
      painter.layout();
      final double titleWidth = math.min(painter.width, maxTitleWidth);
      final availableOffset = math.max(
        0,
        labelWidth - titleWidth - gap - controlWidth,
      );
      final visibleOffset = math.min(
        contentOffset.dx.abs(),
        availableOffset,
      );
      return PositionedDirectional(
        start: leadingWidth + titleWidth + gap + visibleOffset,
        top: 0,
        bottom: 0,
        width: controlWidth,
        child: Center(child: control),
      );
    } finally {
      painter.dispose();
    }
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
