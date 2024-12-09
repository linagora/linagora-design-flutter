import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/twake_chat_widget/contact/contact_status.dart';

class ContactStatusWidget extends StatelessWidget {
  final ContactStatus status;
  final TextStyle? textStyle;

  ContactStatusWidget({
    super.key,
    required this.status,
    this.textStyle,
  });

  final Color? inactiveColor = LinagoraRefColors.material().neutral[60];

  @override
  Widget build(BuildContext context) {
    return status == ContactStatus.inactive
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: inactiveColor,
                  ),
                ),
                Text(
                  " Inactive",
                  style: textStyle ??
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: inactiveColor,
                          ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
