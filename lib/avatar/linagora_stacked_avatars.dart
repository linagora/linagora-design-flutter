import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/avatar/linagora_stacked_avatars_style.dart';

/// Overlapping round avatars, e.g. "me + the owner" while viewing a
/// delegated mailbox. Later avatars sit on top; beyond [maxVisible] the rest
/// are summed up in a "+N" bubble.
class LinagoraStackedAvatars extends StatelessWidget {
  final List<Widget> avatars;
  final int maxVisible;

  /// Announced instead of the individual avatars, such as "You and Nora Hale".
  final String? semanticLabel;
  final LinagoraStackedAvatarsStyle? style;

  const LinagoraStackedAvatars({
    super.key,
    required this.avatars,
    this.maxVisible = 3,
    this.semanticLabel,
    this.style,
  }) : assert(maxVisible > 0, 'maxVisible must be positive');

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();

    final tokens = style ?? LinagoraStackedAvatarsStyle.material();
    final size = tokens.size;

    final visible = avatars.take(maxVisible).toList();
    final hidden = avatars.length - visible.length;
    final bubbles = [
      ...visible,
      if (hidden > 0)
        _OverflowBubble(
          count: hidden,
          color: tokens.overflowColor,
          textStyle: tokens.overflowTextStyle,
        ),
    ];
    final step = size - tokens.overlap;
    final width = size + step * (bubbles.length - 1);

    final stack = SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: [
          for (final (index, bubble) in bubbles.indexed)
            PositionedDirectional(
              start: step * index,
              top: 0,
              child: _ring(tokens, bubble),
            ),
        ],
      ),
    );

    final semanticLabel = this.semanticLabel?.trim();
    if (semanticLabel == null || semanticLabel.isEmpty) return stack;
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(child: stack),
    );
  }

  Widget _ring(LinagoraStackedAvatarsStyle tokens, Widget child) => Container(
    width: tokens.size,
    height: tokens.size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: tokens.ringColor, width: tokens.ringWidth),
    ),
    child: ClipOval(child: child),
  );
}

class _OverflowBubble extends StatelessWidget {
  final int count;
  final Color color;
  final TextStyle textStyle;

  const _OverflowBubble({
    required this.count,
    required this.color,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: color,
    child: Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '+$count',
          maxLines: 1,
          textDirection: TextDirection.ltr,
          textScaler: TextScaler.noScaling,
          style: textStyle,
        ),
      ),
    ),
  );
}
