import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraButton)
Widget linagoraButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<LinagoraButtonVariant>(
    label: 'Variant',
    options: LinagoraButtonVariant.values,
    initialOption: LinagoraButtonVariant.filled,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.object.dropdown<LinagoraButtonSize>(
    label: 'Size',
    options: LinagoraButtonSize.values,
    initialOption: LinagoraButtonSize.m,
    labelBuilder: (s) => s.name.toUpperCase(),
  );
  final withIcon = context.knobs.boolean(
    label: 'With leading icon',
    initialValue: true,
  );
  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: LinagoraButton(
      label: context.knobs.string(
        label: 'Label',
        initialValue: 'Click me',
      ),
      icon: withIcon ? Icons.videocam_outlined : null,
      onPressed: () {},
      size: size,
      variant: variant,
    ),
  );
}
