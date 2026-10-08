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

  /// Opens the full list of reactions, on tap. The "more" button is hidden
  /// when null.
  ///
  /// The details are those of the tap down, to anchor a popup. Without pointer
  /// (keyboard, screen reader), they point at the center of the chip.
  final GestureTapDownCallback? onShowAll;

  const LinagoraReactions({super.key, required this.reactions, this.onShowAll});

  @override
  Widget build(BuildContext context) {
    final remaining = reactions.length - maxDisplayed;
    final onShowAll = this.onShowAll;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: LinagoraReactionChip.spacing,
      children: [
        ...reactions.take(maxDisplayed),
        if (onShowAll != null && reactions.isNotEmpty)
          _ShowAllChip(remaining: remaining, onShowAll: onShowAll)
        else if (remaining > 0)
          LinagoraReactionChip.remaining(count: remaining),
      ],
    );
  }
}

class _ShowAllChip extends StatefulWidget {
  final int remaining;
  final GestureTapDownCallback onShowAll;

  const _ShowAllChip({required this.remaining, required this.onShowAll});

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
            onTap: _showAll,
            onTapDown: _rememberTapDown,
          )
        : LinagoraReactionChip.more(
            onTap: _showAll,
            onTapDown: _rememberTapDown,
          );
  }
}
