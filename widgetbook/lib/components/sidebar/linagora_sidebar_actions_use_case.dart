import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

@widgetbook.UseCase(name: 'Menu and confirm actions', type: LinagoraSidebarItem)
Widget linagoraSidebarActionsUseCase(BuildContext context) {
  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: const _SidebarActionsPreview(),
  );
}

class _SidebarActionsPreview extends StatefulWidget {
  const _SidebarActionsPreview();

  @override
  State<_SidebarActionsPreview> createState() => _SidebarActionsPreviewState();
}

class _SidebarActionsPreviewState extends State<_SidebarActionsPreview> {
  String _event = 'Open either trailing action';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LinagoraSidebarItem(
          label: 'Spam',
          badgeLabel: '3',
          onTap: () => setState(() => _event = 'Spam selected'),
          hoverTrailing: LinagoraSidebarItemActions(
            actions: [
              LinagoraSidebarItemActionEntry(
                id: 'clean-spam',
                child: LinagoraSidebarPopoverAction(
                  semanticLabel: 'Clean Spam',
                  modalSemanticLabel: 'Clear folder',
                  child: const Text('Clean'),
                  popoverBuilder: (context, close) =>
                      LinagoraSidebarConfirmPopover(
                    title: 'Clear folder',
                    message: 'This example confirms a product-owned action.',
                    cancelLabel: 'Cancel',
                    confirmLabel: 'Clean',
                    closeSemanticLabel: 'Close confirmation',
                    onCancel: close,
                    onConfirm: () {
                      close();
                      setState(() => _event = 'Folder cleared');
                    },
                  ),
                ),
              ),
              LinagoraSidebarItemActionEntry(
                id: 'more-spam',
                child: LinagoraSidebarMenuAction(
                  semanticLabel: 'More Spam actions',
                  child: const Icon(Icons.more_horiz),
                  onPressed: (details) => showMenu<void>(
                    context: context,
                    useRootNavigator: true,
                    clipBehavior: Clip.antiAlias,
                    position: details.belowMenuAnchor(
                      Directionality.of(context),
                    ),
                    items: [
                      PopupMenuItem<void>(
                        onTap: () => setState(() => _event = 'Menu action'),
                        child: const Text('Mark as read'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: LinagoraSpacing.base),
        Text(_event),
      ],
    );
  }
}
