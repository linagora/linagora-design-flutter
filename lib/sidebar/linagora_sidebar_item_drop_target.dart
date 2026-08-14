import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_callback_utils.dart';

/// Decides whether a dragged value can be dropped on a sidebar item.
typedef OnLinagoraSidebarItemWillAcceptDrop<T extends Object> =
    bool Function(LinagoraSidebarItemDropDetails<T> details);

/// Reports a value dropped on a sidebar item.
///
/// The return value may complete asynchronously, allowing the product to
/// persist a move or another business operation without the design system
/// knowing the dragged domain type.
typedef OnLinagoraSidebarItemDrop<T extends Object> =
    FutureOr<void> Function(LinagoraSidebarItemDropDetails<T> details);

/// Typed information about a value dropped on a sidebar item.
class LinagoraSidebarItemDropDetails<T extends Object> {
  const LinagoraSidebarItemDropDetails({
    required this.data,
    required this.offset,
  });

  /// The product-owned value from the [Draggable] that was accepted.
  final T data;

  /// Drop position in the target's global coordinate space.
  final Offset offset;
}

/// Adds typed drop handling around a sidebar item without coupling the row's
/// base API to drag and drop.
class LinagoraSidebarItemDropTarget<T extends Object> extends StatelessWidget {
  const LinagoraSidebarItemDropTarget({
    super.key,
    required this.child,
    required this.onDrop,
    this.onWillAcceptDrop,
  });

  final Widget child;

  final OnLinagoraSidebarItemWillAcceptDrop<T>? onWillAcceptDrop;

  final OnLinagoraSidebarItemDrop<T> onDrop;

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onWillAcceptWithDetails: _willAcceptDrop,
      onAcceptWithDetails: _acceptDrop,
      builder: (context, candidateData, rejectedData) => child,
    );
  }

  bool _willAcceptDrop(DragTargetDetails<T> details) {
    final callback = onWillAcceptDrop;
    if (callback == null) return true;
    return callback(_details(details));
  }

  void _acceptDrop(DragTargetDetails<T> details) {
    unawaited(
      runLinagoraSidebarCallback(
        () => onDrop(_details(details)),
        callbackName: 'LinagoraSidebarItemDropTarget.onDrop',
      ),
    );
  }

  LinagoraSidebarItemDropDetails<T> _details(DragTargetDetails<T> details) {
    return LinagoraSidebarItemDropDetails<T>(
      data: details.data,
      offset: details.offset,
    );
  }
}
