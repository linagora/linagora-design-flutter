import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';
import 'sidebar_preview_svg_icon.dart';

@widgetbook.UseCase(name: 'Default', type: LinagoraSidebarStorage)
Widget linagoraSidebarStorageUseCase(BuildContext context) {
  final knobs = _StorageKnobs.read(context);

  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: _SidebarStoragePreview(
      // Resets the preview's own event state whenever a knob changes.
      key: ValueKey(knobs.toString()),
      label: knobs.label,
      progress: knobs.progress,
      progressState: knobs.progressState,
      iconVisual: knobs.iconVisual,
      isLoading: knobs.isLoading,
      statusMode: knobs.status.mode,
      statusText: knobs.status.text,
      statusState: knobs.status.state,
      showTrailingAction: knobs.showTrailingAction,
      makeBlockTappable: knobs.makeBlockTappable,
    ),
  );
}

/// The use case's knob panel. Knobs appear in the order they are read.
class _StorageKnobs {
  const _StorageKnobs({
    required this.label,
    required this.progress,
    required this.progressState,
    required this.iconVisual,
    required this.isLoading,
    required this.status,
    required this.showTrailingAction,
    required this.makeBlockTappable,
  });

  factory _StorageKnobs.read(BuildContext context) => _StorageKnobs(
    label: context.knobs.string(label: 'Label', initialValue: 'Storage'),
    progress: context.knobs.double.slider(
      label: 'Used storage',
      initialValue: 0.02,
      min: 0,
      max: 1,
    ),
    progressState: context.knobs.object.dropdown(
      label: 'Progress state',
      options: LinagoraSidebarStorageProgressState.values,
      initialOption: LinagoraSidebarStorageProgressState.normal,
      labelBuilder: (state) => state.name,
    ),
    iconVisual: context.knobs.object.dropdown<_StorageIconVisual>(
      label: 'Icon slot',
      options: _StorageIconVisual.values,
      initialOption: _StorageIconVisual.material,
      labelBuilder: (visual) => visual.label,
    ),
    isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
    status: _StatusKnobs.read(context),
    showTrailingAction: context.knobs.boolean(
      label: 'Show trailing action',
      initialValue: false,
    ),
    makeBlockTappable: context.knobs.boolean(
      label: 'Make storage block tappable',
      initialValue: false,
    ),
  );

  final String label;
  final double progress;
  final LinagoraSidebarStorageProgressState progressState;
  final _StorageIconVisual iconVisual;
  final bool isLoading;
  final _StatusKnobs status;
  final bool showTrailingAction;
  final bool makeBlockTappable;

  @override
  String toString() =>
      '$label-$progress-$progressState-$iconVisual-$isLoading-$status-'
      '$showTrailingAction-$makeBlockTappable';
}

/// The secondary-content knobs, which only exist when there is a status.
class _StatusKnobs {
  const _StatusKnobs({
    required this.mode,
    required this.text,
    required this.state,
  });

  factory _StatusKnobs.read(BuildContext context) {
    final mode = context.knobs.object.dropdown<_StorageStatusMode>(
      label: 'Secondary content',
      options: _StorageStatusMode.values,
      initialOption: _StorageStatusMode.caption,
      labelBuilder: (mode) => mode.label,
    );
    if (mode == _StorageStatusMode.none) {
      return const _StatusKnobs(
        mode: _StorageStatusMode.none,
        text: '',
        state: LinagoraSidebarStorageStatusState.normal,
      );
    }

    return _StatusKnobs(
      mode: mode,
      text: context.knobs.string(
        label: 'Secondary text',
        initialValue: '497.28 GB available',
      ),
      state: context.knobs.object.dropdown<LinagoraSidebarStorageStatusState>(
        label: 'Status state',
        options: LinagoraSidebarStorageStatusState.values,
        initialOption: LinagoraSidebarStorageStatusState.normal,
        labelBuilder: (status) => status.name,
      ),
    );
  }

  final _StorageStatusMode mode;
  final String text;
  final LinagoraSidebarStorageStatusState state;

  @override
  String toString() => '$mode-$text-$state';
}

class _SidebarStoragePreview extends StatefulWidget {
  const _SidebarStoragePreview({
    super.key,
    required this.label,
    required this.progress,
    required this.progressState,
    required this.iconVisual,
    required this.isLoading,
    required this.statusMode,
    required this.statusText,
    required this.statusState,
    required this.showTrailingAction,
    required this.makeBlockTappable,
  });

  final String label;
  final double progress;
  final LinagoraSidebarStorageProgressState progressState;
  final _StorageIconVisual iconVisual;
  final bool isLoading;
  final _StorageStatusMode statusMode;
  final String statusText;
  final LinagoraSidebarStorageStatusState statusState;
  final bool showTrailingAction;
  final bool makeBlockTappable;

  @override
  State<_SidebarStoragePreview> createState() => _SidebarStoragePreviewState();
}

class _SidebarStoragePreviewState extends State<_SidebarStoragePreview> {
  String? _event;

  @override
  Widget build(BuildContext context) {
    final statusText = widget.statusText.isEmpty ? null : widget.statusText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LinagoraSidebarStorage(
          label: widget.label,
          progress: widget.progress,
          progressState: widget.progressState,
          iconWidget: widget.iconVisual == _StorageIconVisual.svgWidget
              ? const SidebarPreviewSvgIcon()
              : null,
          isLoading: widget.isLoading,
          caption: widget.statusMode == _StorageStatusMode.caption
              ? statusText
              : null,
          status: widget.statusMode == _StorageStatusMode.status
              ? statusText
              : null,
          statusContent: widget.statusMode == _StorageStatusMode.widget
              ? Text(statusText ?? '')
              : null,
          statusState: widget.statusState,
          statusSemanticLabel: statusText == null
              ? null
              : '${widget.statusState.name}: $statusText',
          onTap: widget.makeBlockTappable ? _tapBlock : null,
          trailing:
              widget.showTrailingAction ? const Icon(Icons.more_horiz) : null,
          trailingSemanticLabel:
              widget.showTrailingAction ? 'Storage options' : null,
          onTrailingActionPressed:
              widget.showTrailingAction ? _tapTrailingAction : null,
        ),
        if (_event != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_event!),
          ),
      ],
    );
  }

  void _tapBlock() => setState(() => _event = 'Storage block pressed');

  Future<void> _tapTrailingAction(
    LinagoraSidebarStorageActionDetails details,
  ) async {
    setState(
      () => _event = 'Trailing action: ${details.statusState.name}',
    );
  }
}

enum _StorageIconVisual {
  material('Material icon'),
  svgWidget('SVG widget');

  const _StorageIconVisual(this.label);

  final String label;
}

enum _StorageStatusMode {
  none('None'),
  caption('Legacy caption'),
  status('Two-line status'),
  widget('Status widget');

  const _StorageStatusMode(this.label);

  final String label;
}
