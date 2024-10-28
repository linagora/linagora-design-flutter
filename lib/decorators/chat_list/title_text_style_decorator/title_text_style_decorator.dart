import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linagora_design_flutter/decorators/chat_list/title_text_style_decorator/title_text_style_component.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

abstract class ChatListTitleTextStyleDecorator
    implements ChatListTitleTextStyleComponent {
  final ChatListTitleTextStyleComponent interfaceTextStyleComponent;

  ChatListTitleTextStyleDecorator(this.interfaceTextStyleComponent);
}

class ChatListTitleTextStyle implements ChatListTitleTextStyleDecorator {
  final ChatListTitleTextStyleComponent _interfaceTextStyleComponent;

  ChatListTitleTextStyle(this._interfaceTextStyleComponent);

  @override
  TextStyle textStyle({
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    return _interfaceTextStyleComponent.textStyle(
      isUnreadOrInvited: isUnreadOrInvited,
      isMuted: isMuted,
    );
  }

  @override
  ChatListTitleTextStyleComponent get interfaceTextStyleComponent =>
      _interfaceTextStyleComponent;
}

class ReadChatListTitleTextStyleDecorator
    implements ChatListTitleTextStyleComponent {
  @override
  TextStyle textStyle({
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    return LinagoraTextStyle.material().bodyMedium2.copyWith(
          color: LinagoraSysColors.material().onSurface,
          fontFamily: GoogleFonts.inter().fontFamily,
        );
  }
}

class UnreadChatListTitleTextStyleDecorator
    implements ChatListTitleTextStyleDecorator {
  final ChatListTitleTextStyleComponent _interfaceTextStyleComponent;

  UnreadChatListTitleTextStyleDecorator(this._interfaceTextStyleComponent);

  @override
  TextStyle textStyle({
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    if (isUnreadOrInvited == true) {
      return _interfaceTextStyleComponent
          .textStyle(
            isUnreadOrInvited: isUnreadOrInvited,
            isMuted: isMuted,
          )
          .merge(
            LinagoraTextStyle.material().bodyMedium2.copyWith(
                  color: LinagoraSysColors.material().onSurface,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
          );
    } else {
      return _interfaceTextStyleComponent.textStyle(
        isUnreadOrInvited: isUnreadOrInvited,
        isMuted: isMuted,
      );
    }
  }

  @override
  ChatListTitleTextStyleComponent get interfaceTextStyleComponent =>
      _interfaceTextStyleComponent;
}

class MuteChatListTitleTextStyleDecorator
    implements ChatListTitleTextStyleDecorator {
  final ChatListTitleTextStyleComponent _interfaceTextStyleComponent;

  MuteChatListTitleTextStyleDecorator(this._interfaceTextStyleComponent);

  @override
  TextStyle textStyle({
    bool? isUnreadOrInvited,
    bool? isMuted,
  }) {
    if (isMuted == true) {
      return _interfaceTextStyleComponent
          .textStyle(
            isUnreadOrInvited: isUnreadOrInvited,
            isMuted: isMuted,
          )
          .copyWith(
            color: LinagoraSysColors.material().onSurface,
          );
    } else {
      return _interfaceTextStyleComponent.textStyle(
        isUnreadOrInvited: isUnreadOrInvited,
        isMuted: isMuted,
      );
    }
  }

  @override
  ChatListTitleTextStyleComponent get interfaceTextStyleComponent =>
      _interfaceTextStyleComponent;
}
