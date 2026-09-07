import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    _LinagoraButtonPresentation.invitationBar => _invitationBarPreview(context),
  };
}

/// Every action of an event invitation bar, built from this one button to
/// show the colour, shape, and icon properties carrying a full screen's worth
/// of styles without a bespoke widget.
Widget _invitationBarPreview(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final onPressed = enabled ? _noop : null;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InvitationSection(
          title: 'Attending?',
          children: [
            for (final answer in ['Yes', 'No', 'Maybe'])
              _invitationFilledButton(label: answer, onPressed: onPressed),
            _invitationTextButton(
              label: 'Propose a new time',
              onPressed: onPressed,
            ),
          ],
        ),
        _InvitationSection(
          title: 'With a leading icon',
          children: [
            _invitationTextButton(
              label: 'See in your Calendar',
              onPressed: onPressed,
              iconWidget: const _CalendarIcon(),
            ),
            _invitationTextButton(
              label: 'Mail to attendees',
              onPressed: onPressed,
              icon: Icons.mail_outline,
            ),
          ],
        ),
        _InvitationSection(
          title: 'Inline links',
          spacing: LinagoraSpacing.base * 3,
          children: [
            for (final link in [
              'More information',
              'See in Map',
              'See all participants',
            ])
              _invitationLink(label: link, onPressed: onPressed),
          ],
        ),
      ],
    ),
  );
}

LinagoraButton _invitationFilledButton({
  required String label,
  required VoidCallback? onPressed,
}) {
  return LinagoraButton(
    label: label,
    onPressed: onPressed,
    minimumHeight: LinagoraButton.mediumHeight,
    padding: LinagoraButton.mediumPadding,
    iconSpacing: 10,
    backgroundColor: _invitationPrimary,
    foregroundColor: _invitationOnPrimary,
    hoverBackgroundColor: LinagoraButton.primaryHoverBackgroundColor,
    disabledBackgroundColor: LinagoraButton.disabledContainerColor,
    disabledForegroundColor: LinagoraButton.disabledContentColor,
  );
}

LinagoraButton _invitationTextButton({
  required String label,
  required VoidCallback? onPressed,
  IconData? icon,
  Widget? iconWidget,
}) {
  return LinagoraButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    iconWidget: iconWidget,
    variant: LinagoraButtonVariant.text,
    minimumHeight: LinagoraButton.mediumHeight,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    iconSpacing: 8,
    iconSize: 18,
    iconColor: _invitationIconColor,
    foregroundColor: _invitationTextColor,
    hoverOverlayColor: LinagoraButton.primaryHoverOverlayColor,
    disabledForegroundColor: LinagoraButton.disabledContentColor,
  );
}

/// An inline link is the text variant with its padding and minimum height
/// taken away, so it sits in a run of text instead of beside other buttons.
LinagoraButton _invitationLink({
  required String label,
  required VoidCallback? onPressed,
}) {
  return LinagoraButton(
    label: label,
    onPressed: onPressed,
    variant: LinagoraButtonVariant.text,
    padding: EdgeInsets.zero,
    minimumHeight: 0,
    foregroundColor: _invitationPrimary,
    hoverOverlayColor: LinagoraButton.primaryHoverOverlayColor,
    disabledForegroundColor: LinagoraButton.disabledContentColor,
  );
}

const _invitationPrimary = Color(0xFF0A84FF);
const _invitationOnPrimary = Color(0xFFFFFFFF);
const _invitationTextColor = Color(0xFF0C8CE9);
const _invitationIconColor = Color(0xA3424244);

class _InvitationSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double spacing;

  const _InvitationSection({
    required this.title,
    required this.children,
    this.spacing = LinagoraSpacing.base,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LinagoraSpacing.base * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: LinagoraSpacing.base),
          // Wraps rather than a Row so the actions reflow instead of
          // overflowing on a phone-width viewport.
          Wrap(
            spacing: spacing,
            runSpacing: LinagoraSpacing.base,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }
}

class _CalendarIcon extends StatelessWidget {
  const _CalendarIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      LinagoraDesignImages.calendarTodayIcon,
      package: LinagoraDesignImages.packageName,
    );
  }
}

Widget _standardButtonPreview(BuildContext context) {
  final content = _contentKnobs(context);
  final shape = _shapeKnobs(context);
  final colours = _colourKnobs(context);
  final icon = _iconKnobs(context);
  final sizing = _sizingKnobs(context);
  final layout = _layoutKnobs(context);

  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
      child: LinagoraButton(
        label: content.label,
        onPressed: content.enabled ? _noop : null,
        variant: shape.variant,
        size: shape.size,
        borderRadius: shape.borderRadius,
        backgroundColor: colours.background,
        foregroundColor: colours.foreground,
        icon: icon.slot.icon,
        iconWidget: icon.slot.iconWidget,
        iconSize: icon.size,
        iconColor: icon.colour,
        height: sizing.height,
        minimumHeight: sizing.minimumHeight,
        width: layout.width,
        constraints: layout.constraints,
        alignment: layout.alignment,
        outerPadding: layout.outerPadding,
      ),
    ),
  );
}

typedef _ContentKnobs = ({String label, bool enabled});

_ContentKnobs _contentKnobs(BuildContext context) {
  return (
    label: context.knobs.string(label: 'Label', initialValue: 'Click me'),
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
  );
}

typedef _ShapeKnobs = ({
  LinagoraButtonVariant variant,
  LinagoraButtonSize size,
  double? borderRadius,
});

_ShapeKnobs _shapeKnobs(BuildContext context) {
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
  // Null keeps the fully rounded stadium, so the slider only appears once a
  // radius is actually wanted.
  final rounds = context.knobs.boolean(
    label: 'Override corner radius',
    initialValue: false,
  );
  return (
    variant: variant,
    size: size,
    borderRadius: rounds
        ? context.knobs.double.slider(
            label: 'Corner radius',
            initialValue: 8,
            min: 0,
            max: 40,
          )
        : null,
  );
}

typedef _ColourKnobs = ({Color? background, Color? foreground});

/// Both stay null unless switched on, which is what leaves the ambient button
/// theme in charge.
_ColourKnobs _colourKnobs(BuildContext context) {
  final overridesBackground = context.knobs.boolean(
    label: 'Override background',
    initialValue: false,
  );
  final background = overridesBackground
      ? context.knobs.color(
          label: 'Background colour',
          initialValue: const Color(0xFF0A84FF),
        )
      : null;
  final overridesLabel = context.knobs.boolean(
    label: 'Override label colour',
    initialValue: false,
  );
  return (
    background: background,
    foreground: overridesLabel
        ? context.knobs.color(
            label: 'Label colour',
            initialValue: const Color(0xFFFFFFFF),
          )
        : null,
  );
}

typedef _IconKnobs = ({
  _LinagoraButtonIconSlot slot,
  double? size,
  Color? colour,
});

/// Size and colour are meaningless without an icon, so they only join the
/// panel once a slot is filled.
_IconKnobs _iconKnobs(BuildContext context) {
  final slot = context.knobs.object.dropdown<_LinagoraButtonIconSlot>(
    label: 'Leading icon',
    options: _LinagoraButtonIconSlot.values,
    initialOption: _LinagoraButtonIconSlot.material,
    labelBuilder: (slot) => slot.label,
  );
  if (slot == _LinagoraButtonIconSlot.none) {
    return (slot: slot, size: null, colour: null);
  }
  final size = context.knobs.double.slider(
    label: 'Icon size',
    initialValue: LinagoraButton.defaultIconSize,
    min: 12,
    max: 40,
  );
  final tints = context.knobs.boolean(
    label: 'Override icon colour',
    initialValue: false,
  );
  return (
    slot: slot,
    size: size,
    colour: tints
        ? context.knobs.color(
            label: 'Icon colour',
            initialValue: const Color(0xA3424244),
          )
        : null,
  );
}

typedef _SizingKnobs = ({double? height, double? minimumHeight});

/// A minimum still grows for taller content; a fixed height pins the box.
_SizingKnobs _sizingKnobs(BuildContext context) {
  final mode = context.knobs.object.dropdown<_HeightMode>(
    label: 'Height',
    options: _HeightMode.values,
    initialOption: _HeightMode.fromSize,
    labelBuilder: (mode) => mode.label,
  );
  if (mode == _HeightMode.fromSize) {
    return (height: null, minimumHeight: null);
  }
  final value = context.knobs.double.slider(
    label: 'Height value',
    initialValue: LinagoraButton.mediumHeight,
    min: 24,
    max: 72,
  );
  return (
    height: mode == _HeightMode.fixed ? value : null,
    minimumHeight: mode == _HeightMode.minimum ? value : null,
  );
}

typedef _LayoutKnobs = ({
  double? width,
  BoxConstraints? constraints,
  AlignmentGeometry? alignment,
  EdgeInsetsGeometry? outerPadding,
});

_LayoutKnobs _layoutKnobs(BuildContext context) {
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
  return (
    width: layout.usesFixedWidth ? layoutWidth : null,
    constraints: layout.usesConstraints
        ? BoxConstraints.tightFor(width: layoutWidth)
        : null,
    alignment: layout.alignment,
    outerPadding: outerPadding
        ? const EdgeInsets.all(LinagoraSpacing.base * 2)
        : null,
  );
}

enum _HeightMode {
  fromSize('From size'),
  minimum('Minimum'),
  fixed('Fixed');

  const _HeightMode(this.label);

  final String label;
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
  sidebarPrimaryAction('Sidebar primary action'),
  invitationBar('Event invitation bar');

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
