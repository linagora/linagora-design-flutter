import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:linagora_design_flutter/twake_screen/twake_welcome_screen_style.dart';

class TwakeWelcomeScreen extends StatelessWidget {
  final String welcomeTo;
  final String descriptionWelcomeTo;
  final String titleStartMessaging;
  final String titlePrivacy;
  final TextStyle? welcomeToStyle;
  final TextStyle? privacyTextStyle;
  final TextStyle? descriptionWelcomeToStyle;
  final TextStyle? titleStartMessagingStyle;
  final Widget logo;
  final Function()? buttonOnTap;
  final Function()? privacyOnTap;

  const TwakeWelcomeScreen({
    super.key,
    required this.welcomeTo,
    required this.descriptionWelcomeTo,
    required this.titleStartMessaging,
    required this.titlePrivacy,
    required this.logo,
    this.buttonOnTap,
    this.privacyOnTap,
    this.welcomeToStyle,
    this.privacyTextStyle,
    this.descriptionWelcomeToStyle,
    this.titleStartMessagingStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinagoraSysColors.material().linearGradientStartingPage,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  welcomeTo,
                  style: welcomeToStyle ??
                      Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color:
                                LinagoraSysColors.material().onSurfaceVariant,
                          ),
                ),
                logo,
                Padding(
                  padding: TwakeWelcomeScreenStyle.descriptionPadding,
                  child: Text(
                    descriptionWelcomeTo,
                    textAlign: TextAlign.center,
                    style: descriptionWelcomeToStyle ??
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color:
                                  LinagoraSysColors.material().onSurfaceVariant,
                            ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: TwakeWelcomeScreenStyle.buttonPadding,
                child: Column(
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: buttonOnTap,
                      child: Container(
                        height: TwakeWelcomeScreenStyle.buttonHeight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: LinagoraSysColors.material().primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TwakeWelcomeScreenStyle.buttonRadius,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            titleStartMessaging,
                            textAlign: TextAlign.center,
                            style: titleStartMessagingStyle ??
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: LinagoraSysColors.material()
                                          .onPrimary,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: privacyOnTap,
                      child: Text(
                        titlePrivacy,
                        style: privacyTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
