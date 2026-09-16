import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  test('preserves punctuation around a URL', () {
    final values = LinagoraEventTextValues.fromText(
      'Room (https://meet.example.com/abc), floor 2',
    );

    expect(values.map((value) => value.text), [
      'Room (',
      'meet.example.com/abc',
      '), floor 2',
    ]);
    expect(values[1].emphasis, LinagoraEventInfoEmphasis.link);
  });

  test('preserves whitespace between adjacent URLs', () {
    final values = LinagoraEventTextValues.fromText(
      'https://first.example.com https://second.example.com',
    );

    expect(values.map((value) => value.text), [
      'first.example.com',
      ' ',
      'second.example.com',
    ]);
  });

  test('delegates URL and email actions', () {
    final openedLinks = <String>[];
    final openedEmails = <String>[];
    final values = LinagoraEventTextValues.fromText(
      'https://meet.example.com ask@example.invalid',
      onOpenLink: openedLinks.add,
      onOpenEmail: openedEmails.add,
    );

    values[0].onTap!();
    values[2].onTap!();

    expect(openedLinks, ['https://meet.example.com']);
    expect(openedEmails, ['ask@example.invalid']);
  });
}
