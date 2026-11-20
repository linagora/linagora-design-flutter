import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/avatar/linagora_presence_badge_style.dart';

enum LinagoraPresence { online, away, offline }

/// A presence dot over the bottom right corner of an avatar: online or away.
///
/// Offline and unknown (null) draw no dot. The dot is decoration, hidden from
/// semantics: the host says the presence in text.
class LinagoraPresenceBadge extends StatelessWidget {
  final Widget child;
  final LinagoraPresence? presence;

  /// The avatar diameter, which picks the dot size.
  final double size;
  final LinagoraPresenceBadgeStyle? style;

  const LinagoraPresenceBadge({
    super.key,
    required this.child,
    required this.presence,
    required this.size,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraPresenceBadgeStyle.material();
    final color = switch (presence) {
      LinagoraPresence.online => tokens.onlineColor,
      LinagoraPresence.away => tokens.awayColor,
      LinagoraPresence.offline || null => null,
    };
    final dotSize = tokens.dotSizeFor(size);
    // Centred on the circle at 45°, so it stays on the edge of large avatars
    final inset =
        size / 2 * (1 - math.sqrt1_2) - dotSize / 2 - tokens.ringWidth;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (color != null)
          Positioned(
            right: inset,
            bottom: inset,
            child: ExcludeSemantics(
              child: _Dot(color: color, size: dotSize, tokens: tokens),
            ),
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size, required this.tokens});

  final Color color;
  final double size;
  final LinagoraPresenceBadgeStyle tokens;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return SizedBox.square(
      dimension: size + 2 * tokens.ringWidth,
      child: AnimatedContainer(
        key: const ValueKey('linagora-presence-dot'),
        duration: reduceMotion ? Duration.zero : tokens.colorDuration,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: tokens.ringColor, width: tokens.ringWidth),
        ),
      ),
    );
  }
}
