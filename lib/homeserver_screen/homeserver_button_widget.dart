import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/homeserver_screen/homeserver_button_style.dart';

class HomeserverButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final String title;
  final TextStyle? textStyle;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final Function()? onTap;

  const HomeserverButtonWidget({
    super.key,
    required this.title,
    this.backgroundColor,
    this.textStyle,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: highlightColor ?? Colors.transparent,
      splashColor: splashColor ?? Colors.transparent,
      focusColor: focusColor ?? Colors.transparent,
      hoverColor: hoverColor ?? Colors.transparent,
      overlayColor: overlayColor,
      onTap: onTap,
      child: Container(
        height: HomeserverButtonStyle.buttonHeight,
        width: MediaQuery.of(context).size.width -
            HomeserverButtonStyle.sizePaddingHorizontal,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor ?? LinagoraSysColors.material().primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              HomeserverButtonStyle.sizeBorderRadius,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
