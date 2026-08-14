import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

@widgetbook.UseCase(
  name: 'Grouped virtualized folder trees',
  type: LinagoraSidebarSliverGroupedTreeList,
)
Widget linagoraSidebarGroupedTreeListUseCase(BuildContext context) {
  final showLabels = context.knobs.boolean(
    label: 'Show labels group',
    initialValue: true,
  );
  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: SizedBox(
      height: SidebarPreviewSurface.heightKnob(context),
      child: CustomScrollView(
        slivers: [
          LinagoraSidebarSliverGroupedTreeList<_GroupedPreviewNode>(
            groups: [
              const LinagoraSidebarTreeGroup<_GroupedPreviewNode>(
                id: 'folders',
                header: LinagoraSidebarSectionHeader(
                  label: 'Personal folders',
                ),
                roots: [
                  _GroupedPreviewNode(
                    'project',
                    'Project',
                    children: [
                      _GroupedPreviewNode('design', 'Design'),
                      _GroupedPreviewNode('research', 'Research'),
                    ],
                  ),
                  _GroupedPreviewNode('archive', 'Archive'),
                ],
              ),
              if (showLabels)
                const LinagoraSidebarTreeGroup<_GroupedPreviewNode>(
                  id: 'labels',
                  header: LinagoraSidebarSectionHeader(label: 'Labels'),
                  roots: [
                    _GroupedPreviewNode('important', 'Important'),
                    _GroupedPreviewNode('waiting', 'Waiting'),
                  ],
                ),
            ],
            adapter: const LinagoraSidebarTreeAdapter<_GroupedPreviewNode>(
              childrenOf: _groupedChildrenOf,
              idOf: _groupedIdOf,
              isExpanded: _groupedIsExpanded,
            ),
            itemBuilder: (context, entry) => LinagoraSidebarItem(
              label: entry.data.label,
              icon: entry.depth == 1 ? Icons.folder_outlined : null,
              expanded: entry.data.children.isEmpty ? null : true,
            ),
          ),
        ],
      ),
    ),
  );
}

class _GroupedPreviewNode {
  const _GroupedPreviewNode(this.id, this.label, {this.children = const []});

  final String id;
  final String label;
  final List<_GroupedPreviewNode> children;
}

Iterable<_GroupedPreviewNode> _groupedChildrenOf(_GroupedPreviewNode node) =>
    node.children;

Object _groupedIdOf(_GroupedPreviewNode node) => node.id;

bool _groupedIsExpanded(_GroupedPreviewNode node) => true;
