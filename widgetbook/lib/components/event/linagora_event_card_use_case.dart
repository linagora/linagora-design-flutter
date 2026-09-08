import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Every component the card can draw, shown at once with every control live.
///
/// The response pills and the status notice would not both appear on a real
/// event; they sit together here so the showcase covers every part. Use the
/// Playground to switch a single state on or off.
@widgetbook.UseCase(name: 'Complete card', type: LinagoraEventCard)
Widget linagoraEventCardUseCase(BuildContext context) {
  return const _Frame(
    child: _InteractiveEventCard(
      content: _CardContent(
        actions: [_mailToAttendees],
        status: _notInvitedStatus,
      ),
    ),
  );
}

/// Every section behind a knob, for checking the card against partial data.
@widgetbook.UseCase(name: 'Playground', type: LinagoraEventCard)
Widget linagoraEventCardPlaygroundUseCase(BuildContext context) {
  final layout = _LayoutKnobs.fromContext(context);
  final header = _HeaderKnobs.fromContext(context);
  final conference = _ConferenceKnobs.fromContext(context);
  final details = _DetailKnobs.fromContext(context);
  final responses = _ResponseKnobs.fromContext(context);
  final actions = _ActionKnobs.fromContext(context);

  return _Frame(
    width: layout.width,
    child: _InteractiveEventCard(
      layout: layout.layout,
      prefixWidth: layout.prefixWidth,
      content: _CardContent(
        date: header.showDate ? _date : null,
        activity: header.showActivity ? header.activity : null,
        actorName: header.showActor ? _actorName : null,
        activityState: header.state,
        title: header.showTitle ? _title : null,
        moreInformation: header.showMoreInformation ? _moreInformation : null,
        conference: conference.value,
        details: details.value,
        status: details.status,
        attending: responses.value,
        actions: actions.value,
        calendarAction: actions.calendar,
      ),
    ),
  );
}

/// Everything the card renders, so the interactive wrapper can carry it in
/// one argument instead of restating the card's own parameter list.
class _CardContent {
  final LinagoraEventDate? date;
  final String? activity;
  final String? actorName;
  final EventActivityBadgeState activityState;
  final String? title;
  final LinagoraEventAction? moreInformation;
  final LinagoraEventConference? conference;
  final List<LinagoraEventDetail> details;
  final LinagoraEventAttending? attending;
  final List<LinagoraEventAction> actions;
  final LinagoraEventStatus? status;
  final LinagoraEventAction? calendarAction;

  const _CardContent({
    this.date = _date,
    this.activity = _activity,
    this.actorName = _actorName,
    this.activityState = EventActivityBadgeState.created,
    this.title = _title,
    this.moreInformation = _moreInformation,
    this.conference = _conference,
    this.details = _details,
    this.attending = _attending,
    this.actions = const [],
    this.status,
    this.calendarAction = _calendarAction,
  });
}

/// Holds the state the card is too stateless to own: the answer the reader
/// gave, and whether the participant list is open.
class _InteractiveEventCard extends StatefulWidget {
  final _CardContent content;
  final LinagoraEventCardLayout layout;
  final double prefixWidth;

  const _InteractiveEventCard({
    required this.content,
    this.layout = LinagoraEventCardLayout.adaptive,
    this.prefixWidth = LinagoraEventInfoRow.defaultPrefixWidth,
  });

  @override
  State<_InteractiveEventCard> createState() => _InteractiveEventCardState();
}

class _InteractiveEventCardState extends State<_InteractiveEventCard> {
  String? _response;
  bool _participantsExpanded = false;

  void _select(String label) => setState(() => _response = label);

  void _toggleParticipants() =>
      setState(() => _participantsExpanded = !_participantsExpanded);

  @override
  Widget build(BuildContext context) {
    final content = widget.content;

    return LinagoraEventCard(
      layout: widget.layout,
      prefixWidth: widget.prefixWidth,
      date: content.date,
      activity: content.activity,
      actorName: content.actorName,
      activityState: content.activityState,
      title: content.title,
      moreInformation: content.moreInformation,
      conference: content.conference,
      details: [
        for (final detail in content.details)
          _isParticipants(detail) ? _participantsDetail(detail) : detail,
      ],
      attending: _liveAttending(content.attending),
      actions: content.actions,
      status: content.status,
      calendarAction: content.calendarAction,
    );
  }

  bool _isParticipants(LinagoraEventDetail detail) =>
      detail.action?.label == _seeAllParticipants;

  LinagoraEventDetail _participantsDetail(LinagoraEventDetail detail) {
    return LinagoraEventDetail(
      label: detail.label,
      values: detail.values,
      indicator: detail.indicator,
      lines: _participantsExpanded
          ? [
              for (final participant in _participants)
                LinagoraEventLine([
                  if (participant.hasName)
                    LinagoraEventValue.strong(participant.name!),
                  LinagoraEventValue.muted(participant.email),
                ]),
            ]
          : const [],
      action: LinagoraEventAction(
        label: _participantsExpanded ? 'Hide' : _seeAllParticipants,
        onPressed: _toggleParticipants,
      ),
    );
  }

  LinagoraEventAttending? _liveAttending(LinagoraEventAttending? attending) {
    if (attending == null) return null;

    return LinagoraEventAttending(
      label: attending.label,
      selectedResponse: _response,
      secondaryAction: attending.secondaryAction,
      responses: [
        for (final response in attending.responses)
          LinagoraEventAction(
            label: response.label,
            onPressed: () => _select(response.label),
          ),
      ],
    );
  }
}

const String _seeAllParticipants = 'See all participants';
const String _actorName = 'Alex Martin';
const String _activity = 'has invited you in to a meeting';
const String _title = 'Automated DS Flutter';
const _date = LinagoraEventDate(month: 'Jun', day: '16');

const _moreInformation = LinagoraEventAction(
  label: 'More information',
  onPressed: _noop,
);

const _conference = LinagoraEventConference(
  join: LinagoraEventAction(
    label: 'Join the video conference',
    onPressed: _noop,
  ),
  onCopyLink: _noop,
);

const _calendarAction = LinagoraEventAction(
  label: 'See in your Calendar',
  icon: Icons.calendar_today,
  onPressed: _noop,
);

const _details = [
  LinagoraEventDetail(
    label: 'When',
    values: [
      LinagoraEventValue.strong('Tuesday, Jun 16'),
      LinagoraEventValue('·'),
      LinagoraEventValue('12:00 – 12:30'),
    ],
    indicator: _WarningIndicator(),
  ),
  LinagoraEventDetail(
    label: 'Where',
    values: [LinagoraEventValue('Villa Good Tech, 37 rue Pierre')],
    action: LinagoraEventAction(label: 'See in Map', onPressed: _noop),
  ),
  LinagoraEventDetail(
    label: 'Who',
    values: [
      LinagoraEventValue.strong(_actorName),
      LinagoraEventValue.muted('alex.martin@example.invalid'),
      LinagoraEventValue('- Organizer'),
    ],
    action: LinagoraEventAction(label: _seeAllParticipants),
  ),
];

const _mailToAttendees = LinagoraEventAction(
  label: 'Mail to attendees',
  onPressed: _noop,
);

const _notInvitedStatus = LinagoraEventStatus(
  'You are not invited to this event. Please contact the organizer.',
);

const _attending = LinagoraEventAttending(
  label: 'Attending?',
  responses: [
    LinagoraEventAction(label: 'Yes'),
    LinagoraEventAction(label: 'No'),
    LinagoraEventAction(label: 'Maybe'),
  ],
  secondaryAction: LinagoraEventAction(
    label: 'Propose a new time',
    onPressed: _noop,
  ),
);

/// A participant, with or without a display name — both shapes appear in a
/// real attendee list, so the fixture mixes them.
class _Participant {
  final String? name;
  final String email;

  const _Participant(this.email, {this.name});

  bool get hasName => name != null;
}

const _participants = [
  _Participant('jordan.blake@example.invalid', name: 'Jordan Blake'),
  _Participant('priya.raman@example.invalid'),
  _Participant('tomas.novak@example.invalid', name: 'Tomas Novak'),
  _Participant('lea.fontaine@example.invalid'),
  _Participant('samir.haddad@example.invalid', name: 'Samir Haddad'),
  _Participant('ingrid.olsen@example.invalid'),
  _Participant('chen.wei@example.invalid', name: 'Chen Wei'),
  _Participant('marta.silva@example.invalid'),
  _Participant('ousmane.diallo@example.invalid', name: 'Ousmane Diallo'),
  _Participant('yuki.tanaka@example.invalid'),
];

class _LayoutKnobs {
  final LinagoraEventCardLayout layout;
  final double width;
  final double prefixWidth;

  const _LayoutKnobs({
    required this.layout,
    required this.width,
    required this.prefixWidth,
  });

  factory _LayoutKnobs.fromContext(BuildContext context) {
    return _LayoutKnobs(
      layout: context.knobs.object.dropdown<LinagoraEventCardLayout>(
        label: 'Layout',
        options: LinagoraEventCardLayout.values,
        initialOption: LinagoraEventCardLayout.adaptive,
        labelBuilder: (value) => value.name,
      ),
      width: context.knobs.double.slider(
        label: 'Available width',
        initialValue: 1134,
        min: 320,
        max: 1400,
      ),
      prefixWidth: context.knobs.double.slider(
        label: 'Label column width',
        initialValue: LinagoraEventInfoRow.defaultPrefixWidth,
        min: 0,
        max: 200,
      ),
    );
  }
}

class _HeaderKnobs {
  final bool showDate;
  final bool showActivity;
  final bool showActor;
  final String activity;
  final EventActivityBadgeState state;
  final bool showTitle;
  final bool showMoreInformation;

  const _HeaderKnobs({
    required this.showDate,
    required this.showActivity,
    required this.showActor,
    required this.activity,
    required this.state,
    required this.showTitle,
    required this.showMoreInformation,
  });

  factory _HeaderKnobs.fromContext(BuildContext context) {
    return _HeaderKnobs(
      showDate: context.knobs.boolean(label: 'Date marker', initialValue: true),
      showActivity: context.knobs.boolean(
        label: 'Activity badge',
        initialValue: true,
      ),
      showActor: context.knobs.boolean(label: 'Actor name', initialValue: true),
      activity: context.knobs.string(
        label: 'Activity',
        initialValue: _activity,
      ),
      state: context.knobs.object.dropdown<EventActivityBadgeState>(
        label: 'Activity state',
        options: EventActivityBadgeState.values,
        labelBuilder: (value) => value.name,
      ),
      showTitle: context.knobs.boolean(label: 'Title', initialValue: true),
      showMoreInformation: context.knobs.boolean(
        label: 'More information link',
        initialValue: true,
      ),
    );
  }
}

class _ConferenceKnobs {
  final LinagoraEventConference? value;

  const _ConferenceKnobs(this.value);

  factory _ConferenceKnobs.fromContext(BuildContext context) {
    final join = context.knobs.boolean(
      label: 'Join conference button',
      initialValue: true,
    );
    final copy = context.knobs.boolean(
      label: 'Copy link button',
      initialValue: true,
    );

    if (!join && !copy) return const _ConferenceKnobs(null);

    return _ConferenceKnobs(
      LinagoraEventConference(
        join: join ? _conference.join : null,
        onCopyLink: copy ? _noop : null,
      ),
    );
  }
}

class _DetailKnobs {
  final List<LinagoraEventDetail> value;
  final LinagoraEventStatus? status;

  const _DetailKnobs({required this.value, required this.status});

  factory _DetailKnobs.fromContext(BuildContext context) {
    // Every knob is read whether or not its row survives, so hiding a row
    // does not make controls vanish from the panel. A hidden row still takes
    // its link and indicator with it, because they belong to the row.
    final rows = [
      for (final detail in _details) _DetailKnobs._row(context, detail),
    ];

    return _DetailKnobs(
      status: context.knobs.boolean(
            label: 'Status notice',
            initialValue: false,
          )
          ? _notInvitedStatus
          : null,
      value: rows.whereType<LinagoraEventDetail>().toList(),
    );
  }

  static LinagoraEventDetail? _row(
    BuildContext context,
    LinagoraEventDetail detail,
  ) {
    final shown = context.knobs.boolean(
      label: 'Row: ${detail.label}',
      initialValue: true,
    );
    // The knob keeps the fixture's name so it stays put in the panel while
    // the label it edits changes. An empty value drops the prefix but holds
    // the column, so the values stay lined up.
    final label = context.knobs.string(
      label: 'Label: ${detail.label}',
      initialValue: detail.label ?? '',
    );
    final action = detail.action;
    final showAction =
        action != null &&
        context.knobs.boolean(
          label: 'Link: ${action.label}',
          initialValue: true,
        );
    final showIndicator =
        detail.indicator != null &&
        context.knobs.boolean(
          label: 'Indicator: ${detail.label}',
          initialValue: true,
        );

    if (!shown) return null;

    return LinagoraEventDetail(
      label: label,
      values: detail.values,
      action: showAction ? action : null,
      indicator: showIndicator ? detail.indicator : null,
    );
  }
}

class _ResponseKnobs {
  final LinagoraEventAttending? value;

  const _ResponseKnobs(this.value);

  factory _ResponseKnobs.fromContext(BuildContext context) {
    final showLabel = context.knobs.boolean(
      label: 'Attending label',
      initialValue: true,
    );
    final label = context.knobs.string(
      label: 'Label: ${_attending.label}',
      initialValue: _attending.label ?? '',
    );
    final secondary = context.knobs.boolean(
      label: 'Propose a new time',
      initialValue: true,
    );
    final responses = [
      for (final response in _attending.responses)
        if (context.knobs.boolean(
          label: 'Response: ${response.label}',
          initialValue: true,
        ))
          response,
    ];

    if (responses.isEmpty && !secondary) return const _ResponseKnobs(null);

    return _ResponseKnobs(
      LinagoraEventAttending(
        label: showLabel ? label : null,
        responses: responses,
        secondaryAction: secondary ? _attending.secondaryAction : null,
      ),
    );
  }
}

class _ActionKnobs {
  final List<LinagoraEventAction> value;
  final LinagoraEventAction? calendar;

  const _ActionKnobs({required this.value, required this.calendar});

  factory _ActionKnobs.fromContext(BuildContext context) {
    return _ActionKnobs(
      value: [
        if (context.knobs.boolean(
          label: 'Mail to attendees',
          initialValue: false,
        ))
          _mailToAttendees,
      ],
      calendar:
          context.knobs.boolean(label: 'Calendar action', initialValue: true)
          ? _calendarAction
          : null,
    );
  }
}

/// The status glyph beside a time, explained on hover.
class _WarningIndicator extends StatelessWidget {
  static const Color color = Color(0xFFFFB300);

  const _WarningIndicator();

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      message: 'Conflicts with another event',
      child: Icon(Icons.error, size: 16, color: color),
    );
  }
}

/// Caps the card's width so the layout knob has something to react to, while
/// still letting a narrow device frame squeeze it into the compact layout.
class _Frame extends StatelessWidget {
  static const double defaultWidth = 1134;

  final Widget child;
  final double? width;

  const _Frame({required this.child, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width ?? defaultWidth),
          child: child,
        ),
      ),
    );
  }
}

void _noop() {}
