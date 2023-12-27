import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_state_layer.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/multiple_account/models/twake_presentation_account.dart';
import 'package:linagora_design_flutter/multiple_account/multiple_account_picker.dart';

class MultipleAccountView extends StatelessWidget {
  final List<TwakePresentationAccount> accounts;
  final ScrollController scrollController;
  final String titleAccountSettings;
  final TextStyle? accountIdStyle;
  final TextStyle? accountNameStyle;
  final TextStyle? titleAccountSettingsStyle;
  final OnGoToAccountSettings onGoToAccountSettings;
  final OnSetAccountAsActive onSetAccountAsActive;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? hoverColor;
  final Color? focusColor;

  const MultipleAccountView({
    super.key,
    required this.accounts,
    required this.scrollController,
    this.accountNameStyle,
    this.accountIdStyle,
    this.titleAccountSettingsStyle,
    required this.titleAccountSettings,
    required this.onGoToAccountSettings,
    required this.onSetAccountAsActive,
    this.highlightColor,
    this.splashColor,
    this.hoverColor,
    this.focusColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 100),
      controller: scrollController,
      itemBuilder: (context, index) {
        return InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          hoverColor: hoverColor,
          focusColor: focusColor,
          onTap: () {
            Navigator.of(context).pop();
            onSetAccountAsActive(accounts[index]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      accounts[index].avatar,
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        accounts[index].accountName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: accountNameStyle,
                                      ),
                                      Text(
                                        accounts[index].accountId,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: accountIdStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                if (accounts[index].isActive)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: LinagoraSysColors.material().primary,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 18,
                                      color:
                                          LinagoraSysColors.material().onPrimary,
                                    ),
                                  ),
                              ],
                            ),
                            if (accounts[index].isActive)
                              InkWell(
                                highlightColor: highlightColor,
                                splashColor: splashColor,
                                hoverColor: hoverColor,
                                focusColor: focusColor,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  onGoToAccountSettings();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.settings_outlined,
                                        size: 18,
                                        color: LinagoraSysColors.material().primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        titleAccountSettings,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: titleAccountSettingsStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: accounts[index].isActive ? 0 : 16),
                              child: Divider(
                                color: LinagoraStateLayer(
                                  LinagoraSysColors.material().surfaceTint,
                                ).opacityLayer3,
                                thickness: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: accounts.length,
    );
  }
}
