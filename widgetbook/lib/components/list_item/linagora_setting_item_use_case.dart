import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _longDescription =
    'Protects your messages from being read by others and prevents them '
    'from being stored on our servers. This choice is permanent: you won’t '
    'be able to disable this feature later.';

@widgetbook.UseCase(name: 'Default', type: LinagoraSettingItem)
Widget linagoraSettingItemUseCase(BuildContext context) {
  final loading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: LinagoraSettingItem(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Notifications',
      ),
      subtitle: context.knobs.stringOrNull(
        label: 'Subtitle',
        initialValue: 'Manage how you receive notifications',
      ),
      subtitleMaxLines: _subtitleMaxLinesKnob(context),
      count: context.knobs.intOrNull.input(label: 'Count'),
      leadingIcon: Icons.notifications_outlined,
      padding: _paddingKnob(context),
      loading: loading,
      enabled: context.knobs.boolean(
        label: 'Enabled',
        initialValue: true,
      ),
      showDivider: context.knobs.boolean(
        label: 'Show divider',
        initialValue: true,
      ),
      onTap: loading ? null : () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Selectable', type: LinagoraSettingItem)
Widget linagoraSettingItemSelectableUseCase(BuildContext context) {
  final control = context.knobs.object.dropdown(
    label: 'Control',
    options: LinagoraSettingItemControl.values,
    initialOption: LinagoraSettingItemControl.toggle,
    labelBuilder: (control) => control.name,
  );

  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: _SelectableSettingItemDemo(
      control: control,
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Name',
      ),
      subtitle: context.knobs.stringOrNull(
        label: 'Subtitle',
        initialValue: control == LinagoraSettingItemControl.checkbox
            ? _longDescription
            : 'Setting description with a long text maximum two lines',
      ),
      subtitleMaxLines: _subtitleMaxLinesKnob(
        context,
        unlimited: control == LinagoraSettingItemControl.checkbox,
      ),
      count: context.knobs.intOrNull.input(label: 'Count', initialValue: 1),
      enabled: context.knobs.boolean(
        label: 'Enabled',
        initialValue: true,
      ),
      showDivider: context.knobs.boolean(
        label: 'Show divider',
        initialValue: true,
      ),
    ),
  );
}

int? _subtitleMaxLinesKnob(BuildContext context, {bool unlimited = false}) {
  return context.knobs.boolean(
    label: 'Unlimited subtitle lines',
    initialValue: unlimited,
  )
      ? null
      : 2;
}

EdgeInsets? _paddingKnob(BuildContext context) {
  return context.knobs.boolean(
    label: 'Inset padding (Title+Desc2)',
    initialValue: false,
  )
      ? LinagoraSettingItem.insetPadding
      : null;
}

class _SelectableSettingItemDemo extends StatefulWidget {
  final LinagoraSettingItemControl control;
  final String title;
  final String? subtitle;
  final int? subtitleMaxLines;
  final int? count;
  final bool enabled;
  final bool showDivider;

  const _SelectableSettingItemDemo({
    required this.control,
    required this.title,
    required this.subtitle,
    required this.subtitleMaxLines,
    required this.count,
    required this.enabled,
    required this.showDivider,
  });

  @override
  State<_SelectableSettingItemDemo> createState() =>
      _SelectableSettingItemDemoState();
}

class _SelectableSettingItemDemoState
    extends State<_SelectableSettingItemDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return LinagoraSettingItem.selectable(
      control: widget.control,
      title: widget.title,
      subtitle: widget.subtitle,
      subtitleMaxLines: widget.subtitleMaxLines,
      count: widget.count,
      leadingIcon: Icons.chat_bubble_outline,
      value: _value,
      onChanged: (value) => setState(() => _value = value),
      enabled: widget.enabled,
      showDivider: widget.showDivider,
    );
  }
}
