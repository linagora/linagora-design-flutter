import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraSegmentedTabs)
Widget linagoraSegmentedTabsUseCase(BuildContext context) {
  final first = context.knobs.string(
    label: 'First label',
    initialValue: 'By me',
  );
  final second = context.knobs.string(
    label: 'Second label',
    initialValue: 'With me',
  );
  final expanded = context.knobs.boolean(label: 'Expanded');
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final style = isDark
      ? LinagoraSegmentedTabsStyle.dark()
      : LinagoraSegmentedTabsStyle.material();

  // Page surface behind the track so the selected thumb (`#3E424A` dark /
  // white light) reads against a contrasting canvas, as in the design.
  return ColoredBox(
    color: isDark
        ? LinagoraSysColors.material().surfaceDark
        : LinagoraSysColors.material().onPrimary,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: _InteractiveTabs(
        first: first,
        second: second,
        expanded: expanded,
        style: style,
      ),
    ),
  );
}

class _InteractiveTabs extends StatefulWidget {
  final String first;
  final String second;
  final bool expanded;
  final LinagoraSegmentedTabsStyle style;

  const _InteractiveTabs({
    required this.first,
    required this.second,
    required this.expanded,
    required this.style,
  });

  @override
  State<_InteractiveTabs> createState() => _InteractiveTabsState();
}

class _InteractiveTabsState extends State<_InteractiveTabs> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) => Align(
        alignment: AlignmentDirectional.topStart,
        child: LinagoraSegmentedTabs<int>(
          segments: [
            LinagoraSegment(value: 0, label: widget.first),
            LinagoraSegment(value: 1, label: widget.second),
          ],
          selected: _selected,
          expanded: widget.expanded,
          style: widget.style,
          onChanged: (value) => setState(() => _selected = value),
        ),
      );
}
