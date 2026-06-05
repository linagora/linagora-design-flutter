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
      child: Text(text, style: LinagoraTextStyle.material().bodyMedium3),
    ),
  );

  return ColoredBox(
    color: const Color(0xFFF5F7FA),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment:
            isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: bubble,
      ),
    ),
  );
}
