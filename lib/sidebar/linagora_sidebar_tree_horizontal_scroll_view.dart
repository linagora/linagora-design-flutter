import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Hosts a tree list in a stable horizontal viewport.
///
/// The tree keeps ownership of vertical scrolling and virtualization. Keeping
/// this viewport in the tree without overflow prevents Flutter from recreating
/// the vertical list and losing its position when an expanded node first needs
/// horizontal scrolling.
class LinagoraSidebarTreeHorizontalScrollView extends StatefulWidget {
  const LinagoraSidebarTreeHorizontalScrollView({
    super.key,
    required this.child,
    required this.overflowWidth,
  }) : assert(
         overflowWidth >= 0 && overflowWidth < double.infinity,
         'Sidebar overflow width must be finite and non-negative',
       );

  final Widget child;

  /// Width needed beyond the sidebar viewport for the deepest visible row.
  final double overflowWidth;

  /// Builds a sliver whose rows pan horizontally as one tree-only region.
  ///
  /// A sliver must remain inside its host's vertical viewport, so it cannot
  /// use the box scroll view above without also moving the host's other
  /// content. This keeps the horizontal gesture and wider row layout local to
  /// the tree rows instead.
  static Widget sliver({
    required SliverChildBuilderDelegate delegate,
    required double overflowWidth,
  }) => _LinagoraSidebarSliverTreeHorizontalScroll(
    delegate: delegate,
    overflowWidth: overflowWidth,
  );

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

class _LinagoraSidebarSliverTreeHorizontalScroll extends StatefulWidget {
  const _LinagoraSidebarSliverTreeHorizontalScroll({
    required this.delegate,
    required this.overflowWidth,
  }) : assert(
         overflowWidth >= 0 && overflowWidth < double.infinity,
         'Sidebar overflow width must be finite and non-negative',
       );

  final SliverChildBuilderDelegate delegate;
  final double overflowWidth;

  @override
  State<_LinagoraSidebarSliverTreeHorizontalScroll> createState() =>
      _LinagoraSidebarSliverTreeHorizontalScrollState();
}

class _LinagoraSidebarSliverTreeHorizontalScrollState
    extends State<_LinagoraSidebarSliverTreeHorizontalScroll> {
  final ValueNotifier<double> _offset = ValueNotifier(0);

  @override
  void didUpdateWidget(
    covariant _LinagoraSidebarSliverTreeHorizontalScroll oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.overflowWidth != widget.overflowWidth) {
      _offset.value = _offset.value.clamp(0, widget.overflowWidth).toDouble();
    }
  }

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delegate = widget.delegate;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final child = delegate.builder(context, index);
          if (child == null) return null;

          return KeyedSubtree(
            key: child.key,
            child: _LinagoraSidebarTreeHorizontalScrollRow(
              offset: _offset,
              overflowWidth: widget.overflowWidth,
              child: child,
            ),
          );
        },
        childCount: delegate.estimatedChildCount,
        findChildIndexCallback: delegate.findChildIndexCallback,
      ),
    );
  }
}

class _LinagoraSidebarTreeHorizontalScrollRow extends StatelessWidget {
  const _LinagoraSidebarTreeHorizontalScrollRow({
    required this.offset,
    required this.overflowWidth,
    required this.child,
  });

  final ValueNotifier<double> offset;
  final double overflowWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canScrollHorizontally =
            constraints.hasBoundedWidth && overflowWidth > 0;
        final contentWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth +
                (canScrollHorizontally ? overflowWidth : 0)
            : null;

        if (!constraints.hasBoundedWidth) return child;

        return GestureDetector(
          onHorizontalDragUpdate: canScrollHorizontally
              ? (details) {
                  final nextOffset = offset.value - details.delta.dx;
                  offset.value = nextOffset.clamp(0, overflowWidth).toDouble();
                }
              : null,
          child: ValueListenableBuilder<double>(
            valueListenable: offset,
            builder: (context, value, _) {
              final textDirection = Directionality.of(context);
              final translation = textDirection == TextDirection.rtl
                  ? value
                  : -value;
              return _LinagoraSidebarTreeHorizontalViewport(
                contentWidth: contentWidth!,
                translation: translation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}

class _LinagoraSidebarTreeHorizontalViewport
    extends SingleChildRenderObjectWidget {
  const _LinagoraSidebarTreeHorizontalViewport({
    required this.contentWidth,
    required this.translation,
    required super.child,
  });

  final double contentWidth;
  final double translation;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderLinagoraSidebarTreeHorizontalViewport(
        contentWidth: contentWidth,
        translation: translation,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderLinagoraSidebarTreeHorizontalViewport renderObject,
  ) {
    renderObject
      ..contentWidth = contentWidth
      ..translation = translation;
  }
}

class _RenderLinagoraSidebarTreeHorizontalViewport extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderLinagoraSidebarTreeHorizontalViewport({
    required double contentWidth,
    required double translation,
  }) : _contentWidth = contentWidth,
       _translation = translation;

  double _contentWidth;
  double _translation;

  set contentWidth(double value) {
    if (_contentWidth == value) return;
    _contentWidth = value;
    markNeedsLayout();
  }

  set translation(double value) {
    if (_translation == value) return;
    _translation = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.constrain(Size.zero);
      return;
    }

    child.layout(
      constraints.copyWith(minWidth: _contentWidth, maxWidth: _contentWidth),
      parentUsesSize: true,
    );
    size = constraints.constrain(
      Size(constraints.maxWidth, child.size.height),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;

    context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      (context, offset) => child.paint(
        context,
        offset + Offset(_translation, 0),
      ),
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null || !size.contains(position)) return false;

    return result.addWithPaintOffset(
      offset: Offset(_translation, 0),
      position: position,
      hitTest: (result, position) => child.hitTest(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.translateByDouble(_translation, 0, 0, 1);
  }
}
