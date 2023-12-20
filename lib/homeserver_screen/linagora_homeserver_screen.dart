import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/homeserver_screen/homeserver_button_widget.dart';
import 'package:linagora_design_flutter/homeserver_screen/linagora_homeserver_style.dart';
import 'package:linagora_design_flutter/resource/linagora_image_paths.dart';

class LinagoraHomeServerScreen extends StatelessWidget {
  final TextStyle? signInTextStyle;
  final TextStyle? createTwakeIdTextStyle;
  final TextStyle? useCompanyServerTextStyle;
  final TextStyle? descriptionTextStyle;
  final String signInTitle;
  final String createTwakeIdTitle;
  final String useCompanyServerTitle;
  final String description;

  const LinagoraHomeServerScreen({
    super.key,
    this.signInTextStyle,
    this.createTwakeIdTextStyle,
    this.useCompanyServerTextStyle,
    required this.signInTitle,
    required this.createTwakeIdTitle,
    required this.useCompanyServerTitle,
    required this.description,
    this.descriptionTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Padding(
                  padding: LinagoraHomeserverScreen.imagePadding,
                  child: SvgPicture.asset(
                    LinagoraImagePaths.twakeIdLogo,
                    width: LinagoraHomeserverScreen.imageWidth,
                    height: LinagoraHomeserverScreen.imageHeight,
                    package: LinagoraHomeserverScreen.packageAssets,
                  ),
                ),
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
            Positioned(
              bottom: 0,
              child: Padding(
                padding: LinagoraHomeserverScreen.buttonPadding,
                child: Column(
                  children: [
                    HomeserverButtonWidget(
                      title: createTwakeIdTitle,
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
                    HomeserverButtonWidget(
                      title: signInTitle,
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
                    Padding(
                      padding:
                          LinagoraHomeserverScreen.useCompanyServerTitlePadding,
                      child: Text(
                        useCompanyServerTitle,
                        style: useCompanyServerTextStyle ??
                            TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              color: LinagoraSysColors.material().primary,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                    const SizedBox(height: 28),
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
