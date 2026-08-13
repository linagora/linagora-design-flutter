import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// The sidebar-shell stand-in used to review translucent sidebar states.
class SidebarPreviewSurface extends StatelessWidget {
  const SidebarPreviewSurface({
    super.key,
    required this.width,
    required this.child,
  });

  static const double padding = 16;
  static const double defaultWidth = 204;

  /// The width this surface can actually hand a preview: the selected viewport
  /// minus its horizontal inset.
  ///
  /// The surface clamps its child to this, so a width above it is silently
  /// discarded. Every width control derives its range from here to report the
  /// width the preview really renders.
  static double contentWidth(BuildContext context) {
    final available = MediaQuery.sizeOf(context).width - padding * 2;
    return math.max(0, available);
  }

  /// Registers the shared sidebar width knob and returns the chosen width.
  ///
  /// On a viewport too narrow for the minimum preview width there is a single
  /// width that fits, so no knob is registered at all: widgetbook builds its
  /// panel from the knobs a use case asks for, and a slider that cannot change
  /// anything is better absent than dead.
  static double widthKnob(BuildContext context) {
    final content = contentWidth(context);
    if (content <= defaultWidth) return content;

    return context.knobs.double.slider(
      label: 'Sidebar width',
      description: 'Choose a preview width up to the selected viewport.',
      initialValue: defaultWidth,
      min: defaultWidth,
      max: content,
    );
  }

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ColoredBox(
      color: isDark ? const Color(0xFF272A31) : const Color(0xFFF3F6F9),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: child,
          ),
        ),
      ),
    );
  }
}
