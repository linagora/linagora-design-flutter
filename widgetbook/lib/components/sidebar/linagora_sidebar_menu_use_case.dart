import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';
import 'sidebar_storage_reload_preview.dart';

@widgetbook.UseCase(name: 'Complete menu', type: LinagoraSidebarMenu)
Widget linagoraSidebarMenuUseCase(BuildContext context) {
  final configuration = _SidebarMenuPreviewConfiguration.fromKnobs(context);

  return SidebarPreviewSurface(
    width: configuration.width,
    child: SizedBox(
      height: configuration.height,
      child: _SidebarMenuPreview(
        // Only the knobs that seed expansion state restart the preview. Keying
        // on the whole configuration collapsed the tree on every unrelated
        // change, down to each keystroke in the storage label.
        key: ValueKey(configuration.expansionSeed),
        configuration: configuration,
      ),
    ),
  );
}

/// Knobs are registered while the use case builds, so a knob that only applies
/// under another one is registered only when that one is on. It then leaves the
/// panel entirely rather than sitting there doing nothing.
class _SidebarMenuPreviewConfiguration {
  const _SidebarMenuPreviewConfiguration({
    required this.width,
    required this.height,
    required this.showComposer,
    required this.showDragAutoScroll,
    required this.navigation,
    required this.folders,
    required this.labels,
    required this.footer,
  });

  factory _SidebarMenuPreviewConfiguration.fromKnobs(BuildContext context) {
    return _SidebarMenuPreviewConfiguration(
      width: SidebarPreviewSurface.widthKnob(context),
      height: SidebarPreviewSurface.heightKnob(context),
      showComposer: context.knobs.boolean(
        label: 'Show composer',
        initialValue: true,
      ),
      showDragAutoScroll: context.knobs.boolean(
        label: 'Show drag auto-scroll targets',
        initialValue: false,
      ),
      navigation: _SidebarMenuNavigation.fromKnobs(context),
      folders: _SidebarMenuFolders.fromKnobs(context),
      labels: _SidebarMenuLabels.fromKnobs(context),
      footer: _SidebarMenuFooter.fromKnobs(context),
    );
  }

  final double width;
  final double height;
  final bool showComposer;
  final bool showDragAutoScroll;
  final _SidebarMenuNavigation navigation;
  final _SidebarMenuFolders folders;
  final _SidebarMenuLabels labels;
  final _SidebarMenuFooter footer;

  /// The knobs the preview reads once, when its state is created. Restarting
  /// the preview is the only way they can take effect, so the use case keys on
  /// this record — records compare by value, which is all the key needs.
  ({bool folders, bool labels, int treeDepth}) get expansionSeed => (
        folders: folders.initiallyExpanded,
        labels: labels.initiallyExpanded,
        treeDepth: folders.projectTreeDepth,
      );
}

class _SidebarMenuNavigation {
  const _SidebarMenuNavigation({
    required this.activeDestination,
    required this.showCounters,
    required this.showSpamActions,
  });

  /// Values match the knob defaults, so hiding and showing the region again
  /// leaves the preview's expansion state alone.
  const _SidebarMenuNavigation.hidden()
      : activeDestination = null,
        showCounters = true,
        showSpamActions = true;

  factory _SidebarMenuNavigation.fromKnobs(BuildContext context) {
    final visible = context.knobs.boolean(
      label: 'Show mailbox navigation',
      initialValue: true,
    );
    if (!visible) return const _SidebarMenuNavigation.hidden();

    return _SidebarMenuNavigation(
      activeDestination: context.knobs.object.dropdown<_SidebarMenuDestination>(
        label: 'Active destination',
        options: _SidebarMenuDestination.values,
        initialOption: _SidebarMenuDestination.inbox,
        labelBuilder: (destination) => destination.label,
      ),
      showCounters: context.knobs.boolean(
        label: 'Show mailbox counters',
        initialValue: true,
      ),
      showSpamActions: context.knobs.boolean(
        label: 'Show spam actions',
        initialValue: true,
      ),
    );
  }

  /// Null while the navigation region is switched off, which is also what
  /// tells the preview to leave the region out.
  final _SidebarMenuDestination? activeDestination;

  final bool showCounters;
  final bool showSpamActions;

  bool get isVisible => activeDestination != null;
}

class _SidebarMenuFolders {
  const _SidebarMenuFolders({
    required this.isVisible,
    required this.showSearch,
    required this.showAdd,
    required this.initiallyExpanded,
    required this.projectSubfolderCount,
    required this.projectTreeDepth,
  });

  /// Values match the knob defaults — see [_SidebarMenuNavigation.hidden].
  const _SidebarMenuFolders.hidden()
      : isVisible = false,
        showSearch = true,
        showAdd = true,
        initiallyExpanded = true,
        projectSubfolderCount = 1,
        projectTreeDepth = minimumTreeDepth;

  factory _SidebarMenuFolders.fromKnobs(BuildContext context) {
    final visible = context.knobs.boolean(
      label: 'Show folders section',
      initialValue: true,
    );
    if (!visible) return const _SidebarMenuFolders.hidden();

    return _SidebarMenuFolders(
      isVisible: true,
      showSearch: context.knobs.boolean(
        label: 'Show folder search',
        initialValue: true,
      ),
      showAdd: context.knobs.boolean(
        label: 'Show folder add action',
        initialValue: true,
      ),
      initiallyExpanded: context.knobs.boolean(
        label: 'Initially expand folders',
        initialValue: true,
      ),
      projectSubfolderCount: context.knobs.int.slider(
        label: 'Project subfolder count',
        description: 'Number of child sidebar items shown beneath Project.',
        initialValue: 1,
        min: 0,
        max: 8,
        divisions: 8,
      ),
      projectTreeDepth: context.knobs.int.slider(
        label: 'Project tree depth',
        description: 'Deepest indentation level rendered below Project.',
        initialValue: minimumTreeDepth,
        min: minimumTreeDepth,
        max: 8,
        divisions: 6,
      ),
    );
  }

  /// The level the Project subfolders themselves sit at, and so the shallowest
  /// tree the preview can render.
  static const int minimumTreeDepth = 2;

  final bool isVisible;
  final bool showSearch;
  final bool showAdd;
  final bool initiallyExpanded;
  final int projectSubfolderCount;
  final int projectTreeDepth;
}

class _SidebarMenuLabels {
  const _SidebarMenuLabels({
    required this.isVisible,
    required this.showAdd,
    required this.initiallyExpanded,
  });

  /// Values match the knob defaults — see [_SidebarMenuNavigation.hidden].
  const _SidebarMenuLabels.hidden()
      : isVisible = false,
        showAdd = true,
        initiallyExpanded = true;

  factory _SidebarMenuLabels.fromKnobs(BuildContext context) {
    final visible = context.knobs.boolean(
      label: 'Show labels section',
      initialValue: true,
    );
    if (!visible) return const _SidebarMenuLabels.hidden();

    return _SidebarMenuLabels(
      isVisible: true,
      showAdd: context.knobs.boolean(
        label: 'Show label add action',
        initialValue: true,
      ),
      initiallyExpanded: context.knobs.boolean(
        label: 'Initially expand labels',
        initialValue: true,
      ),
    );
  }

  final bool isVisible;
  final bool showAdd;
  final bool initiallyExpanded;
}

class _SidebarMenuFooter {
  const _SidebarMenuFooter({
    required this.storage,
    required this.forceStorageReload,
    required this.showPromotion,
    required this.versionText,
  });

  factory _SidebarMenuFooter.fromKnobs(BuildContext context) {
    final showStorage = context.knobs.boolean(
      label: 'Show storage',
      initialValue: true,
    );
    final storage =
        showStorage ? _SidebarMenuStorage.fromKnobs(context) : null;
    final forceStorageReload = storage != null
        ? context.knobs.boolean(label: 'Reloading storage', initialValue: false)
        : false;
    final showPromotion = context.knobs.boolean(
      label: 'Show promotion',
      initialValue: true,
    );

    final showVersion = context.knobs.boolean(
      label: 'Show version',
      initialValue: true,
    );

    return _SidebarMenuFooter(
      storage: storage,
      forceStorageReload: forceStorageReload,
      showPromotion: showPromotion,
      versionText: showVersion
          ? context.knobs.string(
              label: 'Version text',
              initialValue: 'version 0.13.2',
            )
          : null,
    );
  }

  /// Null while the storage block is switched off.
  final _SidebarMenuStorage? storage;

  /// Lets the footer's loading state be reviewed without activating reload.
  final bool forceStorageReload;

  final bool showPromotion;

  /// Null while the version line is switched off.
  final String? versionText;
}

class _SidebarMenuStorage {
  const _SidebarMenuStorage({
    required this.label,
    required this.progress,
    required this.progressState,
    required this.caption,
  });

  factory _SidebarMenuStorage.fromKnobs(BuildContext context) {
    return _SidebarMenuStorage(
      label: context.knobs.string(
        label: 'Storage label',
        initialValue: 'Stockage',
      ),
      progress: context.knobs.double.slider(
        label: 'Used storage',
        initialValue: 0.02,
        min: 0,
        max: 1,
      ),
      progressState: context.knobs.object.dropdown(
        label: 'Storage progress state',
        options: LinagoraSidebarStorageProgressState.values,
        initialOption: LinagoraSidebarStorageProgressState.normal,
        labelBuilder: (state) => state.name,
      ),
      caption: context.knobs.string(
        label: 'Storage caption',
        initialValue: '497.28 Go disponible',
      ),
    );
  }

  final String label;
  final double progress;
  final LinagoraSidebarStorageProgressState progressState;

  /// Empty drops the caption row rather than reserving an empty line.
  final String caption;
}

class _SidebarMenuPreview extends StatefulWidget {
  const _SidebarMenuPreview({super.key, required this.configuration});

  final _SidebarMenuPreviewConfiguration configuration;

  @override
  State<_SidebarMenuPreview> createState() => _SidebarMenuPreviewState();
}

class _SidebarMenuPreviewState extends State<_SidebarMenuPreview> {
  late bool _foldersExpanded = widget.configuration.folders.initiallyExpanded;
  late bool _labelsExpanded = widget.configuration.labels.initiallyExpanded;
  var _isStorageReloading = false;
  String? _storageStatus;
  final ScrollController _scrollController = ScrollController();

  /// The folder tree is virtualized, so expansion lives here as IDs rather
  /// than as nested widgets. Seeded so the preview opens on the full tree the
  /// depth knob asks for.
  late final Set<String> _expandedFolderIds = _initialExpandedFolderIds();

  static const String _personalFoldersId = 'personal-folders';
  static const String _projectId = 'project';

  static String _projectSubfolderId(int index) => 'project-subfolder-$index';

  static String _nestedFolderId(int depth) => 'nested-folder-$depth';

  @override
  void didUpdateWidget(covariant _SidebarMenuPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configuration.footer.storage?.caption !=
        widget.configuration.footer.storage?.caption) {
      _storageStatus = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final configuration = widget.configuration;
    final navigation = configuration.navigation;
    return LinagoraSidebarMenu(
      controller: _scrollController,
      bodyOverlay: configuration.showDragAutoScroll
          ? const LinagoraSidebarAutoScrollOverlay(isDragging: true)
          : null,
      primaryAction: configuration.showComposer ? _composer(context) : null,
      navigationItems:
          navigation.isVisible ? _navigationItems(navigation) : const [],
      sections: [
        if (configuration.folders.isVisible)
          _foldersSection(configuration.folders),
        if (configuration.labels.isVisible) _labelsSection(configuration.labels),
      ],
      footerItems: _footerItems(configuration.footer),
    );
  }

  Widget _composer(BuildContext context) => SizedBox(
        width: double.infinity,
        child: LinagoraSidebarPrimaryAction(
          label: 'Compose',
          icon: Icons.edit,
          onPressed: () {},
        ),
      );

  List<Widget> _navigationItems(_SidebarMenuNavigation navigation) {
    return [
      _navigationItem(
        navigation,
        _SidebarMenuDestination.inbox,
        icon: Icons.inbox_outlined,
        badgeLabel: navigation.showCounters ? '999+' : null,
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.starred,
        icon: Icons.star_border,
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.actionRequired,
        icon: Icons.schedule_outlined,
        badgeLabel: navigation.showCounters ? '3' : null,
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.sent,
        icon: Icons.send_outlined,
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.archives,
        icon: Icons.archive_outlined,
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.draft,
        icon: Icons.insert_drive_file_outlined,
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.outbox,
        icon: Icons.outbox_outlined,
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.bin,
        icon: Icons.delete_outline,
      ),
      LinagoraSidebarItem(
        label: _SidebarMenuDestination.spam.label,
        icon: Icons.mark_email_unread_outlined,
        active: navigation.activeDestination == _SidebarMenuDestination.spam,
        hovered: navigation.showSpamActions,
        hoverTrailing:
            navigation.showSpamActions ? const _SpamActions() : null,
        onTap: () {},
      ),
      _navigationItem(
        navigation,
        _SidebarMenuDestination.templates,
        icon: Icons.content_paste_outlined,
      ),
    ];
  }

  Widget _navigationItem(
    _SidebarMenuNavigation navigation,
    _SidebarMenuDestination destination, {
    required IconData icon,
    String? badgeLabel,
  }) {
    return LinagoraSidebarItem(
      label: destination.label,
      icon: icon,
      badgeLabel: badgeLabel,
      active: navigation.activeDestination == destination,
      onTap: () {},
    );
  }

  /// The folders live in a sliver tree list, which is the shape a mailbox with
  /// hundreds of folders needs: the rows virtualize against the menu's own
  /// viewport while this header scrolls along with them.
  LinagoraSidebarMenuSection _foldersSection(_SidebarMenuFolders folders) {
    return LinagoraSidebarMenuSection(
      header: LinagoraSidebarSectionHeader(
        label: 'Folders',
        expanded: _foldersExpanded,
        onExpandToggle: _toggleFoldersSection,
        expandToggleLabel:
            _foldersExpanded ? 'Collapse folders' : 'Expand folders',
        actions: [
          if (folders.showSearch)
            LinagoraSidebarSectionHeaderAction(
              icon: Icons.search,
              semanticLabel: 'Search folders',
              onTap: () {},
            ),
          if (folders.showAdd)
            LinagoraSidebarSectionHeaderAction(
              icon: Icons.add,
              semanticLabel: 'Add folder',
              onTap: () {},
            ),
        ],
      ),
      sliver: _foldersExpanded
          ? LinagoraSidebarSliverTreeList<_PreviewFolder>(
              entries: _folderEntries(folders),
              itemBuilder: _buildFolder,
            )
          : null,
    );
  }

  /// Flattens the visible tree the way a product does: descendants of a
  /// collapsed folder are simply left out.
  List<LinagoraSidebarTreeListEntry<_PreviewFolder>> _folderEntries(
    _SidebarMenuFolders folders,
  ) {
    final entries = <LinagoraSidebarTreeListEntry<_PreviewFolder>>[
      const LinagoraSidebarTreeListEntry(
        id: _personalFoldersId,
        data: _PreviewFolder(
          id: _personalFoldersId,
          label: 'Personal folders',
          icon: Icons.folder_outlined,
          hasChildren: true,
        ),
      ),
    ];
    if (!_isFolderExpanded(_personalFoldersId)) return entries;

    entries.add(
      LinagoraSidebarTreeListEntry(
        id: _projectId,
        depth: 1,
        data: _PreviewFolder(
          id: _projectId,
          label: 'Project',
          hasChildren: folders.projectSubfolderCount > 0,
        ),
      ),
    );
    if (!_isFolderExpanded(_projectId)) return entries;

    entries.addAll(_projectSubfolders(folders));
    return entries;
  }

  List<LinagoraSidebarTreeListEntry<_PreviewFolder>> _projectSubfolders(
    _SidebarMenuFolders folders,
  ) {
    const rootDepth = _SidebarMenuFolders.minimumTreeDepth;
    final entries = <LinagoraSidebarTreeListEntry<_PreviewFolder>>[];

    for (var index = 0; index < folders.projectSubfolderCount; index++) {
      final id = _projectSubfolderId(index);
      final isDesignFolder = index == 0;
      final hasNestedFolders =
          isDesignFolder && folders.projectTreeDepth > rootDepth;
      entries.add(
        LinagoraSidebarTreeListEntry(
          id: id,
          depth: rootDepth,
          data: _PreviewFolder(
            id: id,
            label: isDesignFolder ? 'Design' : 'Subfolder $index',
            badgeLabel: isDesignFolder ? '5' : null,
            hasChildren: hasNestedFolders,
          ),
        ),
      );
      if (hasNestedFolders && _isFolderExpanded(id)) {
        entries.addAll(_nestedProjectFolders(folders.projectTreeDepth));
      }
    }
    return entries;
  }

  List<LinagoraSidebarTreeListEntry<_PreviewFolder>> _nestedProjectFolders(
    int maximumDepth,
  ) {
    final entries = <LinagoraSidebarTreeListEntry<_PreviewFolder>>[];
    for (var depth = _SidebarMenuFolders.minimumTreeDepth + 1;
        depth <= maximumDepth;
        depth++) {
      final id = _nestedFolderId(depth);
      final hasChildren = depth < maximumDepth;
      entries.add(
        LinagoraSidebarTreeListEntry(
          id: id,
          depth: depth,
          data: _PreviewFolder(
            id: id,
            label: 'Nested folder $depth',
            hasChildren: hasChildren,
          ),
        ),
      );
      // A collapsed level hides everything below it, so the walk stops here.
      if (hasChildren && !_isFolderExpanded(id)) break;
    }
    return entries;
  }

  Widget _buildFolder(
    BuildContext context,
    LinagoraSidebarTreeListEntry<_PreviewFolder> entry,
  ) {
    final folder = entry.data;
    final expanded = _isFolderExpanded(folder.id);
    return LinagoraSidebarItem(
      label: folder.label,
      icon: folder.icon,
      badgeLabel: folder.badgeLabel,
      expanded: folder.hasChildren ? expanded : null,
      onExpandToggle:
          folder.hasChildren ? () => _toggleFolder(folder.id) : null,
      expandToggleLabel: folder.hasChildren
          ? (expanded ? 'Collapse ${folder.label}' : 'Expand ${folder.label}')
          : null,
      onTap: () {},
    );
  }

  LinagoraSidebarMenuSection _labelsSection(_SidebarMenuLabels labels) {
    return LinagoraSidebarMenuSection(
      header: LinagoraSidebarSectionHeader(
        label: 'Labels',
        expanded: _labelsExpanded,
        onExpandToggle: _toggleLabelsSection,
        expandToggleLabel:
            _labelsExpanded ? 'Collapse labels' : 'Expand labels',
        actions: [
          if (labels.showAdd)
            LinagoraSidebarSectionHeaderAction(
              icon: Icons.add,
              semanticLabel: 'Add label',
              onTap: () {},
            ),
        ],
      ),
      children: [
        if (_labelsExpanded)
          LinagoraSidebarItem(
            label: 'Design',
            icon: Icons.label,
            iconColor: const Color(0xFF1DBB37),
            onTap: () {},
          ),
      ],
    );
  }

  List<Widget> _footerItems(_SidebarMenuFooter footer) {
    final storage = footer.storage;
    final versionText = footer.versionText;
    if (storage == null && !footer.showPromotion && versionText == null) {
      return const [];
    }
    return [
      LinagoraSidebarFooter(
        children: [
          if (storage != null)
            LinagoraSidebarStorage(
              label: storage.label,
              progress: storage.progress,
              progressState: storage.progressState,
              caption: _storageStatus ??
                  (storage.caption.isEmpty ? null : storage.caption),
              trailing: LinagoraSidebarStorageReloadAction(
                isLoading: footer.forceStorageReload || _isStorageReloading,
                semanticLabel: 'Reload storage',
                onPressed: _reloadStorage,
                iconWidget: const Icon(Icons.refresh),
              ),
            ),
          if (footer.showPromotion)
            LinagoraSidebarUpsellButton(
              label: 'Increase your space',
              icon: Icons.workspace_premium_outlined,
              onPressed: () {},
            ),
          if (versionText != null) LinagoraSidebarVersion(text: versionText),
        ],
      ),
    ];
  }

  Set<String> _initialExpandedFolderIds() {
    final folders = widget.configuration.folders;
    if (!folders.initiallyExpanded) return {};
    return {
      _personalFoldersId,
      _projectId,
      _projectSubfolderId(0),
      for (var depth = _SidebarMenuFolders.minimumTreeDepth + 1;
          depth < folders.projectTreeDepth;
          depth++)
        _nestedFolderId(depth),
    };
  }

  Future<void> _reloadStorage() => reloadSidebarStoragePreview(
    setState: setState,
    isMounted: () => mounted,
    setReloading: (isReloading) => _isStorageReloading = isReloading,
    setStatus: (status) => _storageStatus = status,
  );

  bool _isFolderExpanded(String id) => _expandedFolderIds.contains(id);

  void _toggleFolder(String id) {
    setState(() {
      if (!_expandedFolderIds.add(id)) _expandedFolderIds.remove(id);
    });
  }

  void _toggleFoldersSection() =>
      setState(() => _foldersExpanded = !_foldersExpanded);

  void _toggleLabelsSection() =>
      setState(() => _labelsExpanded = !_labelsExpanded);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

/// Product data behind one preview folder row.
class _PreviewFolder {
  const _PreviewFolder({
    required this.id,
    required this.label,
    required this.hasChildren,
    this.icon,
    this.badgeLabel,
  });

  final String id;
  final String label;
  final bool hasChildren;

  /// Null for the nested rows, which the design leaves without a glyph.
  final IconData? icon;

  final String? badgeLabel;
}

class _SpamActions extends StatelessWidget {
  const _SpamActions();

  @override
  Widget build(BuildContext context) => LinagoraSidebarItemActions(
      actions: [
        LinagoraSidebarItemActionEntry(
          id: 'clean-spam',
          child: LinagoraSidebarPopoverAction(
            semanticLabel: 'Clean spam',
            modalSemanticLabel: 'Clear folder',
            child: const Text('Clean'),
            popoverBuilder: (context, close) => LinagoraSidebarConfirmPopover(
              title: 'Clear folder',
              message: 'This example confirms a product-owned action.',
              cancelLabel: 'Cancel',
              confirmLabel: 'Clean',
              closeSemanticLabel: 'Close confirmation',
              onCancel: close,
              onConfirm: close,
            ),
          ),
        ),
        LinagoraSidebarItemActionEntry(
          id: 'more-spam',
          child: LinagoraSidebarMenuAction(
            semanticLabel: 'More spam options',
            child: const Icon(Icons.more_vert),
            onPressed: (details) => showMenu<void>(
              context: context,
              useRootNavigator: true,
              position: details.belowMenuAnchor(Directionality.of(context)),
              items: [
                const PopupMenuItem<void>(child: Text('Mark as read')),
                const PopupMenuItem<void>(child: Text('Create filter')),
                const PopupMenuItem<void>(child: Text('Move folder content')),
              ],
            ),
          ),
        ),
      ],
    );
}

enum _SidebarMenuDestination {
  inbox('Inbox'),
  starred('Starred'),
  actionRequired('Action required'),
  sent('Sent'),
  archives('Archives'),
  draft('Draft'),
  outbox('Outbox'),
  bin('Bin'),
  spam('Spam'),
  templates('Templates');

  const _SidebarMenuDestination(this.label);

  final String label;
}
