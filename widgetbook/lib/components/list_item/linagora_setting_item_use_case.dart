import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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
      subtitle: context.knobs.string(
        label: 'Subtitle',
        initialValue: 'Manage how you receive notifications',
      ),
      leadingIcon: Icons.notifications_outlined,
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
