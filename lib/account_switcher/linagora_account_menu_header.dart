import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/account_switcher/linagora_account_switcher_style.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';

/// Profile block at the top of an avatar [LinagoraAccountMenu]: large avatar,
/// name, email with an optional copy control, and an optional status badge.
class LinagoraAccountMenuHeader extends StatelessWidget {
  static const Key copyKey = ValueKey('linagora_account_menu_copy');

  final Widget avatar;
  final String name;
  final String? email;

  /// Copies [email], or [name] when the host is address-only (`email` null /
  /// equal to [name]). Null hides the copy control.
  final VoidCallback? onCopyEmail;

  /// Tooltip and screen-reader name of the copy control.
  final String? copyTooltip;

  /// Optional status pill under the email, such as "Delegated mailbox".
  final Widget? badge;

  final LinagoraAccountSwitcherStyle? style;

  const LinagoraAccountMenuHeader({
    super.key,
    required this.avatar,
    required this.name,
    this.email,
    this.onCopyEmail,
    this.copyTooltip,
    this.badge,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraAccountSwitcherStyle.material();
    final email = this.email?.trim();
    final badge = this.badge;
    final hasEmail = email != null && email.isNotEmpty;
    final addressOnly = !hasEmail || email == name.trim();
    final showCopy = onCopyEmail != null;

    return Padding(
      padding: tokens.headerPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(dimension: tokens.headerAvatarSize, child: avatar),
          SizedBox(height: tokens.headerAvatarGap),
          if (addressOnly)
            _addressRow(
              tokens,
              text: name,
              textStyle: tokens.headerNameTextStyle,
              showCopy: showCopy,
            )
          else ...[
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.headerNameTextStyle,
            ),
            SizedBox(height: tokens.headerEmailGap),
            _addressRow(
              tokens,
              text: email,
              textStyle: tokens.headerEmailTextStyle,
              showCopy: showCopy,
            ),
          ],
          if (badge != null) ...[
            SizedBox(height: tokens.headerBadgeGap),
            badge,
          ],
        ],
      ),
    );
  }

  Widget _addressRow(
    LinagoraAccountSwitcherStyle tokens, {
    required String text,
    required TextStyle textStyle,
    required bool showCopy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
        if (showCopy) ...[
          SizedBox(width: tokens.headerCopyGap),
          IconButton(
            key: copyKey,
            tooltip: copyTooltip,
            onPressed: onCopyEmail,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size.square(tokens.headerCopySize)),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.square(tokens.headerCopySize),
            ),
            icon: SvgPicture.asset(
              LinagoraDesignImages.copyLinkIcon,
              package: LinagoraDesignImages.packageName,
              width: tokens.headerCopyIconSize,
              height: tokens.headerCopyIconSize,
              colorFilter: ColorFilter.mode(
                tokens.headerCopyColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
