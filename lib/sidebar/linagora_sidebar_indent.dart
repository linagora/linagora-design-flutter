import 'package:flutter/widgets.dart';

/// Carries the accumulated tree indentation down to the sidebar rows below it.
///
/// [LinagoraSidebarSubItem] provides it and [LinagoraSidebarItem] consumes it,
/// so a nested row shifts only its icon and label: the selected and hovered
/// fill still spans the full sidebar width. Applying indentation around the
/// row would shorten that fill once per level.
///
/// Custom rows can read [of] and apply the returned value to their content
/// padding.
class LinagoraSidebarIndent extends InheritedWidget {
  const LinagoraSidebarIndent({
    super.key,
    required this.indent,
    required super.child,
  }) : assert(indent >= 0, 'A sidebar indent cannot be negative');

  /// The distance from the sidebar's leading edge to the row's content.
  final double indent;

  /// The indentation that applies to rows built in [context], or zero outside
  /// a folder tree.
  static double of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LinagoraSidebarIndent>();
    return scope?.indent ?? 0;
  }

  @override
  bool updateShouldNotify(LinagoraSidebarIndent oldWidget) =>
      indent != oldWidget.indent;
}
