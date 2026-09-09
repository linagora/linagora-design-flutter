import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  group('LinagoraEventDetail.when', () {
    test('builds the standard date and time value run', () {
      final detail = LinagoraEventDetail.when(
        label: 'When',
        dateTime: const LinagoraEventDateTime(
          date: 'Tuesday, June 16, 2026',
          time: '10:00 AM - 11:00 AM',
        ),
      );

      expect(detail.values.map((value) => value.text), [
        'Tuesday, June 16, 2026',
        LinagoraEventDetail.defaultDateTimeSeparator,
        '10:00 AM - 11:00 AM',
      ]);
      expect(detail.values.map((value) => value.emphasis), const [
        LinagoraEventInfoEmphasis.strong,
        LinagoraEventInfoEmphasis.normal,
        LinagoraEventInfoEmphasis.normal,
      ]);
    });
  });

  group('LinagoraEventDetail.participants', () {
    test('builds organiser values and attendee lines', () {
      var organizerTaps = 0;
      final event = Object();
      final expansion = LinagoraEventDetailExpansion(
        expandLabel: 'See all attendees',
        collapseLabel: 'Hide',
        identity: event,
      );
      final detail = LinagoraEventDetail.participants(
        labels: const LinagoraEventParticipantLabels(
          label: 'Who',
          organizerLabel: 'Organizer',
        ),
        organizer: LinagoraEventParticipant(
          name: 'Alex Martin',
          address: 'alex@example.invalid',
          onAddressTap: () => organizerTaps++,
        ),
        attendees: const [
          LinagoraEventParticipant(
            name: 'Jordan Blake',
            address: 'jordan@example.invalid',
          ),
        ],
        expansion: expansion,
      );

      expect(detail.values.map((value) => value.text), [
        'Alex Martin',
        'alex@example.invalid',
        '- Organizer',
      ]);
      expect(detail.lines.single.values.map((value) => value.text), [
        'Jordan Blake',
        'jordan@example.invalid',
      ]);
      expect(detail.expansion, same(expansion));
      expect(detail.expansion?.identity, same(event));

      detail.values[1].onTap!();
      expect(organizerTaps, 1);
    });
  });

  group('LinagoraEventAttending', () {
    test('uses stable identity instead of a localised label', () {
      const yes = LinagoraEventAction(id: 'yes', label: 'Same label');
      const no = LinagoraEventAction(id: 'no', label: 'Same label');
      const attending = LinagoraEventAttending(
        responses: [yes, no],
        selectedResponse: 'Same label',
        selectedResponseId: 'no',
      );

      expect(attending.isSelected(yes), isFalse);
      expect(attending.isSelected(no), isTrue);
    });

    test('keeps label selection backward compatible', () {
      const response = LinagoraEventAction(label: 'Yes');
      const attending = LinagoraEventAttending(
        responses: [response],
        selectedResponse: 'Yes',
      );

      expect(attending.isSelected(response), isTrue);
    });
  });

  test('LinagoraEventConference.fromLink delegates link actions', () {
    final opened = <String>[];
    final copied = <String>[];
    final conference = LinagoraEventConference.fromLink(
      link: 'https://meet.example.invalid/room',
      label: 'Join',
      onOpenLink: opened.add,
      onCopyLink: copied.add,
      copyTooltip: 'Copy link',
    );

    conference.join!.onPressed!();
    conference.onCopyLink!();

    expect(conference.join!.id, 'https://meet.example.invalid/room');
    expect(opened, ['https://meet.example.invalid/room']);
    expect(copied, ['https://meet.example.invalid/room']);
    expect(conference.copyTooltip, 'Copy link');
  });
}
