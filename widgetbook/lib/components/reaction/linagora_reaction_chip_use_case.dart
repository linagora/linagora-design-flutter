import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum _ChipVariant { emoji, image, remaining, more }

@widgetbook.UseCase(name: 'Default', type: LinagoraReactionChip)
Widget linagoraReactionChipUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: _ChipVariant.values,
    initialOption: _ChipVariant.emoji,
    labelBuilder: (variant) => variant.name,
  );
  final emoji = context.knobs.string(label: 'Emoji', initialValue: '👍');
  final showCount = context.knobs.boolean(
    label: 'Show count',
    initialValue: true,
  );
  final count = context.knobs.int.slider(
    label: 'Count',
    initialValue: 12,
    min: 1,
    max: 999,
  );
  final reactionCount = showCount ? count : null;

  return ColoredBox(
    color: const Color(0xFFF5F7FA),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: Alignment.topLeft,
        child: switch (variant) {
          _ChipVariant.emoji => LinagoraReactionChip(
              emoji: emoji,
              count: reactionCount,
              onTap: () {},
            ),
          _ChipVariant.image => LinagoraReactionChip.image(
              image: const FlutterLogo(),
              count: reactionCount,
              onTap: () {},
            ),
          _ChipVariant.remaining => LinagoraReactionChip.remaining(
              count: count,
              onTap: () {},
            ),
          _ChipVariant.more => LinagoraReactionChip.more(onTap: () {}),
        },
      ),
    ),
  );
}
