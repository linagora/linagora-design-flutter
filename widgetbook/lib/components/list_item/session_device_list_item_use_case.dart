import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Verified', type: SessionDeviceListItem)
Widget sessionDeviceListItemVerifiedUseCase(BuildContext context) {
  return SessionDeviceListItem(
    deviceName: context.knobs.string(
      label: 'Device name',
      initialValue: 'Chat.linagora.com Chrome on Web',
    ),
    lastActiveText: context.knobs.string(
      label: 'Last active',
      initialValue: 'Last active: 17:41',
    ),
    verified: true,
    showDivider:
        context.knobs.boolean(label: 'Show divider', initialValue: true),
    onDelete: () {},
  );
}

/// The Verify button and delete icon always appear together — this matches
/// the Figma design, where the trailing controls sit next to each other.
@widgetbook.UseCase(name: 'Unverified', type: SessionDeviceListItem)
Widget sessionDeviceListItemUnverifiedUseCase(BuildContext context) {
  return SessionDeviceListItem(
    deviceName: context.knobs.string(
      label: 'Device name',
      initialValue: 'Chat.linagora.com Chrome on Web',
    ),
    lastActiveText: context.knobs.string(
      label: 'Last active',
      initialValue: 'Last active: 17:41',
    ),
    verified: false,
    unverifiedLabel: context.knobs.string(
      label: 'Unverified label',
      initialValue: 'Unverified',
    ),
    verifyLabel: context.knobs.string(
      label: 'Verify label',
      initialValue: 'Verify',
    ),
    onVerifyPressed: () {},
    showDivider:
        context.knobs.boolean(label: 'Show divider', initialValue: true),
    onDelete: () {},
  );
}
