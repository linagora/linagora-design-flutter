import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/list_item/linagora_person_tile_style.dart';

/// A card of rows, usually [LinagoraPersonTile]s, under an optional [header].
///
/// Use this for access/delegation lists: one outlined card wraps every row.
/// A single child is a fully bordered item; several children share that outer
/// border with a divider between each pair. [filled] paints the muted archive
/// card instead of the outline.
class LinagoraTileGroup extends StatelessWidget {
  static const Key cardKey = ValueKey('linagora_tile_group_card');

  final Widget? header;
  final List<Widget> children;
  final bool filled;
  final LinagoraPersonTileStyle? style;

  const LinagoraTileGroup({
    super.key,
    this.header,
    required this.children,
    this.filled = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraPersonTileStyle.material();
    final header = this.header;
    final card = _card(tokens);

    if (header == null) return card;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        SizedBox(height: tokens.headerGap),
        card,
      ],
    );
  }

  Widget _card(LinagoraPersonTileStyle tokens) {
    final radius = BorderRadius.circular(tokens.groupRadius);
    return DecoratedBox(
      key: cardKey,
      decoration: BoxDecoration(
        color: filled ? tokens.groupFillColor : null,
        borderRadius: radius,
        border: filled ? null : Border.all(color: tokens.groupBorderColor),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, child) in children.indexed) ...[
              if (index > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: tokens.groupBorderColor,
                ),
              child,
            ],
          ],
        ),
      ),
    );
  }
}
