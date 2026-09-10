import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// The four rows of the event card, stacked as designed.
@widgetbook.UseCase(name: 'Event card rows', type: LinagoraEventInfoRow)
Widget linagoraEventInfoRowUseCase(BuildContext context) {
  return const _Card(
    child: LinagoraEventInfoRowGroup(
      rows: [_whenRow, _whereRow, _ParticipantsRow(), _attendingRow],
    ),
  );
}

const _whenRow = LinagoraEventInfoRow(
  prefix: LinagoraEventInfoLabel('When'),
  content: LinagoraEventInfoRun(
    children: [
      LinagoraEventInfoText(
        'Tuesday, Jun 16',
        emphasis: LinagoraEventInfoEmphasis.strong,
      ),
      LinagoraEventInfoText('·'),
      LinagoraEventInfoText('12:00 – 12:30'),
      _WarningIcon(),
    ],
  ),
);

const _whereRow = LinagoraEventInfoRow(
  prefix: LinagoraEventInfoLabel('Where'),
  content: LinagoraEventInfoRun(
    children: [
      LinagoraEventInfoText('Villa Good Tech, 37 rue Pierre'),
      LinagoraEventInfoLink(label: 'See in Map', onPressed: _noop),
    ],
  ),
);

const _attendingRow = LinagoraEventInfoRow(
  expand: true,
  stackedAlignment: CrossAxisAlignment.center,
  prefix: LinagoraEventInfoLabel('Attending?'),
  content: LinagoraEventInfoRun(
    alignment: WrapAlignment.center,
    children: [
      _AttendingButton('Yes'),
      _AttendingButton('No'),
      _AttendingButton('Maybe'),
      _TextActionButton('Propose a new time'),
    ],
  ),
  trailing: _TextActionButton(
    'See in your Calendar',
    icon: Icons.calendar_today,
    iconColor: LinagoraEventInfoColors.secondary,
  ),
);

/// A single row with every slot and measurement driven by knobs.
@widgetbook.UseCase(name: 'Playground', type: LinagoraEventInfoRow)
Widget linagoraEventInfoRowPlaygroundUseCase(BuildContext context) {
  final prefix = _PrefixKnobs.fromContext(context);
  final content = _ContentKnobs.fromContext(context);
  final layout = _LayoutKnobs.fromContext(context);

  return _Card(
    child: LinagoraEventInfoRow(
      prefix: prefix.show ? LinagoraEventInfoLabel(prefix.label) : null,
      prefixWidth: prefix.fixedColumn ? prefix.width : null,
      prefixSpacing: prefix.spacing,
      trailingSpacing: layout.trailingSpacing,
      crossAxisAlignment: layout.crossAxisAlignment,
      expand: layout.expand,
      layout: layout.layout,
      content: LinagoraEventInfoRun(
        spacing: content.spacing,
        children: [
          LinagoraEventInfoText(content.value, emphasis: content.emphasis),
          if (content.showInlineLink)
            const LinagoraEventInfoLink(label: 'See in Map', onPressed: _noop),
        ],
      ),
      trailing: layout.showTrailing
          ? const LinagoraEventInfoLink(
              label: 'See in your Calendar',
              onPressed: _noop,
            )
          : null,
    ),
  );
}

class _PrefixKnobs {
  final bool show;
  final String label;
  final bool fixedColumn;
  final double width;
  final double spacing;

  const _PrefixKnobs({
    required this.show,
    required this.label,
    required this.fixedColumn,
    required this.width,
    required this.spacing,
  });

  factory _PrefixKnobs.fromContext(BuildContext context) {
    return _PrefixKnobs(
      show: context.knobs.boolean(label: 'Show prefix', initialValue: true),
      label: context.knobs.string(
        label: 'Prefix label',
        initialValue: 'Where',
      ),
      fixedColumn: context.knobs.boolean(
        label: 'Fixed prefix column',
        initialValue: true,
      ),
      width: context.knobs.double.slider(
        label: 'Prefix width',
        initialValue: LinagoraEventInfoRow.defaultPrefixWidth,
        min: 0,
        max: 160,
      ),
      spacing: context.knobs.double.slider(
        label: 'Prefix spacing',
        initialValue: LinagoraEventInfoRow.defaultPrefixSpacing,
        min: 0,
        max: 64,
      ),
    );
  }
}

class _ContentKnobs {
  final String value;
  final LinagoraEventInfoEmphasis emphasis;
  final bool showInlineLink;
  final double spacing;

  const _ContentKnobs({
    required this.value,
    required this.emphasis,
    required this.showInlineLink,
    required this.spacing,
  });

  factory _ContentKnobs.fromContext(BuildContext context) {
    return _ContentKnobs(
      value: context.knobs.string(
        label: 'Value',
        initialValue: 'Villa Good Tech, 37 rue Pierre',
      ),
      emphasis: context.knobs.object.dropdown<LinagoraEventInfoEmphasis>(
        label: 'Value emphasis',
        options: LinagoraEventInfoEmphasis.values,
        labelBuilder: (value) => value.name,
      ),
      showInlineLink: context.knobs.boolean(
        label: 'Inline link in content',
        initialValue: true,
      ),
      spacing: context.knobs.double.slider(
        label: 'Content run spacing',
        initialValue: LinagoraEventInfoRun.defaultSpacing,
        min: 0,
        max: 32,
      ),
    );
  }
}

class _LayoutKnobs {
  final LinagoraEventInfoRowLayout layout;
  final bool expand;
  final bool showTrailing;
  final double trailingSpacing;
  final CrossAxisAlignment crossAxisAlignment;

  const _LayoutKnobs({
    required this.layout,
    required this.expand,
    required this.showTrailing,
    required this.trailingSpacing,
    required this.crossAxisAlignment,
  });

  factory _LayoutKnobs.fromContext(BuildContext context) {
    return _LayoutKnobs(
      layout: context.knobs.object.dropdown<LinagoraEventInfoRowLayout>(
        label: 'Layout',
        options: LinagoraEventInfoRowLayout.values,
        labelBuilder: (value) => value.name,
      ),
      expand: context.knobs.boolean(label: 'Expand', initialValue: false),
      showTrailing: context.knobs.boolean(
        label: 'Trailing action',
        initialValue: false,
      ),
      trailingSpacing: context.knobs.double.slider(
        label: 'Trailing spacing',
        initialValue: LinagoraEventInfoRow.defaultTrailingSpacing,
        min: 0,
        max: 64,
      ),
      crossAxisAlignment: context.knobs.object
          .dropdown<CrossAxisAlignment>(
            label: 'Cross axis alignment',
            options: const [
              CrossAxisAlignment.center,
              CrossAxisAlignment.start,
              CrossAxisAlignment.end,
            ],
            labelBuilder: (value) => value.name,
          ),
    );
  }
}

/// A `Who` row whose participant list expands and collapses in place.
@widgetbook.UseCase(name: 'Participants toggle', type: LinagoraEventInfoRow)
Widget linagoraEventInfoRowParticipantsUseCase(BuildContext context) {
  return const _Card(child: _ParticipantsRow());
}

class _ParticipantsRow extends StatefulWidget {
  const _ParticipantsRow();

  @override
  State<_ParticipantsRow> createState() => _ParticipantsRowState();
}

class _ParticipantsRowState extends State<_ParticipantsRow> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return LinagoraEventInfoRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      prefix: const LinagoraEventInfoLabel('Who'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: LinagoraEventInfoRun.defaultSpacing,
        children: [
          LinagoraEventInfoRun(
            children: [
              const LinagoraEventInfoText(
                'Alex Martin',
                emphasis: LinagoraEventInfoEmphasis.strong,
              ),
              const LinagoraEventInfoText(
                'alex.martin@example.invalid',
                emphasis: LinagoraEventInfoEmphasis.muted,
              ),
              const LinagoraEventInfoText('- Organizer'),
              if (!_expanded)
                LinagoraEventInfoLink(
                  label: 'See all participants',
                  onPressed: _toggle,
                ),
            ],
          ),
          if (_expanded) ...[
            for (final participant in _participants)
              LinagoraEventInfoRun(
                children: [
                  if (participant.hasName)
                    LinagoraEventInfoText(
                      participant.name!,
                      emphasis: LinagoraEventInfoEmphasis.strong,
                    ),
                  LinagoraEventInfoText(
                    participant.email,
                    emphasis: LinagoraEventInfoEmphasis.muted,
                  ),
                ],
              ),
            LinagoraEventInfoLink(label: 'Hide', onPressed: _toggle),
          ],
        ],
      ),
    );
  }
}

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
  _Participant('lea.fontaine@example.invalid', name: 'Lea Fontaine'),
  _Participant('samir.haddad@example.invalid'),
  _Participant('ingrid.olsen@example.invalid', name: 'Ingrid Olsen'),
  _Participant('chen.wei@example.invalid'),
  _Participant('marta.silva@example.invalid', name: 'Marta Silva'),
  _Participant('ousmane.diallo@example.invalid'),
  _Participant('yuki.tanaka@example.invalid', name: 'Yuki Tanaka'),
];

/// The status glyph beside a time, explained on hover.
class _WarningIcon extends StatelessWidget {
  static const Color color = Color(0xFFFFB300);

  const _WarningIcon();

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      message: 'Conflicts with another event',
      child: Icon(Icons.error, size: 16, color: color),
    );
  }
}

/// The card surface, so the rows are read against the colour they sit on.
class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F6F9),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: child,
      ),
    );
  }
}

/// A filled pill answering the `Attending?` row.
class _AttendingButton extends StatelessWidget {
  final String label;

  const _AttendingButton(this.label);

  @override
  Widget build(BuildContext context) {
    return LinagoraButton(
      label: label,
      onPressed: _noop,
      backgroundColor: LinagoraEventInfoColors.link,
      foregroundColor: const Color(0xFFFFFFFF),
      borderRadius: _pillRadius,
      minimumHeight: _pillHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    );
  }
}

/// A borderless action sized like the pills beside it.
class _TextActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;

  /// The design paints the leading glyph in the secondary ink, not in the
  /// label's blue.
  final Color? iconColor;

  const _TextActionButton(this.label, {this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return LinagoraButton(
      label: label,
      onPressed: _noop,
      icon: icon,
      iconColor: iconColor,
      iconSize: 18,
      iconSpacing: 8,
      variant: LinagoraButtonVariant.text,
      foregroundColor: LinagoraEventInfoColors.buttonLabel,
      borderRadius: _pillRadius,
      minimumHeight: _pillHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    );
  }
}

const double _pillRadius = 100;
const double _pillHeight = 40;

void _noop() {}
