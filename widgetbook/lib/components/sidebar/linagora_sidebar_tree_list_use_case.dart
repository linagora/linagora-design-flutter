import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

@widgetbook.UseCase(name: 'Virtualized folder tree', type: LinagoraSidebarTreeList)
Widget linagoraSidebarTreeListUseCase(BuildContext context) {
  return _SidebarTreeListPreview(
    width: SidebarPreviewSurface.widthKnob(context),
    rootFolderCount: context.knobs.int.slider(
      label: 'Root folder count',
      description: 'Number of folders at the first tree level.',
      initialValue: 40,
      min: 1,
      max: 200,
      divisions: 199,
    ),
    maximumDepth: context.knobs.int.slider(
      label: 'Maximum depth',
      description: 'Deepest nesting level shown in the preview tree.',
      initialValue: 3,
      min: 1,
      max: 8,
      divisions: 7,
    ),
    showNestedFolderIcons: context.knobs.boolean(
      label: 'Show nested folder icons',
      initialValue: true,
    ),
    showSelectedFolder: context.knobs.boolean(
      label: 'Show selected folder',
      initialValue: false,
    ),
  );
}

class _SidebarTreeListPreview extends StatefulWidget {
  const _SidebarTreeListPreview({
    required this.width,
    required this.rootFolderCount,
    required this.maximumDepth,
    required this.showNestedFolderIcons,
    required this.showSelectedFolder,
  });

  final double width;
  final int rootFolderCount;
  final int maximumDepth;
  final bool showNestedFolderIcons;
  final bool showSelectedFolder;

  @override
  State<_SidebarTreeListPreview> createState() =>
      _SidebarTreeListPreviewState();
}

class _SidebarTreeListPreviewState extends State<_SidebarTreeListPreview> {
  final Set<String> _expandedFolderIds = {
    'personal',
    'folder-0',
    'folder-0-2',
  };

  @override
  Widget build(BuildContext context) {
    // The surface already caps its child at the selected width; the list fills
    // it, so a SizedBox here would only be a second copy of the same number.
    return SidebarPreviewSurface(
      width: widget.width,
      child: LinagoraSidebarTreeList<_PreviewFolder>(
        key: const PageStorageKey('sidebar-tree-list-preview'),
        entries: _visibleEntries,
        itemBuilder: _buildItem,
      ),
    );
  }

  List<LinagoraSidebarTreeListEntry<_PreviewFolder>> get _visibleEntries {
    final entries = <LinagoraSidebarTreeListEntry<_PreviewFolder>>[
      const LinagoraSidebarTreeListEntry(
        id: 'personal',
        data: _PreviewFolder(
          id: 'personal',
          label: 'Personal folders',
          hasChildren: true,
        ),
      ),
    ];
    if (!_isExpanded('personal')) return entries;

    for (var index = 0; index < widget.rootFolderCount; index++) {
      _addFolder(entries, index: index, depth: 1);
    }
    return entries;
  }

  void _addFolder(
    List<LinagoraSidebarTreeListEntry<_PreviewFolder>> entries, {
    required int index,
    required int depth,
  }) {
    final id = 'folder-$index${depth == 1 ? '' : '-$depth'}';
    final hasChildren = index == 0 && depth < widget.maximumDepth;
    entries.add(
      LinagoraSidebarTreeListEntry(
        id: id,
        depth: depth,
        data: _PreviewFolder(
          id: id,
          label: _folderLabel(index, depth),
          hasChildren: hasChildren,
        ),
      ),
    );
    if (hasChildren && _isExpanded(id)) {
      _addFolder(entries, index: index, depth: depth + 1);
    }
  }

  String _folderLabel(int index, int depth) {
    if (index != 0) return 'Folder ${index + 1}';
    return switch (depth) {
      1 => 'Project',
      2 => 'Design',
      _ => 'Subfolder $depth',
    };
  }

  Widget _buildItem(
    BuildContext context,
    LinagoraSidebarTreeListEntry<_PreviewFolder> entry,
  ) {
    final folder = entry.data;
    final expanded = _isExpanded(folder.id);
    return LinagoraSidebarItem(
      label: folder.label,
      icon: entry.depth == 0 || widget.showNestedFolderIcons
          ? Icons.folder_outlined
          : null,
      active: widget.showSelectedFolder && folder.id == 'folder-0',
      expanded: folder.hasChildren ? expanded : null,
      onExpandToggle: folder.hasChildren ? () => _toggle(folder.id) : null,
      expandToggleLabel: folder.hasChildren
          ? (expanded ? 'Collapse ${folder.label}' : 'Expand ${folder.label}')
          : null,
    );
  }

  bool _isExpanded(String id) => _expandedFolderIds.contains(id);

  void _toggle(String id) {
    setState(() {
      if (!_expandedFolderIds.add(id)) _expandedFolderIds.remove(id);
    });
  }
}

class _PreviewFolder {
  const _PreviewFolder({
    required this.id,
    required this.label,
    required this.hasChildren,
  });

  final String id;
  final String label;
  final bool hasChildren;
}
