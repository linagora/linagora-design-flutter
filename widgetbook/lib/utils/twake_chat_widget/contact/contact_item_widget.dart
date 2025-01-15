import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook_workspace/utils/twake_chat_widget/contact/contact_status.dart';
import 'package:widgetbook_workspace/utils/twake_chat_widget/contact/contact_status_widget.dart';
import 'package:widgetbook_workspace/utils/twake_chat_widget/widgets/twake_chip.dart';

typedef OnExpansionListTileTap = void Function();

class ContactItem extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;
  final bool isCurrentMatrixId;
  final ContactStatus? contactStatus;
  final String? matrixId;
  final String? email;
  final String? phoneNumber;
  final TextStyle? displayNameStyle;
  final TextStyle? matrixIdStyle;
  final TextStyle? emailStyle;
  final TextStyle? phoneNumberStyle;
  final TextStyle? contactStatusStyle;

  const ContactItem({
    super.key,
    this.avatarUrl,
    required this.displayName,
    this.isCurrentMatrixId = false,
    this.contactStatus,
    this.matrixId,
    this.email,
    this.phoneNumber,
    this.displayNameStyle,
    this.matrixIdStyle,
    this.emailStyle,
    this.phoneNumberStyle,
    this.contactStatusStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TwakeInkWell(
      onTap: () {},
      onLongPress: () {},
      onSecondaryTapDown: (details) {},
      child: TwakeListItem(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 8.0, top: 8.0, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: IgnorePointer(
                  child: RoundAvatar(
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
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: displayNameStyle ??
                                        TextStyle(
                                          color: LinagoraSysColors.material()
                                              .onSurface,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          letterSpacing: 0.25,
                                          fontFamily: 'Inter',
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCurrentMatrixId) ...[
                            const SizedBox(width: 8.0),
                            TwakeChip(
                              text: 'Owner',
                              textColor: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                          const SizedBox(width: 8.0),
                          if (contactStatus != null &&
                              contactStatus == ContactStatus.inactive)
                            ContactStatusWidget(
                              status: contactStatus!,
                              textStyle: contactStatusStyle,
                            ),
                        ],
                      ),
                    ),
                    if (matrixId != null &&
                        (email == null || phoneNumber == null))
                      Text(
                        matrixId!,
                        style: matrixIdStyle ??
                            TextStyle(
                              color: LinagoraRefColors.material().tertiary[30],
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.25,
                              fontFamily: 'Inter',
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (email != null)
                      Text(
                        email!,
                        style: emailStyle ??
                            TextStyle(
                              color: LinagoraRefColors.material().tertiary[30],
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.25,
                              fontFamily: 'Inter',
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (phoneNumber != null)
                      Text(
                        phoneNumber!,
                        style: phoneNumberStyle ??
                            TextStyle(
                              color: LinagoraRefColors.material().tertiary[30],
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.25,
                              fontFamily: 'Inter',
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
