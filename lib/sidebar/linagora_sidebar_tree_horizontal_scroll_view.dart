import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

/// Hosts a sidebar in a stable horizontal viewport.
///
/// The host sidebar keeps ownership of vertical scrolling and virtualization.
/// Keeping this viewport in the tree without overflow prevents Flutter from
/// recreating the vertical list and losing its position when an expanded node
/// first needs horizontal scrolling.
class LinagoraSidebarTreeHorizontalScrollView extends StatefulWidget {
  const LinagoraSidebarTreeHorizontalScrollView({
    super.key,
    required this.child,
    required this.overflowWidth,
  }) : assert(overflowWidth >= 0, 'Sidebar overflow width cannot be negative');

  final Widget child;

  /// Width needed beyond the sidebar viewport for the deepest visible row.
  final double overflowWidth;

  @override
  State<LinagoraSidebarTreeHorizontalScrollView> createState() =>
      _LinagoraSidebarTreeHorizontalScrollViewState();
}

class _LinagoraSidebarTreeHorizontalScrollViewState
    extends State<LinagoraSidebarTreeHorizontalScrollView> {
  static final _dragDevices = Set<PointerDeviceKind>.unmodifiable(
    PointerDeviceKind.values,
  );

  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(
    covariant LinagoraSidebarTreeHorizontalScrollView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.overflowWidth > 0 &&
        widget.overflowWidth == 0 &&
        _scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canScrollHorizontally =
            constraints.hasBoundedWidth && widget.overflowWidth > 0;
        final contentWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth +
                (canScrollHorizontally ? widget.overflowWidth : 0)
            : null;

        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(dragDevices: _dragDevices),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: canScrollHorizontally,
            trackVisibility: canScrollHorizontally,
            interactive: canScrollHorizontally,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: canScrollHorizontally
                  ? null
                  : const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: contentWidth,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
