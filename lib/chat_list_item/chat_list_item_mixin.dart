import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linagora_design_flutter/decorators/chat_list/subtitle_text_style_decorator/subtitle_text_style_view.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

mixin ChatListItemMixin {
  Widget textContentWidget(
    BuildContext context, {
    required bool isGroup,
    required bool invite,
    required String emptyChat,
    required String youAreInvitedToThisChat,
    String? textContent,
  }) {
    return Text(
      invite ? youAreInvitedToThisChat : textContent ?? emptyChat,
      softWrap: false,
      maxLines: isGroup ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: ListItemStyle.subtitleTextStyle(
        fontFamily: GoogleFonts.inter().fontFamily ?? 'Inter',
      ),
    );
  }

  Widget typingTextWidget(String typingText, BuildContext context) {
    final displayedTypingText = "$typingText…";
    return Text(
      displayedTypingText,
      style: ListItemStyle.subtitleTextStyle(
        fontFamily: GoogleFonts.inter().fontFamily ?? 'Inter',
      ),
      maxLines: 2,
      softWrap: true,
    );
  }

  RenderObjectWidget lastSenderWidget({
    required bool isGroup,
    required String displayNameLastSender,
    bool? isUnreadOrInvited,
    bool? isMuted,
    required BuildContext context,
  }) {
    return isGroup
        ? Row(
            children: [
              Expanded(
                child: Text(
                  displayNameLastSender,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: ChatLitSubSubtitleTextStyleView.textStyle.textStyle(
                    context,
                    isUnreadOrInvited: isUnreadOrInvited,
                    isMuted: isMuted,
                  ),
                ),
              ),
              const Spacer(),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget chatListItemSubtitleForGroup({
    required BuildContext context,
    required bool invite,
    required String youAreInvitedToThisChat,
    String? subscriptions,
    required String displayName,
    required String emptyChat,
    String? filename,
    bool isAFile = false,
  }) {
    if (invite) {
      return Text(
        youAreInvitedToThisChat,
        softWrap: false,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: ChatLitSubSubtitleTextStyleView.textStyle.textStyle(
          context,
          isUnreadOrInvited: invite,
        ),
      );
    }

    if (isAFile == true) {
      return Text(
        "$displayName: ${filename ?? subscriptions ?? emptyChat}",
        softWrap: false,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: ChatLitSubSubtitleTextStyleView.textStyle.textStyle(context),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          style: ListItemStyle.subtitleTextStyle(
            fontFamily: GoogleFonts.inter().fontFamily ?? 'Inter',
          ).copyWith(
            color: LinagoraSysColors.material().onSurface,
          ),
        ),
        Text(
                subscriptions ?? '',
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ListItemStyle.subtitleTextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily ?? 'Inter',
                ),
              ),
      ],
    );
  }
}
