import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraFileTransferDialog)
Widget linagoraFileTransferDialogUseCase(BuildContext context) {
  final layout = context.knobs.object.dropdown<LinagoraFileTransferLayout>(
    label: 'Layout',
    options: LinagoraFileTransferLayout.values,
    initialOption: LinagoraFileTransferLayout.wide,
    labelBuilder: (value) => value.name,
  );
  final count = context.knobs.int.slider(
    label: 'Files',
    initialValue: 1,
    min: 0,
    max: 8,
  );
  final progress = context.knobs.double.slider(
    label: 'Progress',
    initialValue: 0.75,
    max: 1,
  );
  final indeterminate = context.knobs.boolean(label: 'Indeterminate');
  final settled = context.knobs.boolean(label: 'Settled (no cancel buttons)');
  final style = LinagoraFileTransferStyle.forLayout(layout);

  return LinagoraFileTransferSurface(
    layout: layout,
    child: LinagoraFileTransferDialog(
      layout: layout,
      title: 'Attaching file',
      description: TextSpan(
        children: [
          const TextSpan(text: 'Your file is larger than 10 MB. It will be '
              'uploaded in your Drive and added as '),
          TextSpan(text: 'link', style: style.emphasisTextStyle),
          const TextSpan(text: ' in your email.'),
        ],
      ),
      itemCount: count,
      itemBuilder: (_, index) => LinagoraFileTransferRow(
        layout: layout,
        fileName: 'Screenshot 2025-01-27 at 16.11.26 #$index.png',
        statusLabel: settled ? 'Done' : '332M',
        progress: settled ? 1 : (indeterminate ? null : progress),
        onCancel: settled ? null : () {},
      ),
      cancelLabel: 'Cancel',
      onClose: () {},
      onCancelAll: () {},
      showCancelAll: !settled,
    ),
  );
}
