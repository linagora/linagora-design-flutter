import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

@widgetbook.UseCase(name: 'Default', type: LinagoraSidebarStorage)
Widget linagoraSidebarStorageUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Storage');
  final progress = context.knobs.double.slider(
    label: 'Used storage',
    initialValue: 0.02,
    min: 0,
    max: 1,
  );
  final state = context.knobs.object.dropdown(
    label: 'Progress state',
    options: LinagoraSidebarStorageProgressState.values,
    initialOption: LinagoraSidebarStorageProgressState.normal,
    labelBuilder: (state) => state.name,
  );
  final caption = context.knobs.string(
    label: 'Caption',
    initialValue: '497.28 GB available',
  );

  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: LinagoraSidebarStorage(
      label: label,
      progress: progress,
      progressState: state,
      caption: caption.isEmpty ? null : caption,
    ),
  );
}
