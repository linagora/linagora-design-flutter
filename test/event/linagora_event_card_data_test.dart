import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  group('LinagoraEventAction.calendar', () {
    test('uses the packaged calendar SVG by default', () {
      final action = LinagoraEventAction.calendar(
        id: 'event-42',
        label: 'See in your Calendar',
        tooltip: 'Open event',
      );

      final iconLoader = (action.icon!.widget as SvgPicture).bytesLoader
          as SvgAssetLoader;
      expect(iconLoader.assetName, LinagoraDesignImages.calendarTodayIcon);
      expect(iconLoader.packageName, LinagoraDesignImages.packageName);
      expect(action.id, 'event-42');
      expect(action.label, 'See in your Calendar');
      expect(action.tooltip, 'Open event');
      expect(action.icon?.data, isNull);
    });

    test('uses a custom IconData instead of the packaged SVG', () {
      final action = LinagoraEventAction.calendar(
        label: 'Open calendar',
        icon: const LinagoraEventActionIcon.data(
          Icons.event,
          color: Colors.indigo,
        ),
      );

      expect(action.icon?.data, Icons.event);
      expect(action.icon?.widget, isNull);
      expect(action.icon?.color, Colors.indigo);
    });

    test('uses a custom widget instead of the packaged SVG', () {
      const customIcon = SizedBox(key: Key('custom-calendar-icon'));
      final action = LinagoraEventAction.calendar(
        label: 'Open calendar',
        icon: const LinagoraEventActionIcon.widget(
          customIcon,
          color: Colors.teal,
        ),
      );

      expect(action.icon?.data, isNull);
      expect(action.icon?.widget, same(customIcon));
      expect(action.icon?.color, Colors.teal);
    });
  });

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

    test('omits the organiser suffix when the organiser is empty', () {
      final detail = LinagoraEventDetail.participants(
        labels: const LinagoraEventParticipantLabels(
          label: 'Who',
          organizerLabel: 'Organizer',
        ),
        organizer: const LinagoraEventParticipant(),
        expansion: const LinagoraEventDetailExpansion(
          expandLabel: 'See all attendees',
          collapseLabel: 'Hide',
        ),
      );

      expect(detail.values, isEmpty);
      expect(
        detail.values.map((value) => value.text),
        isNot(contains('- Organizer')),
      );
    });

    test('filters empty attendees from the participant lines', () {
      final detail = LinagoraEventDetail.participants(
        labels: const LinagoraEventParticipantLabels(
          label: 'Who',
          organizerLabel: 'Organizer',
        ),
        attendees: const [
          LinagoraEventParticipant(),
          LinagoraEventParticipant(name: '', address: ''),
          LinagoraEventParticipant(name: 'Jordan Blake'),
        ],
        expansion: const LinagoraEventDetailExpansion(
          expandLabel: 'See all attendees',
          collapseLabel: 'Hide',
        ),
      );

      expect(detail.lines, hasLength(1));
      expect(detail.lines.single.values.single.text, 'Jordan Blake');
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
      copySemanticLabel: 'Copy conference URL',
    );

    conference.join!.onPressed!();
    conference.onCopyLink!();

    expect(conference.join!.id, 'https://meet.example.invalid/room');
    expect(opened, ['https://meet.example.invalid/room']);
    expect(copied, ['https://meet.example.invalid/room']);
    expect(conference.copyTooltip, 'Copy link');
    expect(conference.copySemanticLabel, 'Copy conference URL');
  });
}
