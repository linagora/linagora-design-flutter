import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';
import 'sidebar_preview_svg_icon.dart';

@widgetbook.UseCase(name: 'Default', type: LinagoraSidebarSectionHeader)
Widget linagoraSidebarSectionHeaderUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Folders');
  final showDisclosure = context.knobs.boolean(
    label: 'Show disclosure',
    initialValue: true,
  );
  final initiallyExpanded = showDisclosure
      ? context.knobs.boolean(label: 'Initially expanded', initialValue: true)
      : false;
  final showSearchAction = context.knobs.boolean(
    label: 'Show search action',
    initialValue: true,
  );
  final showAddAction = context.knobs.boolean(
    label: 'Show add action',
    initialValue: true,
  );
  final addActionVisual = showAddAction
      ? context.knobs.object.dropdown<_SidebarHeaderActionVisual>(
          label: 'Add action visual',
          options: _SidebarHeaderActionVisual.values,
          initialOption: _SidebarHeaderActionVisual.material,
          labelBuilder: (visual) => visual.label,
        )
      : _SidebarHeaderActionVisual.material;

  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: _SidebarSectionHeaderPreview(
      key: ValueKey(
        '$label-$showDisclosure-$initiallyExpanded-'
        '$showSearchAction-$showAddAction',
      ),
      label: label,
      showDisclosure: showDisclosure,
      initiallyExpanded: initiallyExpanded,
      showSearchAction: showSearchAction,
      showAddAction: showAddAction,
      addActionVisual: addActionVisual,
    ),
  );
}

class _SidebarSectionHeaderPreview extends StatefulWidget {
  const _SidebarSectionHeaderPreview({
    super.key,
    required this.label,
    required this.showDisclosure,
    required this.initiallyExpanded,
    required this.showSearchAction,
    required this.showAddAction,
    required this.addActionVisual,
  });

  final String label;
  final bool showDisclosure;
  final bool initiallyExpanded;
  final bool showSearchAction;
  final bool showAddAction;
  final _SidebarHeaderActionVisual addActionVisual;

  @override
  State<_SidebarSectionHeaderPreview> createState() =>
      _SidebarSectionHeaderPreviewState();
}

class _SidebarSectionHeaderPreviewState
    extends State<_SidebarSectionHeaderPreview> {
  late bool _expanded = widget.initiallyExpanded;
  String? _lastAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LinagoraSidebarSectionHeader(
          label: widget.label,
          expanded: widget.showDisclosure ? _expanded : null,
          onExpandToggle: widget.showDisclosure ? _toggleExpansion : null,
          expandToggleLabel:
              _expanded ? 'Collapse ${widget.label}' : 'Expand ${widget.label}',
          actions: [
            if (widget.showSearchAction)
              LinagoraSidebarSectionHeaderAction(
                icon: Icons.search,
                semanticLabel: 'Search ${widget.label}',
                onTap: _search,
              ),
            if (widget.showAddAction) _addAction(),
          ],
        ),
        if (_lastAction != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(_lastAction!),
          ),
      ],
    );
  }

  LinagoraSidebarSectionHeaderAction _addAction() {
    final visual = widget.addActionVisual;
    return LinagoraSidebarSectionHeaderAction(
      icon: visual.icon,
      iconWidget: visual.iconWidget,
      semanticLabel: 'Add ${widget.label}',
      onTap: _add,
      child: visual.child,
    );
  }

  void _search() => setState(() => _lastAction = 'Search action pressed');

  void _add() => setState(() => _lastAction = 'Add action pressed');

  void _toggleExpansion() {
    setState(() => _expanded = !_expanded);
  }
}

enum _SidebarHeaderActionVisual {
  material('Material icon'),
  svgWidget('SVG widget'),
  genericChild('Generic child');

  const _SidebarHeaderActionVisual(this.label);

  final String label;

  IconData? get icon => switch (this) {
        _SidebarHeaderActionVisual.material => Icons.add,
        _ => null,
      };

  Widget? get iconWidget => switch (this) {
        _SidebarHeaderActionVisual.svgWidget => const SidebarPreviewSvgIcon(),
        _ => null,
      };

  Widget? get child => switch (this) {
        _SidebarHeaderActionVisual.genericChild =>
          const Icon(Icons.add_circle_outline),
        _ => null,
      };
}
