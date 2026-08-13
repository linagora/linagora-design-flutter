import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../sidebar/sidebar_preview_surface.dart';

@widgetbook.UseCase(name: 'Default', type: LinagoraButton)
Widget linagoraButtonUseCase(BuildContext context) {
  final presentation = context.knobs.object
      .dropdown<_LinagoraButtonPresentation>(
        label: 'Presentation',
        options: _LinagoraButtonPresentation.values,
        initialOption: _LinagoraButtonPresentation.standard,
        labelBuilder: (presentation) => presentation.label,
      );

  return switch (presentation) {
    _LinagoraButtonPresentation.standard => _standardButtonPreview(context),
    _LinagoraButtonPresentation.sidebarPrimaryAction =>
      _sidebarPrimaryActionPreview(context),
  };
}

Widget _standardButtonPreview(BuildContext context) {
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

Widget _sidebarPrimaryActionPreview(BuildContext context) {
  final showLeadingIcon = context.knobs.boolean(
    label: 'Show leading icon',
    initialValue: true,
  );
  final icon = showLeadingIcon
      ? context.knobs.object
            .dropdown<_SidebarPrimaryActionIcon>(
              label: 'Leading icon',
              options: _SidebarPrimaryActionIcon.values,
              initialOption: _SidebarPrimaryActionIcon.compose,
              labelBuilder: (icon) => icon.label,
            )
            .icon
      : null;

  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: SizedBox(
      width: double.infinity,
      child: LinagoraButton(
        label: context.knobs.string(label: 'Label', initialValue: 'Compose'),
        icon: icon,
        iconSpacing: LinagoraSidebarButtonStyles.primaryActionIconSpacing,
        onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
            ? () {}
            : null,
        style: LinagoraSidebarButtonStyles.primaryAction(context),
      ),
    ),
  );
}

enum _LinagoraButtonPresentation {
  standard('Standard'),
  sidebarPrimaryAction('Sidebar primary action');

  const _LinagoraButtonPresentation(this.label);

  final String label;
}

enum _SidebarPrimaryActionIcon {
  compose('Compose', Icons.edit_outlined),
  create('Create', Icons.add_outlined),
  newItem('New item', Icons.add_circle_outline);

  const _SidebarPrimaryActionIcon(this.label, this.icon);

  final String label;
  final IconData icon;
}
