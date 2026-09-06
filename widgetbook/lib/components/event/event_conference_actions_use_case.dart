import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: EventConferenceActions)
Widget eventConferenceActionsUseCase(BuildContext context) {
  return const Center(
    child: EventConferenceActions(
      onVideoButtonPressed: _noop,
      onCopyLinkPressed: _noop,
    ),
  );
}

@widgetbook.UseCase(name: 'Custom', type: EventConferenceActions)
Widget eventConferenceActionsCustomUseCase(BuildContext context) {
  final visibility = _VisibilityKnobs.fromContext(context);
  final video = _VideoKnobs.fromContext(context);
  final copy = _CopyKnobs.fromContext(context);

  return Center(
    child: EventConferenceActions(
      showVideoButton: visibility.showVideoButton,
      showCopyButton: visibility.showCopyButton,
      onVideoButtonPressed: visibility.videoEnabled ? _noop : null,
      onCopyLinkPressed: visibility.copyEnabled ? _noop : null,
      videoButtonLabel: video.label,
      videoIcon: video.iconSource.videoIcon,
      videoIconWidget: video.iconSource.videoIconWidget,
      copyIcon: copy.iconSource.copyIcon,
      copyIconWidget: copy.iconSource.copyIconWidget,
      videoIconSize: video.iconSize,
      copyIconSize: copy.iconSize,
      copyButtonTooltip: copy.tooltip,
      copyIconColor: copy.iconColor,
      copyOverlayColor: copy.overlayColor,
      videoButtonStyle: video.style,
    ),
  );
}

class _VisibilityKnobs {
  final bool showVideoButton;
  final bool showCopyButton;
  final bool videoEnabled;
  final bool copyEnabled;

  const _VisibilityKnobs({
    required this.showVideoButton,
    required this.showCopyButton,
    required this.videoEnabled,
    required this.copyEnabled,
  });

  factory _VisibilityKnobs.fromContext(BuildContext context) {
    return _VisibilityKnobs(
      showVideoButton: context.knobs.boolean(
        label: 'Show video button',
        initialValue: true,
      ),
      showCopyButton: context.knobs.boolean(
        label: 'Show copy button',
        initialValue: true,
      ),
      videoEnabled: context.knobs.boolean(
        label: 'Video button enabled',
        initialValue: true,
      ),
      copyEnabled: context.knobs.boolean(
        label: 'Copy button enabled',
        initialValue: true,
      ),
    );
  }
}

class _VideoKnobs {
  final String label;
  final _IconSource iconSource;
  final double iconSize;
  final bool overridesStyle;
  final Color background;
  final Color foreground;
  final double cornerRadius;

  const _VideoKnobs({
    required this.label,
    required this.iconSource,
    required this.iconSize,
    required this.overridesStyle,
    required this.background,
    required this.foreground,
    required this.cornerRadius,
  });

  factory _VideoKnobs.fromContext(BuildContext context) {
    return _VideoKnobs(
      label: context.knobs.string(
        label: 'Video button label',
        initialValue: 'Join the video conference',
      ),
      iconSource: context.knobs.object.dropdown<_IconSource>(
        label: 'Video icon source',
        options: _IconSource.values,
        initialOption: _IconSource.defaultAsset,
        labelBuilder: (source) => source.label,
      ),
      iconSize: context.knobs.double.slider(
        label: 'Video icon size',
        initialValue: EventConferenceActions.defaultVideoIconSize,
        min: 12,
        max: 40,
      ),
      overridesStyle: context.knobs.boolean(
        label: 'Override video style',
        initialValue: false,
      ),
      background: context.knobs.color(
        label: 'Video background',
        initialValue: EventConferenceActions.defaultVideoButtonBackground,
      ),
      foreground: context.knobs.color(
        label: 'Video foreground',
        initialValue: EventConferenceActions.defaultVideoButtonForeground,
      ),
      cornerRadius: context.knobs.double.slider(
        label: 'Video corner radius',
        initialValue: 4,
        min: 0,
        max: 24,
      ),
    );
  }

  ButtonStyle? get style {
    if (!overridesStyle) return null;
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        ),
      ),
    );
  }
}

class _CopyKnobs {
  final _IconSource iconSource;
  final double iconSize;
  final Color iconColor;
  final Color overlayColor;
  final bool showsTooltip;
  final String tooltipLabel;

  const _CopyKnobs({
    required this.iconSource,
    required this.iconSize,
    required this.iconColor,
    required this.overlayColor,
    required this.showsTooltip,
    required this.tooltipLabel,
  });

  factory _CopyKnobs.fromContext(BuildContext context) {
    return _CopyKnobs(
      iconSource: context.knobs.object.dropdown<_IconSource>(
        label: 'Copy icon source',
        options: _IconSource.values,
        initialOption: _IconSource.defaultAsset,
        labelBuilder: (source) => source.label,
      ),
      iconSize: context.knobs.double.slider(
        label: 'Copy icon size',
        initialValue: EventConferenceActions.defaultCopyIconSize,
        min: 12,
        max: 40,
      ),
      iconColor: context.knobs.color(
        label: 'Material copy icon color',
        initialValue: EventConferenceActions.defaultCopyIconColor,
      ),
      overlayColor: context.knobs.color(
        label: 'Copy state layer color',
        initialValue: EventConferenceActions.defaultCopyOverlayColor,
      ),
      showsTooltip: context.knobs.boolean(
        label: 'Show copy tooltip',
        initialValue: true,
      ),
      tooltipLabel: context.knobs.string(
        label: 'Copy tooltip',
        initialValue: 'Copy link',
      ),
    );
  }

  String? get tooltip => showsTooltip ? tooltipLabel : null;
}

enum _IconSource {
  defaultAsset('Default asset'),
  material('Material icon'),
  customWidget('Custom widget');

  const _IconSource(this.label);

  final String label;

  IconData? get videoIcon => switch (this) {
        _IconSource.material => Icons.videocam,
        _ => null,
      };

  IconData? get copyIcon => switch (this) {
        _IconSource.material => Icons.content_copy,
        _ => null,
      };

  Widget? get videoIconWidget => switch (this) {
        _IconSource.customWidget =>
          const Icon(Icons.video_camera_front_outlined),
        _ => null,
      };

  Widget? get copyIconWidget => switch (this) {
        _IconSource.customWidget => const Icon(Icons.copy_all_outlined),
        _ => null,
      };
}

void _noop() {}
