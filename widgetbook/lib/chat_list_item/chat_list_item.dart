import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

@widgetbook.UseCase(name: 'Default', type: ChatListItem)
ChatListItem chatListItemUseCase(BuildContext context) {
  return ChatListItem(
    isUnreadOrInvited: context.knobs.boolean(
      label: 'Unread message or Invited',
      initialValue: false,
    ),
    avatarUrl: context.knobs.string(
      label: 'Avatar URL',
      initialValue:
      'https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg',
    ),
    displayName: context.knobs.string(
      label: 'Display Name',
      initialValue: 'John Doe',
    ),
    twakeId: context.knobs.string(
      label: 'Twake ID',
      initialValue: '@john.doe:matrix.org',
    ),
    email: context.knobs.string(
      label: 'Email',
      initialValue: 'john.doe@matrix.com',
    ),
    roomEncrypted: context.knobs.boolean(
      label: 'Room Encrypted',
      initialValue: false,
    ),
    isFavourite: context.knobs.boolean(
      label: 'Is Favourite',
      initialValue: false,
    ),
    isMuted: context.knobs.boolean(
      label: 'Is Muted',
      initialValue: false,
    ),
    isTyping: context.knobs.boolean(
      label: 'Is Typing',
      initialValue: false,
    ),
    originServerTs: context.knobs.string(
      label: 'Origin Server Timestamp',
      initialValue: '2022-01-01',
    ),
    isGroup: context.knobs.boolean(
      label: 'Is Group',
      initialValue: false,
    ),
  );
}
