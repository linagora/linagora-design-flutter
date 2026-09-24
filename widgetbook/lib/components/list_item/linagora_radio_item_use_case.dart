import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Group', type: LinagoraRadioItem)
Widget linagoraRadioItemUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: _RadioGroupDemo(
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
      showDivider: context.knobs.boolean(
        label: 'Show divider',
        initialValue: true,
      ),
    ),
  );
}

class _RadioGroupDemo extends StatefulWidget {
  final bool enabled;
  final bool showDivider;

  const _RadioGroupDemo({required this.enabled, required this.showDivider});

  @override
  State<_RadioGroupDemo> createState() => _RadioGroupDemoState();
}

class _RadioGroupDemoState extends State<_RadioGroupDemo> {
  static const _options = ['Public', 'Private', 'Invite only'];

  String _selected = _options.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in _options)
          LinagoraRadioItem(
            title: option,
            selected: option == _selected,
            enabled: widget.enabled,
            showDivider: widget.showDivider,
            onTap: () => setState(() => _selected = option),
          ),
      ],
    );
  }
}
