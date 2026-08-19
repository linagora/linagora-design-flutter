import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_scroll_coordinator.dart';

/// Auto-scroll targets shown at the top and bottom of a sidebar's scrollable
/// body while a drag operation is active.
///
/// Place this in [LinagoraSidebarMenu.bodyOverlay] so the targets stay within
/// the navigation viewport and never overlap a pinned footer.
class LinagoraSidebarAutoScrollOverlay extends StatefulWidget {
  static const double edgeExtent = 40;
  static const double edgeThreshold = edgeExtent;

  const LinagoraSidebarAutoScrollOverlay({
    super.key,
    required this.isDragging,
    this.controller,
    this.canScrollToStart,
    this.canScrollToEnd,
    this.onScrollToStart,
    this.onScrollToEnd,
    this.onStopScrolling,
  });

  final bool isDragging;
  /// Defaults to the controller supplied by [LinagoraSidebarMenu].
  final ScrollController? controller;

  /// Legacy product-owned scroll state. Supplying [controller] removes the
  /// need to manage these flags and callbacks in every application.
  final bool? canScrollToStart;
  final bool? canScrollToEnd;
  final VoidCallback? onScrollToStart;
  final VoidCallback? onScrollToEnd;
  final VoidCallback? onStopScrolling;

  @override
  State<LinagoraSidebarAutoScrollOverlay> createState() =>
      _LinagoraSidebarAutoScrollOverlayState();
}

class _LinagoraSidebarAutoScrollOverlayState
    extends State<LinagoraSidebarAutoScrollOverlay> {
  ScrollController? _listenedController;
  ScrollController? _autoScrollingController;
  int _scrollAnimationId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }

  @override
  void didUpdateWidget(covariant LinagoraSidebarAutoScrollOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDragging && !widget.isDragging) {
      _stopScrolling();
    }
    if (oldWidget.controller != widget.controller ||
        oldWidget.isDragging != widget.isDragging) {
      _updateController();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDragging) return const SizedBox.shrink();

    return Stack(
      children: [
        if (_canScrollToStart)
          Align(
            alignment: Alignment.topCenter,
            child: _AutoScrollEdge(
              onHover: _scrollToStart,
              onExit: _stopScrolling,
            ),
          ),
        if (_canScrollToEnd)
          Align(
            alignment: Alignment.bottomCenter,
            child: _AutoScrollEdge(
              onHover: _scrollToEnd,
              onExit: _stopScrolling,
            ),
          ),
      ],
    );
  }

  /// An explicitly supplied controller always wins. Otherwise, using any of
  /// the legacy fields opts into the product-owned callback API instead of
  /// silently taking control of an ambient menu scroll controller.
  ScrollController? get _controller {
    if (widget.controller != null) return widget.controller;
    if (_usesLegacyCallbacks) return null;
    return LinagoraSidebarScrollCoordinator.maybeOf(context)?.controller;
  }

  bool get _usesLegacyCallbacks =>
      widget.canScrollToStart != null ||
      widget.canScrollToEnd != null ||
      widget.onScrollToStart != null ||
      widget.onScrollToEnd != null ||
      widget.onStopScrolling != null;

  bool get _canScrollToStart {
    final controller = _controller;
    if (controller != null) {
      if (!controller.hasClients || !controller.position.hasContentDimensions) {
        return false;
      }
      final position = controller.position;
      return position.pixels - position.minScrollExtent >
          LinagoraSidebarAutoScrollOverlay.edgeThreshold;
    }
    return widget.canScrollToStart ?? false;
  }

  bool get _canScrollToEnd {
    final controller = _controller;
    if (controller != null) {
      if (!controller.hasClients || !controller.position.hasContentDimensions) {
        return false;
      }
      final position = controller.position;
      return position.maxScrollExtent - position.pixels >
          LinagoraSidebarAutoScrollOverlay.edgeThreshold;
    }
    return widget.canScrollToEnd ?? false;
  }

  void _updateController() {
    final controller = widget.isDragging ? _controller : null;
    if (!identical(_listenedController, controller)) {
      _cancelAutoScroll();
    }
    if (identical(_listenedController, controller)) return;

    _listenedController?.removeListener(_onControllerChanged);
    _listenedController = controller;
    _listenedController?.addListener(_onControllerChanged);
    if (_listenedController == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onControllerChanged();
    });
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _scrollToStart() {
    final controller = _controller;
    if (controller == null) {
      widget.onScrollToStart?.call();
      return;
    }
    if (!controller.hasClients || !controller.position.hasContentDimensions) {
      return;
    }

    _animateTo(controller, controller.position.minScrollExtent);
  }

  void _scrollToEnd() {
    final controller = _controller;
    if (controller == null) {
      widget.onScrollToEnd?.call();
      return;
    }
    if (!controller.hasClients || !controller.position.hasContentDimensions) {
      return;
    }

    _animateTo(controller, controller.position.maxScrollExtent);
  }

  void _stopScrolling() {
    final controller = _controller;
    if (controller == null) {
      widget.onStopScrolling?.call();
      return;
    }
    _cancelAutoScroll();
  }

  void _animateTo(ScrollController controller, double offset) {
    _cancelAutoScroll();
    final animationId = ++_scrollAnimationId;
    _autoScrollingController = controller;
    controller
        .animateTo(
          offset,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInToLinear,
        )
        .whenComplete(() {
          if (_scrollAnimationId == animationId) {
            _autoScrollingController = null;
          }
        });
  }

  void _cancelAutoScroll() {
    final controller = _autoScrollingController;
    if (controller == null) return;

    _scrollAnimationId++;
    _autoScrollingController = null;
    if (!controller.hasClients || !controller.position.hasContentDimensions) {
      return;
    }

    // `jumpTo` interrupts the active ScrollActivity without starting another
    // animation, so a drag ending while an edge is hovered leaves the list at
    // its current offset.
    controller.jumpTo(controller.offset);
  }

  @override
  void dispose() {
    _listenedController?.removeListener(_onControllerChanged);
    _cancelAutoScroll();
    super.dispose();
  }
}

class _AutoScrollEdge extends StatelessWidget {
  const _AutoScrollEdge({
    required this.onHover,
    required this.onExit,
  });

  final VoidCallback onHover;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (isHovered) => isHovered ? onHover() : onExit(),
      child: const SizedBox(
        width: double.infinity,
        height: LinagoraSidebarAutoScrollOverlay.edgeExtent,
      ),
    );
  }
}
