import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// Lays out [reactions] over the bottom of [bubble], [reactionsInset] after
/// its start edge. Reactions wider than the bubble extend past it, away from
/// the side the bubble is aligned to.
class BubbleWithReactions extends MultiChildRenderObjectWidget {
  BubbleWithReactions({
    super.key,
    required Widget bubble,
    required Widget reactions,
    required this.isBubbleAlignedToEnd,
    this.reactionsInset = LinagoraSpacing.base,
  }) : super(children: [bubble, reactions]);

  final bool isBubbleAlignedToEnd;
  final double reactionsInset;

  @override
  RenderBubbleWithReactions createRenderObject(BuildContext context) {
    return RenderBubbleWithReactions(
      isBubbleAlignedToEnd: isBubbleAlignedToEnd,
      reactionsInset: reactionsInset,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderBubbleWithReactions renderObject,
  ) {
    renderObject
      ..isBubbleAlignedToEnd = isBubbleAlignedToEnd
      ..reactionsInset = reactionsInset
      ..textDirection = Directionality.of(context);
  }
}

class _ParentData extends ContainerBoxParentData<RenderBox> {}

/// Render object of [BubbleWithReactions].
class RenderBubbleWithReactions extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ParentData> {
  RenderBubbleWithReactions({
    required bool isBubbleAlignedToEnd,
    required double reactionsInset,
    required TextDirection textDirection,
  }) : _isBubbleAlignedToEnd = isBubbleAlignedToEnd,
       _reactionsInset = reactionsInset,
       _textDirection = textDirection;

  bool get isBubbleAlignedToEnd => _isBubbleAlignedToEnd;
  bool _isBubbleAlignedToEnd;
  set isBubbleAlignedToEnd(bool value) {
    if (_isBubbleAlignedToEnd == value) return;
    _isBubbleAlignedToEnd = value;
    markNeedsLayout();
  }

  double get reactionsInset => _reactionsInset;
  double _reactionsInset;
  set reactionsInset(double value) {
    if (_reactionsInset == value) return;
    _reactionsInset = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  RenderBox get _bubble => firstChild!;
  RenderBox get _reactions => lastChild!;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ParentData) child.parentData = _ParentData();
  }

  BoxConstraints _reactionsConstraints(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: math.max(0, constraints.maxWidth - _reactionsInset),
      maxHeight: constraints.maxHeight,
    );
  }

  Size _sizeFor(BoxConstraints constraints, Size bubble, Size reactions) {
    return constraints.constrain(
      Size(
        math.max(bubble.width, reactions.width + _reactionsInset),
        math.max(bubble.height, reactions.height),
      ),
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) => math.max(
    _bubble.getMinIntrinsicWidth(height),
    _reactions.getMinIntrinsicWidth(height) + _reactionsInset,
  );

  @override
  double computeMaxIntrinsicWidth(double height) => math.max(
    _bubble.getMaxIntrinsicWidth(height),
    _reactions.getMaxIntrinsicWidth(height) + _reactionsInset,
  );

  @override
  double computeMinIntrinsicHeight(double width) => math.max(
    _bubble.getMinIntrinsicHeight(width),
    _reactions.getMinIntrinsicHeight(width),
  );

  @override
  double computeMaxIntrinsicHeight(double width) => math.max(
    _bubble.getMaxIntrinsicHeight(width),
    _reactions.getMaxIntrinsicHeight(width),
  );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _sizeFor(
      constraints,
      _bubble.getDryLayout(constraints.loosen()),
      _reactions.getDryLayout(_reactionsConstraints(constraints)),
    );
  }

  @override
  void performLayout() {
    _bubble.layout(constraints.loosen(), parentUsesSize: true);
    _reactions.layout(_reactionsConstraints(constraints), parentUsesSize: true);
    size = _sizeFor(constraints, _bubble.size, _reactions.size);

    final isRtl = _textDirection == TextDirection.rtl;
    double dxFromStart(double start, double childWidth) =>
        isRtl ? size.width - start - childWidth : start;

    (_bubble.parentData! as _ParentData).offset = Offset(
      dxFromStart(
        _isBubbleAlignedToEnd ? size.width - _bubble.size.width : 0,
        _bubble.size.width,
      ),
      0,
    );
    (_reactions.parentData! as _ParentData).offset = Offset(
      dxFromStart(_reactionsInset, _reactions.size.width),
      size.height - _reactions.size.height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
