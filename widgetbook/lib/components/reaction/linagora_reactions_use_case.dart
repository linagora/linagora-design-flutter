import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraReactions)
Widget linagoraReactionsUseCase(BuildContext context) {
  final reactions = context.knobs.int.slider(
    label: 'Reactions',
    initialValue: 7,
    min: 1,
    max: 7,
  );
  final count = context.knobs.int.slider(
    label: 'Count',
    initialValue: 12,
    min: 1,
    max: 999,
  );
  final showAll = context.knobs.boolean(
    label: 'Can show all',
    initialValue: true,
  );
  const emojis = ['❤️', '💜', '💚', '💛', '🧡', '🖤', '🤍'];

  return ColoredBox(
    color: const Color(0xFFF5F7FA),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: LinagoraReactions(
        reactions: [
          for (final emoji in emojis.take(reactions))
            LinagoraReactionChip(emoji: emoji, count: count, onTap: () {}),
        ],
        onShowAll: showAll ? (_) {} : null,
      ),
    ),
  );
}
