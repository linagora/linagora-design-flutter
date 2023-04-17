
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:linagora_design_flutter/avatar/round_avatar_style.dart';

extension StringColor on String {
  List<Color> get avatarColors {
    return RoundAvatarStyle.defaultGradientColors[_generateIndex()];
  }

  int _generateIndex() {
    if (isNotEmpty) {
      final codeUnits = this.codeUnits;
      if (codeUnits.isNotEmpty) {
        final sumCodeUnits = codeUnits.sum;
        final index = sumCodeUnits % RoundAvatarStyle.defaultGradientColors.length;
        return index;
      }
    }
    return 0;
  }
}