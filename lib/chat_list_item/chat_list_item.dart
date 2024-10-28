import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linagora_design_flutter/chat_list_item/chat_list_item_mixin.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

class ChatListItem extends StatelessWidget with ChatListItemMixin {
  final bool isUnreadOrInvited;
  final String? avatarUrl;
  final String displayName;
  final String? twakeId;
  final String? email;
  final String? originServerTs;
  final String? typingText;
  final bool roomEncrypted;
  final bool isFavourite;
  final bool isMuted;
  final bool isTyping;
  final bool isGroup;

  const ChatListItem({
    super.key,
    this.isUnreadOrInvited = false,
    this.avatarUrl,
    required this.displayName,
    this.twakeId,
    this.email,
    this.typingText,
    this.roomEncrypted = false,
    this.isFavourite = false,
    this.isMuted = false,
    this.isTyping = false,
    this.originServerTs,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return TwakeInkWell(
      onTap: () {},
      onLongPress: () {},
      onSecondaryTapDown: (details) {},
      child: TwakeListItem(
        child: Container(
          height: 80,
          width: 334,
          padding: const EdgeInsetsDirectional.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Stack(
                  children: [
                    RoundAvatar(
                      imageProvider:
                          avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      imageLoadingBuilder: (context, _, __) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ),
                      text: displayName,
                      size: 56,
                      linearGradientColors: const [
                        Color(0xFFBDF4A1),
                        Color(0xFF52CE64)
                      ],
                    ),
                    if (isGroup)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsetsDirectional.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: Icon(
                            Icons.group,
                            size: 16,
                            color: isUnreadOrInvited
                                ? LinagoraSysColors.material().onSurfaceVariant
                                : LinagoraRefColors.material().tertiary[30],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        end: 3,
                                      ),
                                      child: Text(
                                        displayName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: ListItemStyle.titleTextStyle(
                                          fontFamily:
                                              GoogleFonts.inter().fontFamily ??
                                                  'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (roomEncrypted)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        start: 4,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/images/ic_encrypted.svg',
                                        width: 14,
                                        height: 14,
                                      ),
                                    ),
                                  if (isFavourite)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        start: 4,
                                      ),
                                      child: Icon(
                                        Icons.push_pin_outlined,
                                        size: 20,
                                        color: LinagoraRefColors.material()
                                            .tertiary[40],
                                      ),
                                    ),
                                  if (isMuted)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        start: 4,
                                      ),
                                      child: Icon(
                                        Icons.volume_off_outlined,
                                        size: 20,
                                        color: LinagoraRefColors.material()
                                            .tertiary[40],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 4,
                          ),
                          child: Row(
                            children: [
                              if (isTyping) ...[
                                Icon(
                                  Icons.schedule,
                                  color:
                                      LinagoraRefColors.material().tertiary[30],
                                  size: 20,
                                ),
                              ],
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 4,
                                ),
                                child: Text(
                                  originServerTs ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: LinagoraRefColors.material()
                                            .tertiary[30],
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: isTyping
                              ? typingTextWidget(typingText ?? '', context)
                              : isGroup
                                  ? chatListItemSubtitleForGroup(
                                      context: context,
                                      invite: isUnreadOrInvited,
                                      youAreInvitedToThisChat:
                                          'You are invited to this chat',
                                      displayName: displayName,
                                      emptyChat: 'Empty chat',
                                    )
                                  : textContentWidget(
                                      context,
                                      isGroup: isGroup,
                                      invite: true,
                                      emptyChat: '123',
                                      youAreInvitedToThisChat: '123',
                                      textContent: '132',
                                    ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
