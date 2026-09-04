import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'All states', type: EventActivityBadge)
Widget eventActivityBadgeStatesUseCase(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          EventActivityBadge(
            actorName: 'userA',
            activity: 'has invited you in to a meeting',
          ),
          EventActivityBadge(
            state: EventActivityBadgeState.reminder,
            activity: 'This event is about to begin in 15 minutes',
          ),
          EventActivityBadge(
            state: EventActivityBadgeState.updated,
            actorName: 'userA',
            activity: 'has updated an event',
          ),
          EventActivityBadge(
            state: EventActivityBadgeState.accepted,
            actorName: 'userA',
            activity: 'has accepted this invitation',
          ),
          EventActivityBadge(
            state: EventActivityBadgeState.canceled,
            actorName: 'userA',
            activity: 'has canceled a meeting',
          ),
          EventActivityBadge(
            state: EventActivityBadgeState.notInvited,
            activity:
                'You are not invited to this event. Please contact the organizer.',
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Custom', type: EventActivityBadge)
Widget eventActivityBadgeCustomUseCase(BuildContext context) {
  final state = context.knobs.object.dropdown<EventActivityBadgeState>(
    label: 'State',
    options: EventActivityBadgeState.values,
    initialOption: EventActivityBadgeState.created,
    labelBuilder: (state) => state.name,
  );
  final hasActor = context.knobs.boolean(
    label: 'Show actor',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.knobs.double.slider(
            label: 'Maximum width',
            initialValue: 343,
            min: 120,
            max: 1089,
          ),
        ),
        child: EventActivityBadge(
          state: state,
          actorName: hasActor
              ? context.knobs.string(
                  label: 'Actor name',
                  initialValue: 'userA',
                )
              : null,
          activity: context.knobs.string(
            label: 'Activity',
            initialValue: 'has invited you in to a meeting',
          ),
          backgroundColor: context.knobs.colorOrNull(
            label: 'Background override',
            initialValue: null,
            defaultToNull: true,
          ),
          foregroundColor: context.knobs.colorOrNull(
            label: 'Text override',
            initialValue: null,
            defaultToNull: true,
          ),
        ),
      ),
    ),
  );
}
