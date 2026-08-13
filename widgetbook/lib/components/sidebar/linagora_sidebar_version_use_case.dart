import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

@widgetbook.UseCase(name: 'Default', type: LinagoraSidebarVersion)
Widget linagoraSidebarVersionUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'version 0.13.2',
  );

  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: LinagoraSidebarVersion(text: text),
  );
}
