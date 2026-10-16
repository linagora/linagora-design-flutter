import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/chat/bubble_shape.dart';
import 'package:linagora_design_flutter/chat/bubble_with_reactions.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// The kind of content a [MessageBubble] holds, used to pick its inner padding.
enum BubbleContentType {
  /// The bubble's sole content is a media element (image/video).
  mediaOnly,

  /// Default: any other content (text, file, caption, reply…).
  other,
}

/// Figma bubble body inner padding: 12 horizontal, 8 top, 0 bottom.
const EdgeInsets kBubbleContentPadding = EdgeInsets.only(
  left: LinagoraSpacing.base * 1.5,
  right: LinagoraSpacing.base * 1.5,
  top: LinagoraSpacing.base,
);

/// Inner padding for a bubble whose sole content is a media element
/// (image/video): 4px on every side.
const EdgeInsets kBubbleMediaContentPadding = EdgeInsets.all(
  LinagoraSpacing.base * 0.5,
);

/// Figma "Body" drop shadow: y1.22, blur0.61, black at 10%.
const List<BoxShadow> kBubbleShadow = [
  BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 1.22),
    blurRadius: 0.61,
  ),
];

/// Vertical space reserved below a bubble for the reactions overlay.
const double kMessageReactionsOverlayHeight = LinagoraSpacing.base * 3;

/// A rounded, filled chat message bubble with an optional tail, holding [child].
///
/// When [color] is null it falls back to the design-system default (own vs
/// received color from [isOwnMessage]). When [padding] is null the inner
/// padding is resolved from [contentType]. [reactions] is laid over the bottom
/// of the bubble, with [kMessageReactionsOverlayHeight] reserved below it.
class MessageBubble extends StatelessWidget {
  final Widget child;

  /// Picks the default [color] only. It says nothing about the side the bubble
  /// sits on: see [isAlignedToEnd].
  final bool isOwnMessage;

  final Color? color;

  final BubbleTailDirection tailDirection;

  final BorderRadius borderRadius;

  /// Explicit inner padding override. When null, the padding is derived from
  /// [contentType].
  final EdgeInsetsGeometry? padding;

  final BubbleContentType contentType;

  final List<BoxShadow> shadows;

  final BoxConstraints? constraints;

  /// The reactions row. When wider than the bubble, it extends past it.
  final Widget? reactions;

  /// Whether the bubble is aligned to the end of its row, so that wider
  /// [reactions] extend towards the start.
  ///
  /// Cannot be derived from [tailDirection], which is
  /// [BubbleTailDirection.none] for a message without tail, nor from
  /// [isOwnMessage], as own messages may be aligned to the start.
  final bool isAlignedToEnd;

  final bool _isDecorated;

  const MessageBubble({
    super.key,
    required this.child,
    this.isOwnMessage = false,
    this.color,
    this.tailDirection = BubbleTailDirection.none,
    this.borderRadius = BubbleRadius.all,
    this.padding,
    this.contentType = BubbleContentType.other,
    this.shadows = kBubbleShadow,
    this.constraints,
    this.reactions,
    this.isAlignedToEnd = false,
  }) : _isDecorated = true;

  /// A message without bubble decoration, such as an emoji-only message.
  const MessageBubble.plain({
    super.key,
    required this.child,
    this.constraints,
    this.reactions,
    this.isAlignedToEnd = false,
  }) : isOwnMessage = false,
       color = null,
       tailDirection = BubbleTailDirection.none,
       borderRadius = BubbleRadius.all,
       padding = EdgeInsets.zero,
       contentType = BubbleContentType.other,
       shadows = const [],
       _isDecorated = false;

  EdgeInsetsGeometry get _resolvedPadding =>
      padding ??
      switch (contentType) {
        BubbleContentType.mediaOnly => kBubbleMediaContentPadding,
        BubbleContentType.other => kBubbleContentPadding,
      };

  Color get _resolvedColor =>
      color ??
      (isOwnMessage
          ? LinagoraRefColors.material().primary[95]!
          : LinagoraSysColors.material().onPrimary);

  @override
  Widget build(BuildContext context) {
    final reactions = this.reactions;
    final bubble = Container(
      constraints: constraints,
      margin: reactions != null
          ? const EdgeInsets.only(bottom: kMessageReactionsOverlayHeight)
          : null,
      padding: _resolvedPadding,
      decoration: _isDecorated
          ? ShapeDecoration(
              color: _resolvedColor,
              shadows: shadows,
              shape: BubbleShape(
                borderRadius: borderRadius,
                tailDirection: tailDirection,
              ),
            )
          : null,
      child: child,
    );
    if (reactions == null) return bubble;

    return BubbleWithReactions(
      isBubbleAlignedToEnd: isAlignedToEnd,
      bubble: bubble,
      reactions: reactions,
    );
  }
}
