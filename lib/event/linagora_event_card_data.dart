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

  const LinagoraEventDetail({
    this.label,
    this.values = const [],
    this.action,
    this.indicator,
    this.lines = const [],
  });

  /// Whether the row would render nothing at all.
  bool get isEmpty =>
      values.isEmpty && action == null && indicator == null && lines.isEmpty;
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
