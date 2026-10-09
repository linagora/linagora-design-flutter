import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraSectionHeader)
Widget linagoraSectionHeaderUseCase(BuildContext context) {
  return LinagoraSectionHeader(
    label: context.knobs.string(label: 'Label', initialValue: 'Results'),
    actionLabel: context.knobs.stringOrNull(
      label: 'Action label',
      initialValue: 'Show more',
    ),
    onActionTap: () {},
  );
}
