import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_control.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Compact header for a sidebar navigation section.
///
/// [actions] supports product-specific controls such as search and add.
class LinagoraSidebarSectionHeader extends StatelessWidget {
  /// Gap between the caption and its disclosure chevron.
  static const double titleSpacing = 4;

  const LinagoraSidebarSectionHeader({
    super.key,
    required this.label,
    this.expanded,
    this.onExpandToggle,
    this.expandToggleLabel,
    this.actions = const [],
    this.foregroundColor,
    this.style,
  }) : assert(
         onExpandToggle == null || expanded != null,
         'A tappable disclosure needs expanded to render the chevron',
       ),
       assert(
         onExpandToggle == null || expandToggleLabel != null,
         'A tappable disclosure needs expandToggleLabel for screen readers',
       );

  final String label;

  /// Null omits the disclosure. `true` points it down; `false` points it right.
  final bool? expanded;

  /// Toggles the disclosure; without it the chevron is decorative.
  final VoidCallback? onExpandToggle;

  /// Localized accessible name for [onExpandToggle].
  final String? expandToggleLabel;

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
            expanded: onExpandToggle == null ? expanded : null,
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
    if (onExpandToggle == null) return titleSpacing;
    return math.max(
      0,
      titleSpacing - LinagoraSidebarControl.overhang(style.chevronSize),
    );
  }

  Widget _disclosure(LinagoraSidebarStyle style, Color foreground) {
    if (onExpandToggle == null) {
      return Icon(
        LinagoraSidebarControl.disclosureIcon(expanded!),
        size: style.chevronSize,
        color: foreground,
      );
    }
    return LinagoraSidebarControl(
      icon: LinagoraSidebarControl.disclosureIcon(expanded!),
      iconSize: style.chevronSize,
      color: foreground,
      onTap: onExpandToggle,
      semanticLabel: expandToggleLabel,
      expanded: expanded,
    );
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
    required this.icon,
    required this.onTap,
    this.semanticLabel,
    this.color,
  }) : assert(
         onTap == null || semanticLabel != null,
         'A tappable header action needs semanticLabel for screen readers',
       );

  final IconData icon;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// Null inherits the header colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
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
}
