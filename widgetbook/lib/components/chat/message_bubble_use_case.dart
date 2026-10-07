import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: MessageBubble)
Widget messageBubbleUseCase(BuildContext context) {
  final isOwnMessage = context.knobs.boolean(
    label: 'Own message',
    initialValue: false,
  );
  final showTail = context.knobs.boolean(
    label: 'Show tail',
    initialValue: true,
  );
  final text = context.knobs.string(
    label: 'Message',
    initialValue: 'Hello! I am a beautiful chat bubble 👋',
  );

  final tailDirection = showTail
      ? (isOwnMessage ? BubbleTailDirection.right : BubbleTailDirection.left)
      : BubbleTailDirection.none;

  final bubble = MessageBubble(
    isOwnMessage: isOwnMessage,
    tailDirection: tailDirection,
    constraints: const BoxConstraints(maxWidth: 280),
    // Bubble body has no bottom padding; the content owns the space below it.
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: LinagoraTextStyle.material().bodyMedium4),
    ),
  );

  return ColoredBox(
    color: const Color(0xFFF5F7FA),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: bubble,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With reactions', type: MessageBubble)
Widget messageBubbleWithReactionsUseCase(BuildContext context) {
  final isOwnMessage = context.knobs.boolean(
    label: 'Own message',
    initialValue: false,
  );
  final text = context.knobs.string(
    label: 'Message',
    initialValue: 'Big thx to the team!',
  );
  final reactions = context.knobs.int.slider(
    label: 'Reactions',
    initialValue: 7,
    min: 1,
    max: 7,
  );
  final count = context.knobs.int.slider(
    label: 'Count',
    initialValue: 1,
    min: 1,
    max: 999,
  );
  const emojis = ['❤️', '💜', '💚', '💛', '🧡', '🖤', '🤍'];

  final bubble = MessageBubble(
    isOwnMessage: isOwnMessage,
    tailDirection:
        isOwnMessage ? BubbleTailDirection.right : BubbleTailDirection.left,
    isAlignedToEnd: isOwnMessage,
    reactions: LinagoraReactions(
      reactions: [
        for (final emoji in emojis.take(reactions))
          LinagoraReactionChip(emoji: emoji, count: count, onTap: () {}),
      ],
      onShowAll: (_) {},
    ),
    constraints: const BoxConstraints(maxWidth: 280),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: LinagoraTextStyle.material().bodyMedium4),
    ),
  );

  return ColoredBox(
    color: const Color(0xFFF5F7FA),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: bubble,
      ),
    ),
  );
}
