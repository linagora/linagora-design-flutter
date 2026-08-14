import 'dart:async';

import 'package:flutter/material.dart';

/// Reports a sidebar action press with the action's anchor geometry.
///
/// Products can use [LinagoraSidebarActionDetails.anchor] with `showMenu`, or
/// use [LinagoraSidebarActionDetails.globalBounds] to place another UI of
/// their choosing. The design system does not choose that UI.
typedef OnLinagoraSidebarActionPressed =
    FutureOr<void> Function(LinagoraSidebarActionDetails details);

/// Reports a sidebar expand-toggle press with the toggle's geometry.
typedef OnLinagoraSidebarExpandTogglePressed =
    FutureOr<void> Function(LinagoraSidebarActionDetails details);

/// Geometry supplied when a sidebar action is pressed.
class LinagoraSidebarActionDetails {
  const LinagoraSidebarActionDetails({
    required this.globalBounds,
    required this.anchor,
    this.overlayBounds = Rect.zero,
    this.overlaySize = Size.zero,
  });

  /// Creates geometry for the render object at [context].
  ///
  /// The result is empty when the target has not been laid out yet.
  factory LinagoraSidebarActionDetails.fromContext(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return const LinagoraSidebarActionDetails(
        globalBounds: Rect.fromLTWH(0, 0, 0, 0),
        anchor: RelativeRect.fromLTRB(0, 0, 0, 0),
      );
    }

    final Rect globalBounds =
        renderBox.localToGlobal(Offset.zero) & renderBox.size;
    final RenderBox? overlayBox =
        Overlay.maybeOf(context, rootOverlay: true)?.context.findRenderObject()
            as RenderBox?;
    final Size overlaySize =
        overlayBox?.size ?? MediaQuery.maybeOf(context)?.size ?? renderBox.size;
    final Rect overlayBounds = overlayBox == null
        ? globalBounds
        : renderBox.localToGlobal(Offset.zero, ancestor: overlayBox) &
              renderBox.size;

    return LinagoraSidebarActionDetails(
      globalBounds: globalBounds,
      anchor: RelativeRect.fromRect(overlayBounds, Offset.zero & overlaySize),
      overlayBounds: overlayBounds,
      overlaySize: overlaySize,
    );
  }

  /// Bounds of the action's touch target in global coordinates.
  final Rect globalBounds;

  /// Bounds relative to the root overlay, suitable for popup positioning.
  final RelativeRect anchor;

  /// Bounds in the same root-overlay coordinate space as [anchor].
  final Rect overlayBounds;

  /// Root overlay size used to calculate [anchor].
  final Size overlaySize;

  /// A zero-size [RelativeRect] at the trigger centre.
  RelativeRect get pointAnchor {
    if (overlaySize != Size.zero) {
      return RelativeRect.fromLTRB(
        overlayBounds.center.dx,
        overlayBounds.center.dy,
        overlaySize.width - overlayBounds.center.dx,
        overlaySize.height - overlayBounds.center.dy,
      );
    }

    return RelativeRect.fromLTRB(
      anchor.left + globalBounds.width / 2,
      anchor.top + globalBounds.height / 2,
      anchor.right + globalBounds.width / 2,
      anchor.bottom + globalBounds.height / 2,
    );
  }

  /// A zero-size [RelativeRect] under the action's directional start edge.
  RelativeRect belowMenuAnchor(TextDirection textDirection) {
    final bounds = overlayBounds;
    final size = overlaySize;
    if (size == Size.zero) return pointAnchor;

    final bottom = size.height - bounds.bottom;
    if (textDirection == TextDirection.ltr) {
      return RelativeRect.fromLTRB(
        bounds.left,
        bounds.bottom,
        size.width - bounds.left,
        bottom,
      );
    }

    return RelativeRect.fromLTRB(
      bounds.right,
      bounds.bottom,
      size.width - bounds.right,
      bottom,
    );
  }
}
