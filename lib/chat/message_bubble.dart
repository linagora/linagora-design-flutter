import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/chat/bubble_shape.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// The kind of content a [MessageBubble] holds, used to pick its inner padding.
enum BubbleContentType {
  /// The bubble's sole content is a media element (image/video).
  mediaOnly,

  /// Default: any other content (text, file, caption, reply…).
  other,
}

/// A rounded, filled chat message bubble with an optional tail, holding [child].
///
/// When [color] is null it falls back to the design-system default (own vs
/// received color from [isOwnMessage]). When [padding] is null the inner
/// padding is resolved from [contentType]. [hasReactions] reserves
/// [kMessageReactionsOverlayHeight] below the bubble for the reactions overlay.
class MessageBubble extends StatelessWidget {
  final Widget child;

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

  final bool hasReactions;

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
    this.hasReactions = false,
  });

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
    return Container(
      constraints: constraints,
      margin: hasReactions
          ? const EdgeInsets.only(bottom: kMessageReactionsOverlayHeight)
          : null,
      padding: _resolvedPadding,
      decoration: ShapeDecoration(
        color: _resolvedColor,
        shadows: shadows,
        shape: BubbleShape(
          borderRadius: borderRadius,
          tailDirection: tailDirection,
        ),
      ),
      child: child,
    );
  }
}
