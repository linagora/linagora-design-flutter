import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/twake_screen/homeserver_button_widget.dart';
import 'package:linagora_design_flutter/twake_screen/twake_welcome_screen_style.dart';

class TwakeWelcomeScreen extends StatelessWidget {
  final TextStyle? signInTextStyle;
  final TextStyle? createTwakeIdTextStyle;
  final TextStyle? useCompanyServerTextStyle;
  final TextStyle? descriptionTextStyle;
  final TextStyle? privacyPolicyTextStyle;
  final TextStyle? descriptionPrivacyPolicyTextStyle;
  final String? signInTitle;
  final String? createTwakeIdTitle;
  final String useCompanyServerTitle;
  final String description;
  final String? privacyPolicy;
  final String? descriptionPrivacyPolicy;
  final VoidCallback? onSignInOnTap;
  final VoidCallback? onCreateTwakeIdOnTap;
  final VoidCallback? onUseCompanyServerOnTap;
  final VoidCallback? onPrivacyPolicyOnTap;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final Widget? backButton;
  final Widget? logo;
  final AppBar? appBar;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  const TwakeWelcomeScreen({
    super.key,
    this.signInTextStyle,
    this.createTwakeIdTextStyle,
    this.useCompanyServerTextStyle,
    this.signInTitle,
    this.createTwakeIdTitle,
    required this.useCompanyServerTitle,
    required this.description,
    this.descriptionTextStyle,
    this.onSignInOnTap,
    this.onCreateTwakeIdOnTap,
    this.onUseCompanyServerOnTap,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.backButton,
    this.logo,
    this.appBar,
    this.extendBodyBehindAppBar = true,
    this.extendBody = true,
    this.privacyPolicy,
    this.onPrivacyPolicyOnTap,
    this.privacyPolicyTextStyle,
    this.descriptionPrivacyPolicy,
    this.descriptionPrivacyPolicyTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinagoraSysColors.material().linearGradientStartingPage,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (logo != null) logo!,
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: descriptionTextStyle ??
                      const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
            if (backButton != null)
              Positioned(
                top: 56,
                left: 0,
                child: backButton!,
              ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: TwakeWelcomeScreenStyle.buttonPadding,
                child: Column(
                  children: [
                    if (createTwakeIdTitle != null) ...[
                      HomeserverButtonWidget(
                        focusColor: focusColor,
                        hoverColor: hoverColor,
                        highlightColor: highlightColor,
                        overlayColor: overlayColor,
                        splashColor: splashColor,
                        onTap: onCreateTwakeIdOnTap,
                        title: createTwakeIdTitle!,
                        textStyle: createTwakeIdTextStyle ??
                            TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              color: LinagoraSysColors.material().onPrimary,
                            ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                    if (signInTitle != null)
                      HomeserverButtonWidget(
                        focusColor: focusColor,
                        hoverColor: hoverColor,
                        highlightColor: highlightColor,
                        overlayColor: overlayColor,
                        splashColor: splashColor,
                        onTap: onSignInOnTap,
                        title: signInTitle!,
                        backgroundColor: LinagoraSysColors.material().surface,
                        textStyle: createTwakeIdTextStyle ??
                            TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              color: LinagoraSysColors.material().primary,
                            ),
                      ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      focusColor: focusColor,
                      hoverColor: hoverColor,
                      highlightColor: highlightColor,
                      overlayColor: overlayColor,
                      splashColor: splashColor,
                      onTap: onUseCompanyServerOnTap,
                      child: Padding(
                        padding: TwakeWelcomeScreenStyle
                            .useCompanyServerTitlePadding,
                        child: Text(
                          useCompanyServerTitle,
                          style: useCompanyServerTextStyle ??
                              TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                color: LinagoraSysColors.material().primary,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    LinagoraSysColors.material().primary,
                              ),
                        ),
                      ),
                    ),
                    if (privacyPolicy != null) ...[
                      const SizedBox(
                        height: 32,
                      ),
                      Column(
                        children: [
                          Text(
                            descriptionPrivacyPolicy ?? '',
                            style: descriptionPrivacyPolicyTextStyle ??
                                TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                  color: LinagoraSysColors.material()
                                      .outlineVariantDark,
                                ),
                          ),
                          InkWell(
                            focusColor: focusColor,
                            hoverColor: hoverColor,
                            highlightColor: highlightColor,
                            overlayColor: overlayColor,
                            splashColor: splashColor,
                            onTap: onPrivacyPolicyOnTap,
                            child: Text(
                              privacyPolicy!,
                              style: privacyPolicyTextStyle ??
                                  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    color: LinagoraSysColors.material().primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
