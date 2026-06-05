import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/chat/bubble_shape.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// A rounded, filled chat message bubble with an optional tail, holding [child].
///
/// When [color] / [padding] are null they fall back to the design-system
/// defaults (own vs received color from [isOwnMessage], [kBubbleContentPadding]).
/// [hasReactions] reserves [kMessageReactionsOverlayHeight] below the bubble for
/// the reactions overlay.
class MessageBubble extends StatelessWidget {
  final Widget child;

  final bool isOwnMessage;

  final Color? color;

  final BubbleTailDirection tailDirection;

  final BorderRadius borderRadius;

  final EdgeInsetsGeometry? padding;

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
    this.shadows = kBubbleShadow,
    this.constraints,
    this.hasReactions = false,
  });

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
      padding: padding ?? kBubbleContentPadding,
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
