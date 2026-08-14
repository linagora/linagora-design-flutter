import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_action_details.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_callback_utils.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_control.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_scroll_coordinator.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Compact header for a sidebar navigation section.
///
/// [actions] supports product-specific controls such as search and add.
class LinagoraSidebarSectionHeader extends StatelessWidget {
  /// Gap between the caption and its disclosure chevron.
  static const double titleSpacing = 4;

  /// Visual gap between [actions] glyphs.
  static const double actionSpacing = 8;

  const LinagoraSidebarSectionHeader({
    super.key,
    required this.label,
    this.expanded,
    this.onExpandToggle,
    this.onExpandTogglePressed,
    this.expandToggleLabel,
    this.scrollIntoViewOnExpand = false,
    this.actions = const [],
    this.foregroundColor,
    this.style,
  }) : assert(
         onExpandToggle == null || onExpandTogglePressed == null,
         'Provide either onExpandToggle or onExpandTogglePressed, not both',
       ),
       assert(
         (onExpandToggle == null && onExpandTogglePressed == null) ||
             expanded != null,
         'A tappable disclosure needs expanded to render the chevron',
       ),
       assert(
         (onExpandToggle == null && onExpandTogglePressed == null) ||
             expandToggleLabel != null,
         'A tappable disclosure needs expandToggleLabel for screen readers',
       );

  final String label;

  /// Null omits the disclosure. `true` points it down; `false` points it right.
  final bool? expanded;

  /// Toggles the disclosure; without it the chevron is decorative.
  final VoidCallback? onExpandToggle;

  /// Async-capable disclosure callback that receives the toggle's geometry.
  ///
  /// Use this for scroll-to-expanded behaviour without an application-owned
  /// [GlobalKey]. It is mutually exclusive with [onExpandToggle].
  final OnLinagoraSidebarExpandTogglePressed? onExpandTogglePressed;

  /// Localized accessible name for [onExpandToggle].
  final String? expandToggleLabel;

  /// Reveals the disclosure in its enclosing sidebar body after an expansion.
  final bool scrollIntoViewOnExpand;

  /// Trailing controls, typically [LinagoraSidebarSectionHeaderAction]s.
  final List<Widget> actions;

  final Color? foregroundColor;

  final LinagoraSidebarStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? LinagoraSidebarStyle.of(context);
    final foreground = foregroundColor ?? style.resolvedSectionHeaderForeground;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          // Allows text scaling while fitting interactive controls.
          constraints: BoxConstraints(minHeight: style.sectionHeaderMinHeight),
          child: Row(
            children: [
              Expanded(child: _title(style, foreground)),
              if (actions.isNotEmpty) _actions(foreground),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(LinagoraSidebarStyle style, Color foreground) {
    return Row(
      children: [
        Flexible(
          // The control owns interactive expansion; decorative disclosures
          // publish it through the section heading.
          child: Semantics(
            header: true,
            expanded: !_hasInteractiveDisclosure ? expanded : null,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: LinagoraTextTheme.material().labelMedium?.copyWith(
                color: foreground,
              ),
            ),
          ),
        ),
        if (expanded != null) ...[
          SizedBox(width: _disclosureSpacing(style)),
          _disclosure(style, foreground),
        ],
      ],
    );
  }

  /// Absorbs the overhang of a tappable target into the gap so the visual
  /// spacing stays [titleSpacing]. With the stock chevron the overhang already
  /// exceeds [titleSpacing], so the clamp wins and the glyph sits its full
  /// overhang away — closing the gap further would put the target under the
  /// caption.
  double _disclosureSpacing(LinagoraSidebarStyle style) {
    if (!_hasInteractiveDisclosure) return titleSpacing;
    return math.max(
      0,
      titleSpacing - LinagoraSidebarControl.overhang(style.chevronSize),
    );
  }

  Widget _disclosure(LinagoraSidebarStyle style, Color foreground) {
    if (!_hasInteractiveDisclosure) {
      return Icon(
        LinagoraSidebarControl.disclosureIcon(expanded!),
        size: style.chevronSize,
        color: foreground,
      );
    }
    return Builder(
      builder: (toggleContext) => LinagoraSidebarControl(
        icon: LinagoraSidebarControl.disclosureIcon(expanded!),
        iconSize: style.chevronSize,
        color: foreground,
        onTap: () => _toggle(toggleContext),
        semanticLabel: expandToggleLabel,
        expanded: expanded,
      ),
    );
  }

  bool get _hasInteractiveDisclosure =>
      onExpandToggle != null || onExpandTogglePressed != null;

  void _toggle(BuildContext context) {
    final shouldReveal = scrollIntoViewOnExpand && expanded == false;
    final callback = onExpandTogglePressed;
    if (callback != null) {
      unawaited(_runExpandTogglePressed(context, callback, shouldReveal));
      return;
    }
    onExpandToggle?.call();
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
      callbackName: 'LinagoraSidebarSectionHeader.onExpandTogglePressed',
    );
    if (completed && shouldReveal && context.mounted) {
      LinagoraSidebarScrollCoordinator.scheduleReveal(context);
    }
  }

  Widget _actions(Color foreground) {
    // Plain icons inherit the header's colour and size.
    return IconTheme.merge(
      data: IconThemeData(
        color: foreground,
        size: LinagoraSidebarSectionHeaderAction.size,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: actions),
    );
  }
}

/// A compact icon control for [LinagoraSidebarSectionHeader.actions].
class LinagoraSidebarSectionHeaderAction extends StatelessWidget {
  /// Figma's XSmall icon-button dimension.
  static const double size = 16.67;

  const LinagoraSidebarSectionHeaderAction({
    super.key,
    this.icon,
    this.iconWidget,
    this.child,
    required this.onTap,
    this.semanticLabel,
    this.color,
  }) : assert(
         icon != null || iconWidget != null || child != null,
         'A header action needs an icon, iconWidget, or child',
       ),
       assert(
         onTap == null || semanticLabel != null,
         'A tappable header action needs semanticLabel for screen readers',
       );

  /// Material icon used when no [iconWidget] or [child] is supplied.
  final IconData? icon;

  /// Replaces [icon], allowing a product to provide an SVG or another widget.
  final Widget? iconWidget;

  /// Generic visual content for the action.
  ///
  /// This takes precedence over [iconWidget] and [icon].
  final Widget? child;

  final VoidCallback? onTap;
  final String? semanticLabel;

  /// Null inherits the header colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    if (child == null && iconWidget == null && icon != null) {
      return _legacyIconAction(context, icon);
    }

    final glyph = _glyph(context);
    final control = onTap == null
        ? glyph
        : Semantics(
            button: true,
            label: semanticLabel,
            child: InkResponse(
              onTap: onTap,
              containedInkWell: true,
              highlightShape: BoxShape.circle,
              radius: size / 2,
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                dimension: size,
                child: Center(child: glyph),
              ),
            ),
          );

    final tooltip = semanticLabel;
    if (onTap == null || tooltip == null) return control;
    return Tooltip(message: tooltip, child: control);
  }

  Widget _legacyIconAction(BuildContext context, IconData icon) {
    final control = LinagoraSidebarControl(
      icon: icon,
      iconSize: size,
      color: color ?? IconTheme.of(context).color,
      onTap: onTap,
      semanticLabel: semanticLabel,
      targetSize: size,
    );

    final tooltip = semanticLabel;
    if (onTap == null || tooltip == null) return control;
    return Tooltip(message: tooltip, child: control);
  }

  Widget _glyph(BuildContext context) {
    final icon = this.icon;
    final foreground = color ?? IconTheme.of(context).color;
    final visual =
        child ?? iconWidget ?? Icon(icon!, size: size, color: foreground);
    return SizedBox.square(
      dimension: size,
      child: IconTheme.merge(
        data: IconThemeData(
          color: foreground,
          size: size,
        ),
        child: visual,
      ),
    );
  }
}
