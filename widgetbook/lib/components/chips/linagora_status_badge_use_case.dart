import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraStatusBadge)
Widget linagoraStatusBadgeUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Delegated mailbox',
  );
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return ColoredBox(
    color: isDark ? const Color(0xFF3F4249) : Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: LinagoraStatusBadge(
          label: label,
          style: isDark
              ? LinagoraStatusBadgeStyle.dark()
              : LinagoraStatusBadgeStyle.material(),
        ),
      ),
    ),
  );
}
