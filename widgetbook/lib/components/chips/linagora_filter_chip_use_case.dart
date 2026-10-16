import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Group', type: LinagoraFilterChip)
Widget linagoraFilterChipUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: _FilterGroupDemo(
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    ),
  );
}

class _FilterGroupDemo extends StatefulWidget {
  final bool enabled;

  const _FilterGroupDemo({required this.enabled});

  @override
  State<_FilterGroupDemo> createState() => _FilterGroupDemoState();
}

class _FilterGroupDemoState extends State<_FilterGroupDemo> {
  static const _filters = ['Internal', 'External'];

  final Set<String> _selected = {_filters.first};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: LinagoraSpacing.base,
      children: [
        for (final filter in _filters)
          LinagoraFilterChip(
            label: filter,
            selected: _selected.contains(filter),
            onSelected: widget.enabled
                ? (selected) => setState(
                      () => selected
                          ? _selected.add(filter)
                          : _selected.remove(filter),
                    )
                : null,
          ),
      ],
    );
  }
}
