import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/behaviors/right_click_focus.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_badge.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_control.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_indent.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';

part 'linagora_sidebar_item_content.dart';

/// A primary navigation row for the shared left menu.
///
/// The row fills its available width and keeps no navigation state: the
/// application owns [active].
///
/// Hover is available on web and desktop platforms. Touch-first platforms
/// stay flat, where the Material ripple provides interaction feedback.
class LinagoraSidebarItem extends StatefulWidget {
  final String label;

  final IconData? icon;

  /// Takes precedence over [icon].
  final Widget? leading;

  /// Already formatted by the caller, e.g. `3` or `999+`.
  final String? badgeLabel;

  /// Rendered after the badge when both are set.
  final Widget? trailing;

  /// Replaces [trailing] and the badge while hovered.
  final Widget? hoverTrailing;

  /// Non-null renders an expand/collapse chevron beside the label — pointing
  /// down when expanded, right when collapsed. Null means the row is a leaf.
  final bool? expanded;

  /// Makes the chevron tappable on its own. Without it the chevron is
  /// decorative and [onTap] carries the toggle.
  final VoidCallback? onExpandToggle;

  /// Screen-reader name for the chevron, e.g. `Collapse` while expanded.
  /// Required alongside [onExpandToggle]: a control with no name is invisible
  /// to a screen reader, and only the application can localise it.
  final String? expandToggleLabel;

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
    this.leading,
    this.badgeLabel,
    this.trailing,
    this.hoverTrailing,
    this.expanded,
    this.onExpandToggle,
    this.expandToggleLabel,
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
         onExpandToggle == null || expandToggleLabel != null,
         'A tappable chevron needs expandToggleLabel for screen readers',
       ),
       assert(
         onExpandToggle == null || expanded != null,
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

  bool get _isInteractive => widget.enabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? LinagoraSidebarStyle.of(context);
    final isHovered = _isInteractive && (widget.hovered ?? _hovering);

    final item = _LinagoraSidebarItemContent(
      item: widget,
      style: style,
      backgroundColor: _backgroundColor(style, isHovered),
      foregroundColor: _foregroundColor(style),
      isInteractive: _isInteractive,
      trailing: _trailing(style, isHovered),
      onHoverChanged:
          LinagoraSidebarItem.hoverSupported ? _setHovering : null,
    );

    final tooltip = widget.tooltip;
    final tooltipItem =
        tooltip == null ? item : Tooltip(message: tooltip, child: item);
    return RightClickFocus(focusNode: widget.focusNode, child: tooltipItem);
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
  Color _backgroundColor(LinagoraSidebarStyle style, bool isHovered) {
    if (widget.active) {
      return widget.activeBackgroundColor ?? style.selectedBackground;
    }
    if (isHovered) {
      return widget.hoverBackgroundColor ?? style.hoverBackground;
    }
    return Colors.transparent;
  }

  Widget? _trailing(LinagoraSidebarStyle style, bool isHovered) {
    if (isHovered && widget.hoverTrailing != null) return widget.hoverTrailing;

    final badgeLabel = widget.badgeLabel;
    if (badgeLabel == null) return widget.trailing;

    final badge = LinagoraSidebarBadge(label: badgeLabel, style: style);
    if (widget.trailing == null) return badge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        SizedBox(width: style.itemSpacing),
        widget.trailing!,
      ],
    );
  }
}
