import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/event/event_activity_badge.dart';
import 'package:linagora_design_flutter/event/linagora_event_info_text.dart';

/// A calendar date shown on the card's date marker.
class LinagoraEventDate {
  /// An already-localised three-character month label.
  final String month;

  /// A calendar day from 1 through 31.
  final String day;

  const LinagoraEventDate({required this.month, required this.day});
}

/// Everything an event card renders, independent of its layout and styling.
class LinagoraEventCardData {
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

  const LinagoraEventCardData({
    this.date,
    this.activity,
    this.actorName,
    this.activityState = EventActivityBadgeState.created,
    this.title,
    this.moreInformation,
    this.conference,
    this.details = const [],
    this.attending,
    this.actions = const [],
    this.status,
    this.calendarAction,
  });
}

/// Something the reader can do, rendered as a link or a button depending on
/// where the card places it.
class LinagoraEventAction {
  final String label;

  /// A null callback disables the control and keeps it visible.
  final VoidCallback? onPressed;

  final IconData? icon;

  /// Colour for [icon] when it should differ from the label.
  final Color? iconColor;

  final String? tooltip;

  const LinagoraEventAction({
    required this.label,
    this.onPressed,
    this.icon,
    this.iconColor,
    this.tooltip,
  });
}

/// One value inside a detail row, with the weight it carries.
class LinagoraEventValue {
  final String text;
  final LinagoraEventInfoEmphasis emphasis;

  /// Makes the value act on a tap, the way an email address opens a contact
  /// sheet or a location opens a map. Null leaves it as plain text.
  final VoidCallback? onTap;

  const LinagoraEventValue(
    this.text, {
    this.emphasis = LinagoraEventInfoEmphasis.normal,
    this.onTap,
  });

  /// A value the reader scans for, such as a date or an organiser's name.
  const LinagoraEventValue.strong(this.text, {this.onTap})
    : emphasis = LinagoraEventInfoEmphasis.strong;

  /// A value secondary to the one beside it, such as an email address.
  const LinagoraEventValue.muted(this.text, {this.onTap})
    : emphasis = LinagoraEventInfoEmphasis.muted;

  /// A value that is itself a destination, such as a URL inside a location.
  const LinagoraEventValue.link(this.text, {this.onTap})
    : emphasis = LinagoraEventInfoEmphasis.link;
}

/// One line of values inside a detail row.
class LinagoraEventLine {
  final List<LinagoraEventValue> values;

  const LinagoraEventLine(this.values);
}

/// One labelled line of the card — `When`, `Where`, `Who`.
///
/// Every part is optional so a card can render whatever the event actually
/// carries: a row with no [label] starts at the value column, and a row with
/// no [action] simply omits the link.
class LinagoraEventDetail {
  final String? label;
  final List<LinagoraEventValue> values;

  /// A link at the end of the value run, such as `See in Map`.
  final LinagoraEventAction? action;

  /// A status glyph after the values, such as a scheduling conflict warning.
  final Widget? indicator;

  /// Further lines under [values], each laid out as its own run — an expanded
  /// participant list, for instance.
  ///
  /// While this is non-empty the row stacks its lines and [action] moves onto
  /// a line of its own.
  final List<LinagoraEventLine> lines;

  /// Lets the card own expansion of [lines] without involving product state.
  ///
  /// [action] must be null while expansion is configured because the row has
  /// one trailing action slot, which expansion uses for its toggle.
  final LinagoraEventDetailExpansion? expansion;

  const LinagoraEventDetail({
    this.label,
    this.values = const [],
    this.action,
    this.indicator,
    this.lines = const [],
    this.expansion,
  }) : assert(
         expansion == null || action == null,
         'An expandable detail cannot also carry an action',
       );

  /// Whether the row would render nothing at all.
  bool get isEmpty =>
      values.isEmpty && action == null && indicator == null && lines.isEmpty;
}

/// Presentation-only expansion configuration for an event detail's lines.
class LinagoraEventDetailExpansion {
  /// Lines kept visible while the detail is collapsed.
  final int collapsedLineCount;

  /// Expansion is offered only when the detail carries more lines than this.
  final int collapseThreshold;

  final String expandLabel;
  final String collapseLabel;
  final bool initiallyExpanded;

  /// Changes to this value reset the detail to [initiallyExpanded].
  final Object? identity;

  final ValueChanged<bool>? onChanged;

  const LinagoraEventDetailExpansion({
    required this.expandLabel,
    required this.collapseLabel,
    this.collapsedLineCount = 5,
    this.collapseThreshold = 6,
    this.initiallyExpanded = false,
    this.identity,
    this.onChanged,
  }) : assert(
         collapsedLineCount >= 0,
         'Collapsed line count cannot be negative',
       ),
       assert(
         collapseThreshold >= collapsedLineCount,
         'Collapse threshold cannot be below the collapsed line count',
       );
}

/// The invitation response block.
class LinagoraEventAttending {
  final String? label;

  /// The mutually exclusive answers, rendered as filled pills.
  final List<LinagoraEventAction> responses;

  /// Label of the answer already given. That pill renders as settled and
  /// stops responding to taps.
  final String? selectedResponse;

  /// A borderless action beside the pills, such as `Propose a new time`.
  final LinagoraEventAction? secondaryAction;

  const LinagoraEventAttending({
    this.label,
    this.responses = const [],
    this.selectedResponse,
    this.secondaryAction,
  });

  bool get isEmpty => responses.isEmpty && secondaryAction == null;

  bool isSelected(LinagoraEventAction response) =>
      selectedResponse != null && selectedResponse == response.label;
}

/// A notice under the detail rows, such as an ineligibility message.
///
/// Rendered with the same treatment as the activity badge, so [state] picks
/// its colour the same way.
class LinagoraEventStatus {
  final String message;
  final EventActivityBadgeState state;

  const LinagoraEventStatus(
    this.message, {
    this.state = EventActivityBadgeState.notInvited,
  });
}

/// The video conference controls in the card header.
class LinagoraEventConference {
  /// The primary join action. Null hides the button.
  final LinagoraEventAction? join;

  /// Copies the conference link. Null hides the icon button.
  final VoidCallback? onCopyLink;

  final String? copyTooltip;

  const LinagoraEventConference({
    this.join,
    this.onCopyLink,
    this.copyTooltip,
  });

  bool get isEmpty => join == null && onCopyLink == null;
}
