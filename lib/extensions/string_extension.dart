
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart' show StringCharacters;
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

extension StringInitials on String {
  static const _separators = {' ', '.', '_', '-', '\t', '\n'};

  /// Zero-width and other format blanks that still look empty on screen.
  static const _formatBlanks = {
    '\u200B',
    '\u200C',
    '\u200D',
    '\u2060',
    '\uFEFF',
  };

  /// True when the string is empty, whitespace-only, or only format blanks.
  bool get isVisuallyBlank => characters.every(_isBlankCharacter);

  static bool _isBlankCharacter(String character) {
    return character.trim().isEmpty || _formatBlanks.contains(character);
  }

  static bool _isWordBreak(String character) {
    return _separators.contains(character) || _isBlankCharacter(character);
  }

  /// Up to two upper-case initials: "Nora Hale" → "NH",
  /// "nora.hale@example.com" → "NH", "Nora" → "N".
  String get initials {
    final source = split('@').first;
    final words = <String>[];
    var current = StringBuffer();
    for (final character in source.characters) {
      if (_isWordBreak(character)) {
        if (current.isNotEmpty) words.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(character);
      }
    }
    if (current.isNotEmpty) words.add(current.toString());

    return words
        .take(2)
        .map((word) => word.characters.first)
        .join()
        .toUpperCase();
  }
}
