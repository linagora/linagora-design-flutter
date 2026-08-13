import 'package:flutter/material.dart';

/// Icon control shared by sidebar rows and section headers.
///
/// Decorative icons keep their glyph size; interactive ones use [tapTarget].
class LinagoraSidebarControl extends StatelessWidget {
  /// Compact target that fits within a sidebar row.
  static const double tapTarget = 24;

  /// Extra width the target extends past a glyph on each side.
  static double overhang(double iconSize) => (tapTarget - iconSize) / 2;

  /// Disclosure glyph for an [expanded] state.
  static IconData disclosureIcon(bool expanded) =>
      expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right;

  const LinagoraSidebarControl({
    super.key,
    required this.icon,
    required this.iconSize,
    this.color,
    this.onTap,
    this.semanticLabel,
    this.expanded,
  }) : assert(
         onTap == null || semanticLabel != null,
         'An interactive sidebar control needs semanticLabel for screen readers',
       );

  final IconData icon;

  final double iconSize;

  /// Null uses the ambient [IconTheme].
  final Color? color;

  final VoidCallback? onTap;

  /// Localized accessible name for an interactive control.
  final String? semanticLabel;

  /// Expanded state announced by a disclosure control.
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(icon, size: iconSize, color: color);
    if (onTap == null) return glyph;

    return Semantics(
      button: true,
      label: semanticLabel,
      expanded: expanded,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        highlightShape: BoxShape.circle,
        radius: tapTarget / 2,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: tapTarget,
          child: Center(child: glyph),
        ),
      ),
    );
  }
}
