import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Shares the scroll body owned by a [LinagoraSidebarMenu] with sidebar
/// controls that need to reveal themselves after changing visible content.
///
/// Products keep ownership of their expansion state. A row can opt into
/// [scheduleReveal] after it asks the product to expand, while this scope uses
/// the sidebar body's viewport rather than screen dimensions or product footer
/// assumptions.
class LinagoraSidebarScrollCoordinator extends InheritedWidget {
  const LinagoraSidebarScrollCoordinator({
    super.key,
    required this.controller,
    required super.child,
  });

  final ScrollController? controller;

  static LinagoraSidebarScrollCoordinator? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<
        LinagoraSidebarScrollCoordinator
      >();

  /// Reveals [targetContext] after the current frame when it sits too close to
  /// the end of the menu body to make an expansion useful.
  ///
  /// The body excludes pinned footer content, so [trailingExtent] is measured
  /// against the real available viewport without any product-specific offset.
  static void scheduleReveal(
    BuildContext targetContext, {
    double trailingExtent = 40,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    final coordinator = maybeOf(targetContext);
    final controller = coordinator?.controller;
    if (controller == null || trailingExtent < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients || !controller.position.hasContentDimensions) {
        return;
      }
      if (!targetContext.mounted) return;

      final renderObject = targetContext.findRenderObject();
      if (renderObject == null || !renderObject.attached) return;

      final position = controller.position;
      final viewport = RenderAbstractViewport.of(renderObject);
      final revealOffset = viewport
          .getOffsetToReveal(renderObject, 1)
          .offset
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();
      final targetOffset = (revealOffset + trailingExtent)
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();

      if (targetOffset <= position.pixels) return;

      controller.animateTo(targetOffset, duration: duration, curve: curve);
    });
  }

  @override
  bool updateShouldNotify(LinagoraSidebarScrollCoordinator oldWidget) =>
      controller != oldWidget.controller;
}
