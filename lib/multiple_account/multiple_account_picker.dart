import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/multiple_account/models/twake_presentation_account.dart';
import 'package:linagora_design_flutter/multiple_account/multiple_account_view.dart';

typedef OnAddAnotherAccount = void Function();
typedef OnGoToAccountSettings = void Function();
typedef OnSetAccountAsActive = void Function(TwakePresentationAccount account);
typedef OnClose = void Function();

class MultipleAccountPicker {
  static Future<T?> showMultipleAccountPicker<T>({
    required List<TwakePresentationAccount> accounts,
    required BuildContext context,
    required OnAddAnotherAccount onAddAnotherAccount,
    required OnGoToAccountSettings onGoToAccountSettings,
    required OnSetAccountAsActive onSetAccountAsActive,
    required String titleAddAnotherAccount,
    required String titleAccountSettings,
    required Widget logoApp,
    TextStyle? accountNameStyle,
    TextStyle? accountIdStyle,
    TextStyle? titleAccountSettingsStyle,
    EdgeInsetsGeometry? marginBody,
    Color? highlightColor,
    Color? splashColor,
    Color? hoverColor,
    Color? focusColor,
    OnClose? onClose,
    TextStyle? addAnotherAccountStyle,
    Color? backgroundColor,
    double initialChildSize = 0.6,
    double minChildSize = 0.6,
    double maxChildSize = 0.9,
    bool isScrollControlled = true,
    double? heightOfBottomSheet,
    bool expandDraggableScrollableSheet = false,
  }) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: marginBody ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor ?? LinagoraSysColors.material().onPrimary,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: expandDraggableScrollableSheet,
          builder: (context, controller) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Stack(
                children: [
                  SizedBox(
                      height: heightOfBottomSheet ??
                          _defaultBottomSheetHeight(context),
                      child: Column(
                        children: [
                          logoApp,
                          Expanded(
                            child: MultipleAccountView(
                              onSetAccountAsActive: onSetAccountAsActive,
                              accounts: accounts,
                              scrollController: controller,
                              onGoToAccountSettings: onGoToAccountSettings,
                              accountIdStyle: accountIdStyle,
                              accountNameStyle: accountNameStyle,
                              titleAccountSettings: titleAccountSettings,
                              titleAccountSettingsStyle:
                                  titleAccountSettingsStyle,
                              highlightColor: highlightColor,
                              splashColor: splashColor,
                              hoverColor: hoverColor,
                              focusColor: focusColor,
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 88,
                      width: MediaQuery.of(context).size.width,
                      color: backgroundColor ??
                          LinagoraSysColors.material().onPrimary,
                      child: InkWell(
                        highlightColor: highlightColor,
                        splashColor: splashColor,
                        hoverColor: hoverColor,
                        focusColor: focusColor,
                        onTap: () {
                          Navigator.of(context).pop();
                          onAddAnotherAccount();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          height: 48,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: LinagoraSysColors.material().primary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_alt_outlined,
                                size: 18,
                                color: LinagoraSysColors.material().onPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                titleAddAnotherAccount,
                                style: addAnotherAccountStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static double _defaultBottomSheetHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.9 -
        MediaQuery.of(context).viewInsets.bottom;
  }
}
