import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/event/event_activity_badge.dart';
import 'package:linagora_design_flutter/event/event_conference_actions.dart';
import 'package:linagora_design_flutter/event/linagora_event_card_data.dart';
import 'package:linagora_design_flutter/event/linagora_event_date_icon.dart';
import 'package:linagora_design_flutter/event/linagora_event_info_row.dart';
import 'package:linagora_design_flutter/event/linagora_event_info_text.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// How a [LinagoraEventCard] arranges itself.
enum LinagoraEventCardLayout {
  /// Date marker beside a two-column header, labels beside their values.
  regular,

  /// No date marker, header stacked, labels above their values, and the
  /// response block centred.
  compact,

  /// [regular] while the card has room, [compact] below `compactBreakpoint`.
  adaptive,
}

/// A complete event invitation card.
///
/// Every section is driven by data and every section is optional, so a product
/// passes what the event carries and builds no UI of its own. A null or empty
/// section is omitted along with the gap that would precede it.
class LinagoraEventCard extends StatelessWidget {
  static const Color defaultBackgroundColor = Color(0xFFF3F6F9);
  static const double defaultBorderRadius = 16;

  /// Natural width of the conference block. Below it the header stacks.
  static const double conferenceNaturalWidth = 293;

  /// Width below which [LinagoraEventCardLayout.adaptive] goes compact.
  ///
  /// Matches [LinagoraEventInfoRow.defaultStackedBreakpoint] so the card and
  /// its rows always change together.
  static const double defaultCompactBreakpoint =
      LinagoraEventInfoRow.defaultStackedBreakpoint;

  /// Shown on the date marker. Null omits it, as the compact design does.
  final LinagoraEventDate? date;

  /// The activity line above the title, such as who invited the reader.
  final String? activity;

  /// The person the [activity] is about, shown in bold before it.
  final String? actorName;

  final EventActivityBadgeState activityState;

  final String? title;

  /// A link under the header, such as `More information`.
  final LinagoraEventAction? moreInformation;

  final LinagoraEventConference? conference;

  /// Conference controls rendered after [conference].
  final List<LinagoraEventConference> additionalConferences;

  /// The labelled rows. Rows that would render nothing are dropped.
  final List<LinagoraEventDetail> details;

  final LinagoraEventAttending? attending;

  /// Plain actions in the card's action row, such as `Mail to attendees`.
  ///
  /// Unlike [LinagoraEventAttending.responses] these carry no selection: they
  /// are things to do, not an answer to give.
  final List<LinagoraEventAction> actions;

  /// A notice between the detail rows and the action row.
  final LinagoraEventStatus? status;

  /// A trailing action for the action row, such as `See in your Calendar`.
  final LinagoraEventAction? calendarAction;

  final LinagoraEventCardLayout layout;
  final double compactBreakpoint;

  final Color backgroundColor;
  final double borderRadius;

  /// Overrides the padding the layout would otherwise pick.
  final EdgeInsetsGeometry? padding;

  /// Width of the label column while the card is [LinagoraEventCardLayout.regular].
  final double prefixWidth;

  const LinagoraEventCard({
    super.key,
    this.date,
    this.activity,
    this.actorName,
    this.activityState = EventActivityBadgeState.created,
    this.title,
    this.moreInformation,
    this.conference,
    this.additionalConferences = const [],
    this.details = const [],
    this.attending,
    this.actions = const [],
    this.status,
    this.calendarAction,
    this.layout = LinagoraEventCardLayout.adaptive,
    this.compactBreakpoint = defaultCompactBreakpoint,
    this.backgroundColor = defaultBackgroundColor,
    this.borderRadius = defaultBorderRadius,
    this.padding,
    this.prefixWidth = LinagoraEventInfoRow.defaultPrefixWidth,
  }) : assert(borderRadius >= 0, 'Border radius cannot be negative'),
       assert(compactBreakpoint >= 0, 'Compact breakpoint cannot be negative'),
       assert(prefixWidth >= 0, 'Prefix width cannot be negative');

  LinagoraEventCard.fromData(
    LinagoraEventCardData data, {
    super.key,
    this.layout = LinagoraEventCardLayout.adaptive,
    this.compactBreakpoint = defaultCompactBreakpoint,
    this.backgroundColor = defaultBackgroundColor,
    this.borderRadius = defaultBorderRadius,
    this.padding,
    this.prefixWidth = LinagoraEventInfoRow.defaultPrefixWidth,
  }) : date = data.date,
       activity = data.activity,
       actorName = data.actorName,
       activityState = data.activityState,
       title = data.title,
       moreInformation = data.moreInformation,
       conference = data.conference,
       additionalConferences = data.additionalConferences,
       details = data.details,
       attending = data.attending,
       actions = data.actions,
       status = data.status,
       calendarAction = data.calendarAction,
       assert(borderRadius >= 0, 'Border radius cannot be negative'),
       assert(compactBreakpoint >= 0, 'Compact breakpoint cannot be negative'),
       assert(prefixWidth >= 0, 'Prefix width cannot be negative');

  @override
  Widget build(BuildContext context) {
    return switch (layout) {
      LinagoraEventCardLayout.regular => _buildCard(compact: false),
      LinagoraEventCardLayout.compact => _buildCard(compact: true),
      LinagoraEventCardLayout.adaptive => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return _buildCard(
            compact: width.isFinite && width < compactBreakpoint,
          );
        },
      ),
    };
  }

  Widget _buildCard({required bool compact}) {
    final metrics = _CardMetrics.of(compact: compact);

    return Container(
      padding: padding ?? metrics.padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      // The compact design sets its rows one size up, so the scale is
      // published here rather than threaded through every row.
      child: LinagoraEventInfoTypeScale(
        scale: compact
            ? LinagoraEventInfoScale.compact
            : LinagoraEventInfoScale.regular,
        child: compact
            ? _buildCompactBody(metrics)
            : _buildRegularBody(metrics),
      ),
    );
  }

  Widget _buildRegularBody(_CardMetrics metrics) {
    final date = this.date;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: metrics.dateSpacing,
      children: [
        if (date != null)
          LinagoraEventDateIcon(month: date.month, day: date.day),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: metrics.sectionSpacing,
            children: [
              ..._sections([
                _buildRegularHeader(metrics),
                _buildDetails(metrics, compact: false),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget? _buildRegularHeader(_CardMetrics metrics) {
    final titleBlock = _buildTitleBlock(metrics);
    final conference = _buildConference();
    final moreInformation = _buildMoreInformation();

    if (titleBlock == null && conference == null && moreInformation == null) {
      return null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: metrics.headerSpacing,
      children: [
        ..._sections([
          if (titleBlock != null || conference != null)
            LayoutBuilder(
              builder: (context, constraints) => _buildHeaderRow(
                metrics,
                titleBlock: titleBlock,
                conference: conference,
                available: constraints.maxWidth,
              ),
            ),
          if (moreInformation != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: moreInformation,
            ),
        ]),
      ],
    );
  }

  Widget _buildCompactBody(_CardMetrics metrics) {
    final titleBlock = _buildTitleBlock(metrics);
    final conference = _buildConference();
    final moreInformation = _buildMoreInformation();
    final details = _buildDetails(metrics, compact: true);

    final header = titleBlock == null && conference == null
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: metrics.sectionSpacing,
            children: [
              ..._sections([titleBlock, conference]),
            ],
          );

    final body = moreInformation == null && details == null
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: metrics.sectionSpacing,
            children: [
              ..._sections([
                if (moreInformation != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: moreInformation,
                  ),
                details,
              ]),
            ],
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: metrics.sectionSpacing,
      children: [
        ..._sections([header, body]),
      ],
    );
  }

  /// Lays the title against the conference block, or stacks them once the row
  /// is too narrow to hold both.
  ///
  /// Stacking is the arrangement the compact design already uses, so a card
  /// pinned to [LinagoraEventCardLayout.regular] on a narrow surface degrades
  /// into a known layout rather than overflowing.
  Widget _buildHeaderRow(
    _CardMetrics metrics, {
    required Widget? titleBlock,
    required Widget? conference,
    required double available,
  }) {
    if (conference == null) return titleBlock ?? const SizedBox.shrink();
    if (titleBlock == null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: conference,
      );
    }

    if (available.isFinite && available < conferenceNaturalWidth) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: metrics.sectionSpacing,
        children: [titleBlock, conference],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: metrics.headerRowSpacing,
      children: [
        Expanded(child: titleBlock),
        // Half the row is more than the block's natural width at every size
        // the side-by-side header is used at, so this only bites while the
        // header is being squeezed, where the label ellipsizes.
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: available / 2),
          child: conference,
        ),
      ],
    );
  }

  Widget? _buildTitleBlock(_CardMetrics metrics) {
    final badge = _buildActivityBadge();
    final title = this.title;

    if (badge == null && (title == null || title.isEmpty)) return null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: metrics.titleSpacing,
      children: [
        if (badge != null) badge,
        if (title != null && title.isNotEmpty)
          Text(title, style: titleTextStyle()),
      ],
    );
  }

  /// The card title treatment, exposed so a product can measure or reuse it.
  static TextStyle titleTextStyle() {
    return LinagoraTextTheme.material().titleLarge!.copyWith(
      fontWeight: FontWeight.w400,
      height: 25.7 / 22,
      letterSpacing: 0,
      color: LinagoraEventInfoColors.content,
    );
  }

  Widget? _buildActivityBadge() {
    final activity = this.activity;
    if (activity == null || activity.isEmpty) return null;

    return EventActivityBadge(
      activity: activity,
      actorName: actorName,
      state: activityState,
    );
  }

  Widget? _buildConference() {
    final conference = this.conference;
    final conferences = [
      if (conference != null && !conference.isEmpty) conference,
      ...additionalConferences.where((conference) => !conference.isEmpty),
    ];
    if (conferences.isEmpty) return null;

    if (conferences.length == 1) {
      return _buildConferenceActions(conferences.single);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        for (final conference in conferences)
          _buildConferenceActions(conference),
      ],
    );
  }

  Widget _buildConferenceActions(LinagoraEventConference conference) {
    final join = conference.join;
    return EventConferenceActions(
      showVideoButton: join != null,
      showCopyButton: conference.onCopyLink != null,
      onVideoButtonPressed: join?.onPressed,
      onCopyLinkPressed: conference.onCopyLink,
      videoButtonLabel: join?.label ?? '',
      copyButtonTooltip: conference.copyTooltip,
    );
  }

  Widget? _buildMoreInformation() {
    final action = moreInformation;
    if (action == null) return null;

    return LinagoraEventInfoLink(
      label: action.label,
      onPressed: action.onPressed,
      icon: action.icon,
      tooltip: action.tooltip,
    );
  }

  Widget? _buildDetails(_CardMetrics metrics, {required bool compact}) {
    final rows = [
      for (final detail in details)
        if (!detail.isEmpty) _buildDetailRow(detail, compact: compact),
    ];

    final status = _buildStatusRow(compact: compact);
    if (status != null) rows.add(status);

    final actionRow = _buildActionRow(metrics, compact: compact);
    if (actionRow != null) rows.add(actionRow);
    if (rows.isEmpty) return null;

    return LinagoraEventInfoRowGroup(
      prefixWidth: compact ? null : prefixWidth,
      spacing: metrics.rowSpacing,
      rows: rows,
    );
  }

  Widget _buildDetailRow(LinagoraEventDetail detail, {required bool compact}) {
    final label = detail.label;

    return LinagoraEventInfoRow(
      layout: compact
          ? LinagoraEventInfoRowLayout.stacked
          : LinagoraEventInfoRowLayout.inline,
      crossAxisAlignment: CrossAxisAlignment.start,
      prefix: _prefix(label, compact: compact),
      content: _buildDetailContent(detail),
    );
  }

  /// The label, or a placeholder that holds the column open so an unlabelled
  /// row still lines its content up with the labelled ones.
  Widget? _prefix(String? label, {required bool compact}) {
    if (label != null && label.isNotEmpty) {
      return LinagoraEventInfoLabel(label);
    }
    return compact ? null : const SizedBox.shrink();
  }

  Widget? _buildStatusRow({required bool compact}) {
    final status = this.status;
    if (status == null || status.message.isEmpty) return null;

    return LinagoraEventInfoRow(
      layout: compact
          ? LinagoraEventInfoRowLayout.stacked
          : LinagoraEventInfoRowLayout.inline,
      crossAxisAlignment: CrossAxisAlignment.start,
      prefix: _prefix(null, compact: compact),
      content: EventActivityBadge(
        activity: status.message,
        state: status.state,
      ),
    );
  }

  Widget _buildDetailContent(LinagoraEventDetail detail) {
    final expansion = detail.expansion;
    if (expansion != null) {
      return _ExpandableEventDetailContent(
        detail: detail,
        expansion: expansion,
      );
    }

    return _EventDetailContent(
      values: detail.values,
      valueSpacing: detail.valueSpacing,
      lines: detail.lines,
      action: detail.action,
      indicator: detail.indicator,
    );
  }

  static Widget _buildValue(LinagoraEventValue value) {
    return LinagoraEventInfoText(
      value.text,
      emphasis: value.emphasis,
      onTap: value.onTap,
    );
  }

  Widget? _buildActionRow(_CardMetrics metrics, {required bool compact}) {
    final attending = this.attending;
    final calendarAction = this.calendarAction;
    final hasResponses = attending != null && !attending.isEmpty;

    if (!hasResponses && actions.isEmpty && calendarAction == null) return null;

    final label = attending?.label;
    final secondary = attending?.secondaryAction;

    return LinagoraEventInfoRow(
      expand: true,
      layout: compact
          ? LinagoraEventInfoRowLayout.stacked
          : LinagoraEventInfoRowLayout.inline,
      stackedAlignment: CrossAxisAlignment.center,
      stackedSpacing: metrics.attendingStackSpacing,
      prefix: _prefix(label, compact: compact),
      content: LinagoraEventInfoRun(
        alignment: compact ? WrapAlignment.center : WrapAlignment.start,
        children: [
          if (attending != null)
            for (final response in attending.responses)
              _EventPillButton(
                action: response,
                selected: attending.isSelected(response),
              ),
          for (final action in actions)
            _EventPillButton(action: action, selected: false),
          if (secondary != null) _EventTextButton(action: secondary),
        ],
      ),
      trailing: calendarAction == null
          ? null
          : _EventTextButton(action: calendarAction),
    );
  }

  /// Drops the nulls a hidden section leaves behind, so the surviving
  /// children keep exactly one gap between them.
  static Iterable<Widget> _sections(List<Widget?> children) =>
      children.whereType<Widget>();
}

class _ExpandableEventDetailContent extends StatefulWidget {
  final LinagoraEventDetail detail;
  final LinagoraEventDetailExpansion expansion;

  const _ExpandableEventDetailContent({
    required this.detail,
    required this.expansion,
  });

  @override
  State<_ExpandableEventDetailContent> createState() =>
      _ExpandableEventDetailContentState();
}

class _ExpandableEventDetailContentState
    extends State<_ExpandableEventDetailContent> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expansion.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant _ExpandableEventDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expansion.identity != widget.expansion.identity ||
        oldWidget.expansion.initiallyExpanded !=
            widget.expansion.initiallyExpanded) {
      _expanded = widget.expansion.initiallyExpanded;
    }
  }

  void _toggle() {
    final expanded = !_expanded;
    setState(() => _expanded = expanded);
    widget.expansion.onChanged?.call(expanded);
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final expansion = widget.expansion;
    final collapsible = detail.lines.length > expansion.collapseThreshold;
    final lines = _expanded || !collapsible
        ? detail.lines
        : detail.lines.take(expansion.collapsedLineCount).toList();

    return _EventDetailContent(
      values: detail.values,
      valueSpacing: detail.valueSpacing,
      lines: lines,
      indicator: detail.indicator,
      action: collapsible
          ? LinagoraEventAction(
              label: _expanded
                  ? expansion.collapseLabel
                  : expansion.expandLabel,
              onPressed: _toggle,
            )
          : null,
    );
  }
}

class _EventDetailContent extends StatelessWidget {
  final List<LinagoraEventValue> values;
  final double valueSpacing;
  final List<LinagoraEventLine> lines;
  final LinagoraEventAction? action;
  final Widget? indicator;

  const _EventDetailContent({
    required this.values,
    required this.valueSpacing,
    required this.lines,
    this.action,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    final link = action == null
        ? null
        : LinagoraEventInfoLink(
            label: action.label,
            onPressed: action.onPressed,
            icon: action.icon,
            tooltip: action.tooltip,
          );
    final firstLineChildren = <Widget>[
      for (final value in values) LinagoraEventCard._buildValue(value),
      if (indicator != null) indicator!,
      // A single-line row keeps its link in the run, where the design puts
      // it. Extra lines push it onto its own line below them instead.
      if (link != null && lines.isEmpty) link,
    ];
    final firstLine = LinagoraEventInfoRun(
      spacing: valueSpacing,
      children: firstLineChildren,
    );

    if (lines.isEmpty) return firstLine;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: LinagoraEventInfoRun.defaultSpacing,
      children: [
        if (firstLineChildren.isNotEmpty) firstLine,
        for (final line in lines)
          LinagoraEventInfoRun(
            spacing: valueSpacing,
            children: [
              for (final value in line.values)
                LinagoraEventCard._buildValue(value),
            ],
          ),
        if (link != null) link,
      ],
    );
  }
}

/// Spacing that changes between the regular and compact arrangements.
class _CardMetrics {
  final EdgeInsets padding;
  final double dateSpacing;
  final double sectionSpacing;
  final double headerSpacing;

  /// Separates the title block from the conference block beside it. The
  /// design never shows them meeting, because its activity badge is short;
  /// a long one runs the full column and would otherwise touch the button.
  final double headerRowSpacing;
  final double titleSpacing;
  final double rowSpacing;
  final double attendingStackSpacing;

  const _CardMetrics({
    required this.padding,
    required this.dateSpacing,
    required this.sectionSpacing,
    required this.headerSpacing,
    required this.headerRowSpacing,
    required this.titleSpacing,
    required this.rowSpacing,
    required this.attendingStackSpacing,
  });

  factory _CardMetrics.of({required bool compact}) {
    return compact
        ? const _CardMetrics(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            dateSpacing: 0,
            sectionSpacing: 16,
            headerSpacing: 16,
            headerRowSpacing: 16,
            titleSpacing: 8,
            rowSpacing: 16,
            attendingStackSpacing: 16,
          )
        : const _CardMetrics(
            padding: EdgeInsets.all(24),
            dateSpacing: 32,
            sectionSpacing: 16,
            headerSpacing: 8,
            headerRowSpacing: 16,
            titleSpacing: 4,
            rowSpacing: 16,
            attendingStackSpacing: 16,
          );
  }
}

/// A filled response pill. A settled answer keeps its place but stops
/// responding, which is how the design greys the chosen option.
class _EventPillButton extends StatelessWidget {
  static const double height = 40;
  static const double radius = 100;

  final LinagoraEventAction action;
  final bool selected;

  const _EventPillButton({required this.action, required this.selected});

  @override
  Widget build(BuildContext context) {
    return LinagoraButton(
      label: action.label,
      onPressed: selected ? null : action.onPressed,
      icon: action.icon,
      iconColor: action.iconColor,
      tooltip: action.tooltip,
      backgroundColor: LinagoraEventInfoColors.link,
      foregroundColor: const Color(0xFFFFFFFF),
      disabledBackgroundColor: LinagoraButton.disabledContainerColor,
      disabledForegroundColor: LinagoraButton.disabledContentColor,
      borderRadius: radius,
      minimumHeight: height,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    );
  }
}

/// A borderless action sized like the pills beside it.
class _EventTextButton extends StatelessWidget {
  final LinagoraEventAction action;

  const _EventTextButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return LinagoraButton(
      label: action.label,
      onPressed: action.onPressed,
      icon: action.icon,
      iconColor: action.iconColor ?? LinagoraEventInfoColors.secondary,
      iconSize: 18,
      iconSpacing: 8,
      tooltip: action.tooltip,
      variant: LinagoraButtonVariant.text,
      foregroundColor: LinagoraEventInfoColors.buttonLabel,
      borderRadius: _EventPillButton.radius,
      minimumHeight: _EventPillButton.height,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    );
  }
}
