import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linagora_design_flutter/decorators/chat_list/subtitle_text_style_decorator/subtitle_text_style_component.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

abstract class ChatListSubtitleTextStyleDecorator
    implements ChatListSubtitleTextStyleComponent {
  final ChatListSubtitleTextStyleComponent interfaceTextStyleComponent;

  ChatListSubtitleTextStyleDecorator(this.interfaceTextStyleComponent);
}

class ChatListSubtitleTextStyle implements ChatListSubtitleTextStyleDecorator {
  final ChatListSubtitleTextStyleComponent _interfaceTextStyleComponent;

  ChatListSubtitleTextStyle(this._interfaceTextStyleComponent);

  @override
  TextStyle textStyle(
    BuildContext context, {
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    return _interfaceTextStyleComponent.textStyle(context);
  }

  @override
  ChatListSubtitleTextStyleComponent get interfaceTextStyleComponent =>
      _interfaceTextStyleComponent;
}

class ReadChatListSubtitleTextStyleDecorator
    implements ChatListSubtitleTextStyleComponent {
  @override
  TextStyle textStyle(
    BuildContext context, {
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: LinagoraSysColors.material().onSurface,
          fontFamily: GoogleFonts.inter().fontFamily,
        );
  }
}

class UnreadChatListSubtitleTextStyleDecorator
    implements ChatListSubtitleTextStyleDecorator {
  final ChatListSubtitleTextStyleComponent _interfaceTextStyleComponent;

  UnreadChatListSubtitleTextStyleDecorator(this._interfaceTextStyleComponent);

  @override
  TextStyle textStyle(
    BuildContext context, {
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    if (isUnreadOrInvited == true) {
      return _interfaceTextStyleComponent
          .textStyle(
            context,
            isMuted: isMuted,
            isUnreadOrInvited: isUnreadOrInvited,
          )
          .merge(
            Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: LinagoraSysColors.material().onSurface,
                ),
          );
    } else {
      return _interfaceTextStyleComponent.textStyle(
        context,
        isMuted: isMuted,
        isUnreadOrInvited: isUnreadOrInvited,
      );
    }
  }

  @override
  ChatListSubtitleTextStyleComponent get interfaceTextStyleComponent =>
      _interfaceTextStyleComponent;
}

class MuteChatListSubtitleTextStyleDecorator
    implements ChatListSubtitleTextStyleDecorator {
  final ChatListSubtitleTextStyleComponent _interfaceTextStyleComponent;

  MuteChatListSubtitleTextStyleDecorator(this._interfaceTextStyleComponent);

  @override
  TextStyle textStyle(
    BuildContext context, {
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    if (isMuted == true) {
      return _interfaceTextStyleComponent
          .textStyle(
            context,
            isMuted: isMuted,
            isUnreadOrInvited: isUnreadOrInvited,
          )
          .copyWith(
            color: LinagoraSysColors.material().onSurface,
          );
    } else {
      return _interfaceTextStyleComponent.textStyle(
        context,
        isMuted: isMuted,
        isUnreadOrInvited: isUnreadOrInvited,
      );
    }
  }

  @override
  ChatListSubtitleTextStyleComponent get interfaceTextStyleComponent =>
      _interfaceTextStyleComponent;
}
