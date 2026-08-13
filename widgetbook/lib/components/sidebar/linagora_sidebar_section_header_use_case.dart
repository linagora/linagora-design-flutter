import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

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
  });

  final String label;
  final bool showDisclosure;
  final bool initiallyExpanded;
  final bool showSearchAction;
  final bool showAddAction;

  @override
  State<_SidebarSectionHeaderPreview> createState() =>
      _SidebarSectionHeaderPreviewState();
}

class _SidebarSectionHeaderPreviewState
    extends State<_SidebarSectionHeaderPreview> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return LinagoraSidebarSectionHeader(
      label: widget.label,
      expanded: widget.showDisclosure ? _expanded : null,
      onExpandToggle: widget.showDisclosure ? _toggleExpansion : null,
      expandToggleLabel: _expanded
          ? 'Collapse ${widget.label}'
          : 'Expand ${widget.label}',
      actions: [
        if (widget.showSearchAction)
          LinagoraSidebarSectionHeaderAction(
            icon: Icons.search,
            semanticLabel: 'Search ${widget.label}',
            onTap: () {},
          ),
        if (widget.showAddAction)
          LinagoraSidebarSectionHeaderAction(
            icon: Icons.add,
            semanticLabel: 'Add ${widget.label}',
            onTap: () {},
          ),
      ],
    );
  }

  void _toggleExpansion() {
    setState(() => _expanded = !_expanded);
  }
}
