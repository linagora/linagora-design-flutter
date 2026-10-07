import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/reaction/linagora_reaction_chip.dart';

/// The reactions row displayed under a message bubble.
///
/// Shows the first [maxDisplayed] reactions. The others are summed up in a
/// `+N` chip, which replaces the "more" button to open the full list.
class LinagoraReactions extends StatelessWidget {
  static const int maxDisplayed = 3;

  /// Sorted by display priority.
  final List<LinagoraReactionChip> reactions;

  /// Opens the full list of reactions. The "more" button is hidden when null.
  final GestureTapDownCallback? onShowAll;

  const LinagoraReactions({super.key, required this.reactions, this.onShowAll});

  @override
  Widget build(BuildContext context) {
    final remaining = reactions.length - maxDisplayed;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: LinagoraReactionChip.spacing,
      children: [
        ...reactions.take(maxDisplayed),
        if (remaining > 0)
          LinagoraReactionChip.remaining(count: remaining, onTapDown: onShowAll)
        else if (onShowAll != null && reactions.isNotEmpty)
          LinagoraReactionChip.more(onTapDown: onShowAll),
      ],
    );
  }
}
