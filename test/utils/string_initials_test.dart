import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/extensions/string_extension.dart';

void main() {
  group('StringInitials.initials', () {
    final cases = {
      'Nora Hale': 'NH',
      'nora.hale@example.com': 'NH',
      'Nora': 'N',
      'jean-paul example': 'JP',
      '  Mina   Calder  ': 'MC',
      'Émile Example': 'ÉE',
      'bob_smith@example.com': 'BS',
      '@example.com': '',
      '': '',
      'Nora\u00A0Hale': 'NH',
      '李\u3000明': '李明',
      'Nora\u200BHale': 'NH',
    };
    cases.forEach((input, expected) {
      test('"$input" → "$expected"', () => expect(input.initials, expected));
    });

    test('keeps a multi-code-unit first character whole', () {
      expect('👩‍💻 Dev'.initials, '👩‍💻D');
    });
  });

  group('StringInitials.isVisuallyBlank', () {
    for (final blank in ['', '   ', '\t\n', ' ​﻿ ']) {
      test('${blank.runes.toList()} is blank', () {
        expect(blank.isVisuallyBlank, isTrue);
      });
    }
    for (final visible in ['-', '...', '_', 'Nora', ' a ']) {
      test('"$visible" is not blank', () {
        expect(visible.isVisuallyBlank, isFalse);
      });
    }
  });
}
