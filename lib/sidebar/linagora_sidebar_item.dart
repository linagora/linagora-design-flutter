import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/behaviors/right_click_focus.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_badge.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_action_details.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_callback_utils.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_control.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_indent.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_item_action_scope.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_scroll_coordinator.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

export 'linagora_sidebar_action_details.dart';

part 'linagora_sidebar_item_content.dart';

typedef _OnLinagoraSidebarItemHoverChanged = void Function(bool isHovering);

/// A primary navigation row for the shared left menu.
///
/// The row fills its available width and keeps no navigation state: the
/// application owns [active].
///
/// Hover is available on web and desktop platforms. Touch-first platforms
/// stay flat, where the Material ripple provides interaction feedback.
class LinagoraSidebarItem extends StatefulWidget {
  /// Gap between the title and secondary supporting content.
  static const double supportingSpacing = 2;

  final String label;

  final IconData? icon;

  /// Overrides the leading [icon] colour without changing the label colour.
  final Color? iconColor;

  /// Takes precedence over [icon].
  final Widget? leading;

  /// Secondary caller-formatted text, for example a team mailbox address.
  ///
  /// [supportingContent] takes precedence when both are supplied.
  final String? supportingText;

  /// Generic secondary content rendered below [label].
  ///
  /// It allows a product to use an SVG, a status chip, or its own text widget
  /// without making the sidebar item aware of product-specific UI.
  final Widget? supportingContent;

  /// Already formatted by the caller, e.g. `3` or `999+`.
  final String? badgeLabel;

  /// Rendered after the badge when both are set.
  final Widget? trailing;

  /// Replaces [trailing] and the badge while hovered.
  final Widget? hoverTrailing;

  /// Non-null renders an expand/collapse chevron beside the label — pointing
  /// down when expanded, right when collapsed. Null means the row is a leaf.
  final bool? expanded;

  /// Legacy synchronous callback that makes the chevron tappable on its own.
  ///
  /// Without this or [onExpandTogglePressed], the chevron is decorative and
  /// [onTap] carries the toggle.
  final VoidCallback? onExpandToggle;

  /// Async-capable expand callback that receives the chevron's geometry.
  ///
  /// This cannot be supplied with [onExpandToggle].
  final OnLinagoraSidebarExpandTogglePressed? onExpandTogglePressed;

  /// Screen-reader name for the chevron, e.g. `Collapse` while expanded.
  /// Required alongside [onExpandToggle] or [onExpandTogglePressed]: a control
  /// with no name is invisible to a screen reader, and only the application
  /// can localise it.
  final String? expandToggleLabel;

  /// Reveals the toggle in its enclosing [LinagoraSidebarMenu] after an
  /// expansion, leaving room for the newly visible descendants.
  ///
  /// The product still owns the expansion state and callback. This is off by
  /// default so an existing sidebar keeps its current scroll behaviour.
  final bool scrollIntoViewOnExpand;

  /// Overrides pointer tracking: `true` pins hover on, `false` suppresses it
  /// even under the pointer. Null tracks the pointer.
  final bool? hovered;

  final bool active;

  final bool enabled;

  final VoidCallback? onTap;

  final GestureTapDownCallback? onSecondaryTapDown;

  final FocusNode? focusNode;

  final String? tooltip;

  final Color? foregroundColor;
  final Color? activeForegroundColor;
  final Color? activeBackgroundColor;
  final Color? hoverBackgroundColor;

  final LinagoraSidebarStyle? style;

  const LinagoraSidebarItem({
    super.key,
    required this.label,
    this.icon,
    this.iconColor,
    this.leading,
    this.supportingText,
    this.supportingContent,
    this.badgeLabel,
    this.trailing,
    this.hoverTrailing,
    this.expanded,
    this.onExpandToggle,
    this.onExpandTogglePressed,
    this.expandToggleLabel,
    this.scrollIntoViewOnExpand = false,
    this.hovered,
    this.active = false,
    this.enabled = true,
    this.onTap,
    this.onSecondaryTapDown,
    this.focusNode,
    this.tooltip,
    this.foregroundColor,
    this.activeForegroundColor,
    this.activeBackgroundColor,
    this.hoverBackgroundColor,
    this.style,
  }) : assert(
         onExpandToggle == null || onExpandTogglePressed == null,
         'Provide either onExpandToggle or onExpandTogglePressed, not both',
       ),
       assert(
         (onExpandToggle == null && onExpandTogglePressed == null) ||
             expandToggleLabel != null,
         'A tappable chevron needs expandToggleLabel for screen readers',
       ),
       assert(
         (onExpandToggle == null && onExpandTogglePressed == null) ||
             expanded != null,
         'A tappable chevron needs expanded to render the chevron',
       );

  /// Whether the platform hovers at all.
  ///
  /// Touch-first platforms stay flat even with a mouse or stylus attached, so
  /// a phone or tablet never shows a hover state; the Material ripple is the
  /// feedback there. Desktop keeps hover, which a `kIsWeb` check would lose.
  static bool get hoverSupported {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => false,
      _ => true,
    };
  }

  @override
  State<LinagoraSidebarItem> createState() => _LinagoraSidebarItemState();
}

class _LinagoraSidebarItemState extends State<LinagoraSidebarItem> {
  bool _hovering = false;
  final LinagoraSidebarActionActivity _actionActivity =
      LinagoraSidebarActionActivity();

  bool get _isInteractive => widget.enabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? LinagoraSidebarStyle.of(context);
    final isHovered = _isInteractive && (widget.hovered ?? _hovering);

    return LinagoraSidebarItemActionScope(
      activity: _actionActivity,
      enabled: widget.enabled,
      child: ListenableBuilder(
        listenable: _actionActivity,
        builder: (context, child) {
          final item = _LinagoraSidebarItemContent(
            item: widget,
            style: style,
            backgroundColor: _backgroundColor(
              style,
              isHovered,
              _actionActivity.isActive,
            ),
            foregroundColor: _foregroundColor(style),
            isInteractive: _isInteractive,
            hasActiveAction: _actionActivity.isActive,
            actionActivity: _actionActivity,
            suppressRowInkFeedback: widget.hoverTrailing != null,
            trailing: _trailing(
              style,
              isHovered,
              _actionActivity.isActive,
            ),
            onHoverChanged: LinagoraSidebarItem.hoverSupported
                ? _setHovering
                : null,
          );

          final tooltip = widget.tooltip;
          final tooltipItem = tooltip == null
              ? item
              : Tooltip(message: tooltip, child: item);
          return RightClickFocus(
            focusNode: widget.focusNode,
            child: tooltipItem,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _actionActivity.dispose();
    super.dispose();
  }

  void _setHovering(bool hovering) {
    if (widget.hovered != null || _hovering == hovering) return;
    setState(() => _hovering = hovering);
  }

  /// Disabled rows dim as a whole in [_LinagoraSidebarItemContent], so this
  /// stays the enabled colour.
  Color _foregroundColor(LinagoraSidebarStyle style) {
    if (widget.active) {
      return widget.activeForegroundColor ?? style.activeForeground;
    }
    return widget.foregroundColor ?? style.foreground;
  }

  /// Active wins over hover, so crossing the active row does not lighten it.
  Color _backgroundColor(
    LinagoraSidebarStyle style,
    bool isHovered,
    bool hasActiveAction,
  ) {
    if (widget.active) {
      return widget.activeBackgroundColor ?? style.selectedBackground;
    }
    // A product action owns the active visual while its menu or popover is
    // open. Keeping the pointer hover fill underneath would make the whole
    // row look selected instead of only highlighting the trigger.
    if (hasActiveAction) return Colors.transparent;
    if (isHovered) {
      return widget.hoverBackgroundColor ?? style.hoverBackground;
    }
    return Colors.transparent;
  }

  Widget? _trailing(
    LinagoraSidebarStyle style,
    bool isHovered,
    bool hasActiveAction,
  ) {
    final useHoverTrailing =
        (isHovered || hasActiveAction) && widget.hoverTrailing != null;
    final trailing = useHoverTrailing ? widget.hoverTrailing : widget.trailing;

    // An open menu/popover keeps actions available but does not keep the row
    // hover fill. The badge must leave that same trailing slot while it does.
    if (useHoverTrailing || hasActiveAction) return trailing;

    final badgeLabel = widget.badgeLabel;
    if (badgeLabel == null) return trailing;

    final badge = LinagoraSidebarBadge(label: badgeLabel, style: style);
    if (trailing == null) return badge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        SizedBox(width: style.itemSpacing),
        trailing,
      ],
    );
  }
}

/// A compact Material action for a [LinagoraSidebarItem] trailing slot.
///
/// Use it for contextual text actions such as `Clean` and icon actions such
/// as an overflow menu. It owns its ripple and tap callback, so tapping an
/// action does not trigger the navigation row behind it.
class LinagoraSidebarItemAction extends StatelessWidget {
  static const double minimumDimension = LinagoraSidebarControl.tapTarget;

  /// Padding for a text action such as a sidebar `Clean` button. A glyph
  /// action leaves [padding] null and takes the round-target inset from
  /// [LinagoraSidebarStyle.actionIconPadding].
  static const EdgeInsetsGeometry textPadding = EdgeInsetsDirectional.symmetric(
    horizontal: 8,
  );

  const LinagoraSidebarItemAction({
    super.key,
    required this.child,
    this.onTap,
    this.onPressed,
    this.semanticLabel,
    this.padding,
    this.active = false,
    this.focusNode,
    this.style,
  }) : assert(
         onTap == null || onPressed == null,
         'Provide either onTap or onPressed, not both',
       ),
       assert(
         (onTap == null && onPressed == null) || semanticLabel != null,
         'An interactive sidebar item action needs a semanticLabel',
       );

  final Widget child;

  /// Legacy synchronous callback retained for source compatibility.
  final VoidCallback? onTap;

  /// Async-capable callback that receives the action's anchor geometry.
  final OnLinagoraSidebarActionPressed? onPressed;

  final String? semanticLabel;

  /// Null takes the round-target inset from
  /// [LinagoraSidebarStyle.actionIconPadding]; pass [textPadding] for a label.
  final EdgeInsetsGeometry? padding;

  /// Keeps the action washed while product UI opened by it remains visible.
  final bool active;

  /// Optional focus node for actions that need to restore focus after closing
  /// an overlay.
  final FocusNode? focusNode;

  final LinagoraSidebarStyle? style;

  bool get _hasCallback => onTap != null || onPressed != null;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? LinagoraSidebarStyle.of(context);
    final enabled =
        LinagoraSidebarItemActionScope.maybeScopeOf(context)?.enabled ?? true;
    final isInteractive = enabled && _hasCallback;
    const shape = StadiumBorder();
    return Builder(
      builder: (actionContext) {
        final action = Material(
          color: active
              ? style.resolvedActionActiveBackground
              : Colors.transparent,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isInteractive ? () => _handlePressed(actionContext) : null,
            focusNode: focusNode,
            customBorder: shape,
            // Only the visual content is excluded. Excluding the [InkWell] as
            // well dropped its tap action, and the remaining properties then
            // merged into the row's own node: the action became unreachable to
            // a screen reader and the row announced both labels at once.
            child: ExcludeSemantics(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: minimumDimension,
                  minHeight: minimumDimension,
                ),
                child: SizedBox(
                  height: minimumDimension,
                  // Keep the pill content-sized in a bounded trailing slot;
                  // Container(alignment: ...) would instead fill that width.
                  child: Center(
                    widthFactor: 1,
                    child: Padding(
                      padding:
                          padding ?? EdgeInsets.all(style.actionIconPadding),
                      child: DefaultTextStyle.merge(
                        style: LinagoraTextTheme.material().labelSmall?.copyWith(
                          color: style.trailingForeground,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        if (!isInteractive) return action;
        return Semantics(button: true, label: semanticLabel, child: action);
      },
    );
  }

  void _handlePressed(BuildContext context) {
    final OnLinagoraSidebarActionPressed? callback = onPressed;
    if (callback != null) {
      unawaited(
        runLinagoraSidebarCallback(
          () => callback(LinagoraSidebarActionDetails.fromContext(context)),
          callbackName: 'LinagoraSidebarItemAction.onPressed',
        ),
      );
      return;
    }
    onTap?.call();
  }
}
