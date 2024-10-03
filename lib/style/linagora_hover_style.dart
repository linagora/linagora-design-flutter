import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

class LinagoraHoverStyle {
  final Color hoverColor;
  final Color selectedColor;
  final BorderRadiusGeometry borderRadius;

  static final LinagoraHoverStyle _materialLinagoraHoverStyle =
      LinagoraHoverStyle._material();

  factory LinagoraHoverStyle.material() {
    return _materialLinagoraHoverStyle;
  }

  LinagoraHoverStyle._material()
      : selectedColor = LinagoraSysColors.material().secondaryContainer,
        hoverColor = LinagoraSysColors.material().surface,
        borderRadius = BorderRadius.circular(4);
}
