import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Every property of the alert exposed as a knob, so any variant of it can
/// be reproduced from this one preview.
@widgetbook.UseCase(name: 'Default', type: LinagoraAlert)
Widget linagoraAlertUseCase(BuildContext context) {
  final content = _contentKnobs(context);
  final style = _styleKnobs(context);
  final layout = _layoutKnobs(context);
  final actions = _actionKnobs(context);
  final colours = _colourKnobs(context);

  return _AlertSurface(
    width: layout.surfaceWidth,
    child: LinagoraAlert(
      message: content.message,
      title: content.title,
      color: style.color,
      variant: style.variant,
      size: style.size,
      actionsAlignment: layout.actionsAlignment,
      textAlignment: layout.textAlignment,
      titleVariant: style.titleVariant,
      messageVariant: style.messageVariant,
      showIcon: content.showIcon,
      showPointer: style.showPointer,
      icon: content.icon,
      action: actions.action,
      secondaryAction: actions.secondaryAction,
      onClose: actions.onClose,
      accentColor: colours.accent,
      backgroundColor: colours.background,
      foregroundColor: colours.foreground,
      titleMaxLines: content.titleMaxLines,
      messageMaxLines: content.messageMaxLines,
      liveRegion: content.liveRegion,
      actionMaxWidth: actions.actionMaxWidth,
      actionsMaxWidthFraction: actions.actionsMaxWidthFraction,
    ),
  );
}

typedef _ContentKnobs = ({
  String message,
  String? title,
  bool showIcon,
  IconData? icon,
  int? titleMaxLines,
  int? messageMaxLines,
  bool liveRegion,
});

_ContentKnobs _contentKnobs(BuildContext context) {
  final hasTitle = context.knobs.boolean(label: 'Title', initialValue: true);
  final showIcon = context.knobs.boolean(label: 'Icon', initialValue: true);
  // Null keeps the severity's own glyph, so the picker only appears once an
  // override is actually wanted.
  final overridesIcon = showIcon &&
      context.knobs.boolean(label: 'Override icon', initialValue: false);

  return (
    message: context.knobs.string(
      label: 'Message',
      initialValue: 'This message contains a suspicious link. Don’t '
          'click it, reply, or share personal information.',
    ),
    title: hasTitle
        ? context.knobs.string(
            label: 'Title text',
            initialValue: 'This message may be dangerous',
          )
        : null,
    showIcon: showIcon,
    icon: overridesIcon
        ? context.knobs.object
            .dropdown<_AlertIcon>(
              label: 'Icon glyph',
              options: _AlertIcon.values,
              initialOption: _AlertIcon.shield,
              labelBuilder: (icon) => icon.label,
            )
            .icon
        : null,
    titleMaxLines: _maxLinesKnob(context, label: 'Title max lines'),
    messageMaxLines: _maxLinesKnob(context, label: 'Message max lines'),
    liveRegion: context.knobs.boolean(
      label: 'Live region',
      initialValue: true,
    ),
  );
}

typedef _StyleKnobs = ({
  LinagoraAlertColor color,
  LinagoraAlertVariant variant,
  LinagoraAlertSize size,
  bool showPointer,
  LinagoraTypographyVariant titleVariant,
  LinagoraTypographyVariant messageVariant,
});

_StyleKnobs _styleKnobs(BuildContext context) {
  return (
    color: _colorKnob(context),
    variant: context.knobs.object.dropdown<LinagoraAlertVariant>(
      label: 'Variant',
      options: LinagoraAlertVariant.values,
      initialOption: LinagoraAlertVariant.filled,
      labelBuilder: (variant) => variant.name,
    ),
    size: _sizeKnob(context),
    showPointer: context.knobs.boolean(label: 'Arrow', initialValue: false),
    titleVariant: _typographyKnob(
      context,
      label: 'Title typography',
      initialOption: LinagoraTypographyVariant.h5,
    ),
    messageVariant: _typographyKnob(
      context,
      label: 'Message typography',
      initialOption: LinagoraTypographyVariant.body2,
    ),
  );
}

/// Both text slots are instances of the same shared scale, so each gets the
/// full list of entries rather than a hard-wired style.
LinagoraTypographyVariant _typographyKnob(
  BuildContext context, {
  required String label,
  required LinagoraTypographyVariant initialOption,
}) {
  return context.knobs.object.dropdown<LinagoraTypographyVariant>(
    label: label,
    options: LinagoraTypographyVariant.values,
    initialOption: initialOption,
    labelBuilder: (variant) => variant.name,
  );
}

typedef _LayoutKnobs = ({
  LinagoraAlertActionsAlignment actionsAlignment,
  LinagoraAlertTextAlignment textAlignment,
  double surfaceWidth,
});

_LayoutKnobs _layoutKnobs(BuildContext context) {
  return (
    actionsAlignment:
        context.knobs.object.dropdown<LinagoraAlertActionsAlignment>(
      label: 'Actions alignment',
      options: LinagoraAlertActionsAlignment.values,
      initialOption: LinagoraAlertActionsAlignment.center,
      labelBuilder: (alignment) => alignment.name,
    ),
    textAlignment: context.knobs.object.dropdown<LinagoraAlertTextAlignment>(
      label: 'Text alignment',
      options: LinagoraAlertTextAlignment.values,
      initialOption: LinagoraAlertTextAlignment.start,
      labelBuilder: (alignment) => alignment.name,
    ),
    surfaceWidth: _surfaceWidthKnob(context),
  );
}

typedef _ActionKnobs = ({
  LinagoraAlertAction? action,
  LinagoraAlertAction? secondaryAction,
  VoidCallback? onClose,
  double actionMaxWidth,
  double actionsMaxWidthFraction,
});

_ActionKnobs _actionKnobs(BuildContext context) {
  final hasAction = context.knobs.boolean(label: 'Action', initialValue: true);
  final hasActionIcon = hasAction &&
      context.knobs.boolean(label: 'Action icon', initialValue: false);
  final hasSecondary = context.knobs.boolean(
    label: 'Secondary action',
    initialValue: false,
  );
  final hasClose = context.knobs.boolean(label: 'Close', initialValue: false);
  final action = hasAction
      ? LinagoraAlertAction(
          label: context.knobs.string(
            label: 'Action label',
            initialValue: 'Not spam',
          ),
          onPressed: _noop,
          icon: hasActionIcon ? Icons.shield_outlined : null,
        )
      : null;
  final secondaryAction = hasSecondary
      ? LinagoraAlertAction(
          label: context.knobs.string(
            label: 'Secondary action label',
            initialValue: 'Report phishing',
          ),
          onPressed: _noop,
        )
      : null;

  return (
    action: action,
    secondaryAction: secondaryAction,
    onClose: hasClose ? _noop : null,
    actionMaxWidth: context.knobs.double.slider(
      label: 'Action max width',
      initialValue: 160,
      min: 60,
      max: 320,
    ),
    actionsMaxWidthFraction: context.knobs.double.slider(
      label: 'Actions max width share',
      initialValue: 0.5,
      min: 0.2,
      max: 1,
    ),
  );
}

typedef _ColourKnobs = ({Color? accent, Color? background, Color? foreground});

/// Each stays null unless switched on, which is what leaves the severity's
/// own palette in charge.
_ColourKnobs _colourKnobs(BuildContext context) {
  final overridesAccent = context.knobs.boolean(
    label: 'Override accent',
    initialValue: false,
  );
  final accent = overridesAccent
      ? context.knobs.color(
          label: 'Accent colour',
          initialValue: const Color(0xFFFF3347),
        )
      : null;
  final overridesBackground = context.knobs.boolean(
    label: 'Override background',
    initialValue: false,
  );
  final background = overridesBackground
      ? context.knobs.color(
          label: 'Background colour',
          initialValue: const Color(0x1FFF3347),
        )
      : null;
  final overridesForeground = context.knobs.boolean(
    label: 'Override text colour',
    initialValue: false,
  );
  return (
    accent: accent,
    background: background,
    foreground: overridesForeground
        ? context.knobs.color(
            label: 'Text colour',
            initialValue: const Color(0xE6424244),
          )
        : null,
  );
}

LinagoraAlertColor _colorKnob(BuildContext context) {
  return context.knobs.object.dropdown<LinagoraAlertColor>(
    label: 'Colour',
    options: LinagoraAlertColor.values,
    initialOption: LinagoraAlertColor.error,
    labelBuilder: (color) => color.name,
  );
}

LinagoraAlertSize _sizeKnob(BuildContext context) {
  return context.knobs.object.dropdown<LinagoraAlertSize>(
    label: 'Size',
    options: LinagoraAlertSize.values,
    initialOption: LinagoraAlertSize.normal,
    labelBuilder: (size) => size.name,
  );
}

/// The alert fills the width it is given, so the surface width is what drives
/// wrapping and the action cap in every preview.
double _surfaceWidthKnob(BuildContext context) {
  return context.knobs.double.slider(
    label: 'Surface width',
    initialValue: 640,
    min: 280,
    max: 1141,
  );
}

int? _maxLinesKnob(BuildContext context, {required String label}) {
  final caps = context.knobs.boolean(label: label, initialValue: false);
  if (!caps) return null;
  return context.knobs.int
      .slider(label: '$label value', initialValue: 1, min: 1, max: 4);
}

class _AlertSurface extends StatelessWidget {
  final double width;
  final Widget child;

  const _AlertSurface({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(width: width, child: child),
      ),
    );
  }
}

enum _AlertIcon {
  shield('Shield', Icons.shield_outlined),
  lock('Lock', Icons.lock_outline),
  block('Block', Icons.block),
  attachment('Attachment', Icons.attach_file);

  const _AlertIcon(this.label, this.icon);

  final String label;
  final IconData icon;
}

void _noop() {}
