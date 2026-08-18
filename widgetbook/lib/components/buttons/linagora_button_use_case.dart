import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../sidebar/sidebar_preview_surface.dart';
import '../sidebar/sidebar_preview_svg_icon.dart';

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
  final iconSlot = context.knobs.object.dropdown<_LinagoraButtonIconSlot>(
    label: 'Leading icon slot',
    options: _LinagoraButtonIconSlot.values,
    initialOption: _LinagoraButtonIconSlot.material,
    labelBuilder: (slot) => slot.label,
  );
  final layout = context.knobs.object.dropdown<_LinagoraButtonLayout>(
    label: 'Layout',
    options: _LinagoraButtonLayout.values,
    initialOption: _LinagoraButtonLayout.natural,
    labelBuilder: (layout) => layout.label,
  );
  final layoutWidth = !layout.usesLayoutWidth
      ? null
      : context.knobs.double.slider(
          label: 'Layout width',
          initialValue: 220,
          min: 120,
          max: 320,
        );
  final outerPadding = context.knobs.boolean(
    label: 'Add outer padding',
    initialValue: false,
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final button = LinagoraButton(
    label: context.knobs.string(label: 'Label', initialValue: 'Click me'),
    icon: iconSlot.icon,
    iconWidget: iconSlot.iconWidget,
    onPressed: enabled ? _noop : null,
    size: size,
    variant: variant,
    outerPadding:
        outerPadding ? const EdgeInsets.all(LinagoraSpacing.base * 2) : null,
    width: layout.usesFixedWidth ? layoutWidth : null,
    constraints: layout.usesConstraints
        ? BoxConstraints.tightFor(width: layoutWidth)
        : null,
    alignment: layout.alignment,
  );

  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
      child: button,
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

enum _LinagoraButtonIconSlot {
  none('No icon'),
  material('Material icon'),
  svgWidget('SVG widget');

  const _LinagoraButtonIconSlot(this.label);

  final String label;

  IconData? get icon => switch (this) {
        _LinagoraButtonIconSlot.material => Icons.videocam_outlined,
        _ => null,
      };

  Widget? get iconWidget => switch (this) {
        _LinagoraButtonIconSlot.svgWidget => const SidebarPreviewSvgIcon(),
        _ => null,
      };
}

enum _LinagoraButtonLayout {
  natural('Natural'),
  fixedWidth('Fixed width'),
  constrained('Constraints'),
  alignedRight('Fixed width, align right');

  const _LinagoraButtonLayout(this.label);

  final String label;

  bool get usesLayoutWidth => this != _LinagoraButtonLayout.natural;

  bool get usesFixedWidth => switch (this) {
        _LinagoraButtonLayout.fixedWidth ||
        _LinagoraButtonLayout.alignedRight => true,
        _ => false,
      };

  bool get usesConstraints => this == _LinagoraButtonLayout.constrained;

  AlignmentGeometry? get alignment => switch (this) {
        _LinagoraButtonLayout.alignedRight => Alignment.centerRight,
        _ => null,
      };
}

void _noop() {}
