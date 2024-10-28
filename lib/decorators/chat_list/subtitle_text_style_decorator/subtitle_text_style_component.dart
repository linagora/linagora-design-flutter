import 'package:flutter/material.dart';

abstract class ChatListSubtitleTextStyleComponent {
  TextStyle textStyle(
    BuildContext context, {
    bool? isUnreadOrInvited,
    bool? isMuted,
  });
}
