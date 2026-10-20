import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraDialog)
Widget linagoraDialogUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Your email domain is pending activation',
  );
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'You cannot send emails at this time. Contact your '
        'administrator if the problem persists.',
  );
  final showBack = context.knobs.boolean(label: 'Back button');
  final showClose =
      context.knobs.boolean(label: 'Close button', initialValue: true);
  final showSecondary = context.knobs.boolean(label: 'Secondary action');
  final destructive = context.knobs.boolean(label: 'Destructive primary');
  final fixedActions = context.knobs.boolean(label: 'Fixed actions');

  return ColoredBox(
    color: LinagoraDialogStyle.barrierColor,
    child: LinagoraDialog(
      title: title,
      message: message,
      onBack: showBack ? () {} : null,
      backTooltip: 'Back',
      onClose: showClose ? () {} : null,
      closeTooltip: 'Close',
      fixedActions: fixedActions,
      secondaryAction: showSecondary
          ? LinagoraDialogAction(label: 'Cancel', onPressed: () {})
          : null,
      primaryAction: LinagoraDialogAction(
        label: destructive ? 'Remove access' : 'Got it',
        onPressed: () {},
        destructive: destructive,
      ),
    ),
  );
}
