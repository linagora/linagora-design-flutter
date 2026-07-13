import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

double? _heightKnob(BuildContext context) {
  return context.knobs.double.slider(
    label: 'Height',
    initialValue: 40,
    min: 40,
    max: 160,
  );
}

@widgetbook.UseCase(name: 'No action', type: LinagoraBanner)
Widget linagoraBannerNoActionUseCase(BuildContext context) {
  return LinagoraBanner(
    message: context.knobs.string(
      label: 'Message',
      initialValue: 'Some sessions are unverified. Encrypted messages may '
          'not decrypt correctly until all sessions are verified or '
          'removed.',
    ),
    height: _heightKnob(context),
  );
}

/// The action button and the dismiss icon always appear together — this
/// matches the Figma design, where the close icon sits next to Verify.
@widgetbook.UseCase(name: 'Has action', type: LinagoraBanner)
Widget linagoraBannerHasActionUseCase(BuildContext context) {
  return LinagoraBanner(
    message: context.knobs.string(
      label: 'Message',
      initialValue: 'Encrypted messages may be unavailable because some of '
          'your devices are out of sync',
    ),
    actionLabel: context.knobs.string(
      label: 'Action label',
      initialValue: 'Verify',
    ),
    onActionPressed: () {},
    onDismiss: () {},
    height: _heightKnob(context),
  );
}
