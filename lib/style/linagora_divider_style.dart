import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_state_layer.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

class LinagoraDividerStyle {
  final Color color;
  final double thickness;
  final BoxBorder borderDecoration;

  static final LinagoraDividerStyle _materialLinagoraHoverStyle =
      LinagoraDividerStyle._material();

  factory LinagoraDividerStyle.material() {
    return _materialLinagoraHoverStyle;
  }

  LinagoraDividerStyle._material()
      : color = LinagoraStateLayer(LinagoraSysColors.material().surfaceTint)
            .opacityLayer3,
        thickness = 1.0,
        borderDecoration = Border(
          bottom: BorderSide(
            width: 1.0,
            color: LinagoraStateLayer(
              LinagoraSysColors.material().surfaceTint,
            ).opacityLayer3,
          ),
        );
}
