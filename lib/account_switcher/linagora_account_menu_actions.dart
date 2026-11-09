import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/account_switcher/linagora_account_switcher_style.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';
import 'package:linagora_design_flutter/list_item/linagora_person_tile.dart';

/// Footer of an avatar [LinagoraAccountMenu]: divider, manage account, sign out.
class LinagoraAccountMenuActions extends StatelessWidget {
  static const Key manageKey = ValueKey('linagora_account_menu_manage');
  static const Key signOutKey = ValueKey('linagora_account_menu_sign_out');

  final String manageLabel;
  final String signOutLabel;
  final VoidCallback? onManageAccount;
  final VoidCallback? onSignOut;
  final LinagoraAccountSwitcherStyle? style;

  const LinagoraAccountMenuActions({
    super.key,
    required this.manageLabel,
    required this.signOutLabel,
    this.onManageAccount,
    this.onSignOut,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraAccountSwitcherStyle.material();
    final showManage = onManageAccount != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(
          height: tokens.footerDividerGap,
          thickness: 1,
          color: tokens.footerDividerColor,
        ),
        if (showManage)
          Padding(
            padding: tokens.itemPadding,
            child: LinagoraPersonTile(
              key: manageKey,
              name: manageLabel,
              onTap: onManageAccount,
              style: tokens.tileStyle,
              avatar: _icon(
                LinagoraDesignImages.accountManageIcon,
                tokens.footerIconSize,
                tokens.footerIconColor,
              ),
            ),
          ),
        Padding(
          padding: tokens.itemPadding,
          child: LinagoraPersonTile(
            key: signOutKey,
            name: signOutLabel,
            onTap: onSignOut,
            style: tokens.tileStyle,
            avatar: _icon(
              LinagoraDesignImages.accountSignOutIcon,
              tokens.footerIconSize,
              tokens.footerIconColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _icon(String asset, double size, Color color) => Center(
        child: SvgPicture.asset(
          asset,
          package: LinagoraDesignImages.packageName,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      );
}
