import 'package:flutter/material.dart';

abstract class ChatListTitleTextStyleComponent {
  TextStyle textStyle({
    bool? isUnreadOrInvited,
    bool? isMuted,
  });
}
