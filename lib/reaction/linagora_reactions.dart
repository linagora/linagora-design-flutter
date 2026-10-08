import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:linagora_design_flutter/reaction/linagora_reaction_chip.dart';

/// The reactions row displayed under a message bubble.
///
/// Shows the first [maxDisplayed] reactions, or fewer when they do not fit its
/// width. The others are summed up in a `+N` chip, which replaces the "more"
/// button to open the full list.
class LinagoraReactions extends StatelessWidget {
  static const int maxDisplayed = 3;

  /// Sorted by display priority.
  final List<LinagoraReactionChip> reactions;

  /// Opens the full list of reactions, on tap. The "more" button is hidden
  /// when null.
  ///
  /// The details are those of the tap down, to anchor a popup. Without pointer
  /// (keyboard, screen reader), they point at the center of the chip.
  final GestureTapDownCallback? onShowAll;

  /// Read by screen readers on the chip opening the full list of reactions.
  final String? showAllSemanticLabel;

  const LinagoraReactions({
    super.key,
    required this.reactions,
    this.onShowAll,
    this.showAllSemanticLabel,
  });

  /// The chip closing the row when it shows [displayed] reactions.
  Widget? _trailing(int displayed) {
    final remaining = reactions.length - displayed;
    final onShowAll = this.onShowAll;
    if (onShowAll != null) {
      return _ShowAllChip(
        remaining: remaining,
        semanticLabel: showAllSemanticLabel,
        onShowAll: onShowAll,
      );
    }
    if (remaining > 0) {
      return LinagoraReactionChip.remaining(
        count: remaining,
        semanticLabel: showAllSemanticLabel,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final displayed = reactions.take(maxDisplayed).toList();
    final trailings = reactions.isEmpty
        ? const <Widget>[]
        : [
            for (var count = displayed.length; count >= 0; count--)
              ?_trailing(count),
          ];

    return _FittingRow(
      reactionCount: displayed.length,
      spacing: LinagoraReactionChip.spacing,
      textDirection: Directionality.of(context),
      children: [...displayed, ...trailings],
    );
  }
}

/// Lays out as many of its first [reactionCount] children as its width allows,
/// followed by the trailing chip matching that number.
///
/// The trailing chips are the children after the reactions: one for each
/// number of displayed reactions, from the highest to none. The one for all the
/// reactions is missing when there is nothing left to show.
///
/// A [Row] would overflow instead, and a [LayoutBuilder] would not know the
/// width of the chips nor support the intrinsic sizes asked by the bubble.
class _FittingRow extends MultiChildRenderObjectWidget {
  final int reactionCount;
  final double spacing;
  final TextDirection textDirection;

  const _FittingRow({
    required this.reactionCount,
    required this.spacing,
    required this.textDirection,
    required super.children,
  });

  @override
  MultiChildRenderObjectElement createElement() => _FittingRowElement(this);

  @override
  _RenderFittingRow createRenderObject(BuildContext context) {
    return _RenderFittingRow(
      reactionCount: reactionCount,
      spacing: spacing,
      textDirection: textDirection,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderFittingRow renderObject,
  ) {
    renderObject
      ..reactionCount = reactionCount
      ..spacing = spacing
      ..textDirection = textDirection;
  }
}

class _FittingRowElement extends MultiChildRenderObjectElement {
  _FittingRowElement(_FittingRow super.widget);

  // Keeps the chips left out of the row away from the finders of the tests.
  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    final row = renderObject as _RenderFittingRow;
    for (final child in children) {
      if (row.isDisplayed(child.renderObject)) visitor(child);
    }
  }
}

class _FittingRowParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderFittingRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _FittingRowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _FittingRowParentData> {
  _RenderFittingRow({
    required int reactionCount,
    required double spacing,
    required TextDirection textDirection,
  }) : _reactionCount = reactionCount,
       _spacing = spacing,
       _textDirection = textDirection;

  int get reactionCount => _reactionCount;
  int _reactionCount;
  set reactionCount(int value) {
    if (_reactionCount == value) return;
    _reactionCount = value;
    markNeedsLayout();
  }

  double get spacing => _spacing;
  double _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  List<RenderBox> _displayed = const [];

  bool isDisplayed(RenderObject? child) => _displayed.contains(child);

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _FittingRowParentData) {
      child.parentData = _FittingRowParentData();
    }
  }

  /// The children of the row showing [count] reactions.
  List<RenderBox> _childrenFor(List<RenderBox> children, int count) {
    final trailings = children.sublist(_reactionCount);
    // Without trailing chip for all the reactions, the first one is for one
    // reaction less.
    final index = trailings.length - 1 - count;
    return [...children.take(count), if (index >= 0) trailings[index]];
  }

  double _widthOf(Iterable<double> widths) => widths.isEmpty
      ? 0
      : widths.reduce((a, b) => a + b) + _spacing * (widths.length - 1);

  /// The widest row fitting [maxWidth], down to its trailing chip alone.
  List<RenderBox> _fit(double maxWidth, double Function(RenderBox) widthOf) {
    final children = getChildrenAsList();
    for (var count = _reactionCount; count > 0; count--) {
      final row = _childrenFor(children, count);
      if (_widthOf(row.map(widthOf)) <= maxWidth + precisionErrorTolerance) {
        return row;
      }
    }
    return _childrenFor(children, 0);
  }

  Size _sizeFor(
    BoxConstraints constraints,
    List<RenderBox> row,
    Size Function(RenderBox) sizeOf,
  ) {
    final sizes = row.map(sizeOf);
    return constraints.constrain(
      Size(
        _widthOf(sizes.map((size) => size.width)),
        sizes.map((size) => size.height).fold(0, math.max),
      ),
    );
  }

  BoxConstraints _childConstraints(BoxConstraints constraints) =>
      BoxConstraints(maxHeight: constraints.maxHeight);

  @override
  double computeMinIntrinsicWidth(double height) => _widthOf(
    _childrenFor(
      getChildrenAsList(),
      0,
    ).map((child) => child.getMinIntrinsicWidth(height)),
  );

  @override
  double computeMaxIntrinsicWidth(double height) => _widthOf(
    _childrenFor(
      getChildrenAsList(),
      _reactionCount,
    ).map((child) => child.getMaxIntrinsicWidth(height)),
  );

  @override
  double computeMinIntrinsicHeight(double width) => getChildrenAsList()
      .map((child) => child.getMinIntrinsicHeight(double.infinity))
      .fold(0, math.max);

  @override
  double computeMaxIntrinsicHeight(double width) => getChildrenAsList()
      .map((child) => child.getMaxIntrinsicHeight(double.infinity))
      .fold(0, math.max);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final childConstraints = _childConstraints(constraints);
    Size sizeOf(RenderBox child) => child.getDryLayout(childConstraints);
    final row = _fit(constraints.maxWidth, (child) => sizeOf(child).width);
    return _sizeFor(constraints, row, sizeOf);
  }

  @override
  void performLayout() {
    final childConstraints = _childConstraints(constraints);
    for (final child in getChildrenAsList()) {
      child.layout(childConstraints, parentUsesSize: true);
    }
    _displayed = _fit(constraints.maxWidth, (child) => child.size.width);
    size = _sizeFor(constraints, _displayed, (child) => child.size);

    var start = 0.0;
    for (final child in _displayed) {
      (child.parentData! as _FittingRowParentData).offset = Offset(
        _textDirection == TextDirection.rtl
            ? size.width - start - child.size.width
            : start,
        (size.height - child.size.height) / 2,
      );
      start += child.size.width + _spacing;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in _displayed) {
      final parentData = child.parentData! as _FittingRowParentData;
      context.paintChild(child, parentData.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in _displayed.reversed) {
      final parentData = child.parentData! as _FittingRowParentData;
      final isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed),
      );
      if (isHit) return true;
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    _displayed.forEach(visitor);
  }
}

class _ShowAllChip extends StatefulWidget {
  final int remaining;
  final String? semanticLabel;
  final GestureTapDownCallback onShowAll;

  const _ShowAllChip({
    required this.remaining,
    required this.semanticLabel,
    required this.onShowAll,
  });

  @override
  State<_ShowAllChip> createState() => _ShowAllChipState();
}

class _ShowAllChipState extends State<_ShowAllChip> {
  TapDownDetails? _tapDown;

  void _rememberTapDown(TapDownDetails details) => _tapDown = details;

  void _showAll() {
    final box = context.findRenderObject()! as RenderBox;
    final details =
        _tapDown ??
        TapDownDetails(
          globalPosition: box.localToGlobal(box.size.center(Offset.zero)),
        );
    _tapDown = null;
    widget.onShowAll(details);
  }

  @override
  Widget build(BuildContext context) {
    return widget.remaining > 0
        ? LinagoraReactionChip.remaining(
            count: widget.remaining,
            semanticLabel: widget.semanticLabel,
            onTap: _showAll,
            onTapDown: _rememberTapDown,
          )
        : LinagoraReactionChip.more(
            semanticLabel: widget.semanticLabel,
            onTap: _showAll,
            onTapDown: _rememberTapDown,
          );
  }
}
