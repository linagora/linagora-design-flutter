import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraDismissibleChip)
Widget linagoraDismissibleChipUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Viewing Nora Hale',
  );
  final showLeading = context.knobs.boolean(
    label: 'Leading',
    initialValue: true,
  );

  final isDark = Theme.of(context).brightness == Brightness.dark;

  return ColoredBox(
    color: isDark ? const Color(0xFF3F4249) : Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: LinagoraDismissibleChip(
          style: isDark
              ? LinagoraDismissibleChipStyle.dark()
              : LinagoraDismissibleChipStyle.material(),
          label: label,
          dismissTooltip: 'Back to my mailbox',
          onDismissed: () {},
          leading: showLeading
              ? RoundAvatar(text: 'NH', size: 16, textStyle: _initialsStyle(16))
              : null,
        ),
      ),
    ),
  );
}

/// Initials scaled to the avatar so they stay inside the circle.
TextStyle _initialsStyle(double size) => TextStyle(
      color: Colors.white,
      fontSize: size * 0.44,
      fontWeight: FontWeight.w600,
    );
