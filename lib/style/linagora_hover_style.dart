import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

class LinagoraHoverStyle {
  final Color hoverColor;
  final Color selectedColor;
  final BorderRadiusGeometry borderRadius;
  final BorderRadius hoverBorderRadius;

  static final LinagoraHoverStyle _materialLinagoraHoverStyle =
      LinagoraHoverStyle._material();

  factory LinagoraHoverStyle.material() {
    return _materialLinagoraHoverStyle;
  }

  LinagoraHoverStyle._material()
      : selectedColor = LinagoraSysColors.material().secondaryContainer,
        hoverColor = LinagoraSysColors.material().surface,
        borderRadius = const BorderRadius.all(
          Radius.circular(4),
        ),
        hoverBorderRadius = BorderRadius.circular(4);
}
