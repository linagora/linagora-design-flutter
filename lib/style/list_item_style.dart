import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

class ListItemStyle {
  static const double height = 80.0;
  static BorderRadiusGeometry borderRadius =
      const BorderRadius.all(Radius.circular(4));
  static final Color backgroundColor =
      LinagoraRefColors.material().primary[100]!;

  static TextStyle titleTextStyle({
    required String fontFamily,
  }) =>
      LinagoraTextStyle.material().bodyMedium2.copyWith(
            color: LinagoraSysColors.material().onSurface,
            fontFamily: fontFamily,
          );

  static TextStyle subtitleTextStyle({
    required String fontFamily,
  }) =>
      LinagoraTextStyle.material().bodyMedium.copyWith(
            color: LinagoraSysColors.material().onSurface,
            fontFamily: fontFamily,
          );
}
