import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Group', type: LinagoraCheckboxItem)
Widget linagoraCheckboxItemUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: _CheckboxGroupDemo(
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
      showDivider: context.knobs.boolean(
        label: 'Show divider',
        initialValue: true,
      ),
      showSubtitle: context.knobs.boolean(
        label: 'Show subtitle',
        initialValue: false,
      ),
      showLeading: context.knobs.boolean(
        label: 'Show leading',
        initialValue: false,
      ),
    ),
  );
}

class _CheckboxGroupDemo extends StatefulWidget {
  final bool enabled;
  final bool showDivider;
  final bool showSubtitle;
  final bool showLeading;

  const _CheckboxGroupDemo({
    required this.enabled,
    required this.showDivider,
    required this.showSubtitle,
    required this.showLeading,
  });

  @override
  State<_CheckboxGroupDemo> createState() => _CheckboxGroupDemoState();
}

class _CheckboxGroupDemoState extends State<_CheckboxGroupDemo> {
  static const _options = ['Unread', 'Direct messages', 'Groups'];

  final _checked = <String>{'Unread'};

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in _options)
          LinagoraCheckboxItem(
            title: option,
            subtitle: widget.showSubtitle ? 'Description' : null,
            leading: widget.showLeading
                ? CircleAvatar(radius: 20, child: Text(option[0]))
                : null,
            value: _checked.contains(option),
            enabled: widget.enabled,
            showDivider: widget.showDivider,
            onChanged: (value) => setState(
              () => value ? _checked.add(option) : _checked.remove(option),
            ),
          ),
      ],
    );
  }
}
