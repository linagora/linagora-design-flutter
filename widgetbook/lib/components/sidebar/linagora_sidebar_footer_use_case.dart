import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'sidebar_preview_surface.dart';

@widgetbook.UseCase(name: 'Storage, promotion and version', type: LinagoraSidebarFooter)
Widget linagoraSidebarFooterUseCase(BuildContext context) {
  final showUpsell = context.knobs.boolean(
    label: 'Show promotion',
    initialValue: true,
  );
  final isLoading = context.knobs.boolean(label: 'Reloading', initialValue: false);

  return SidebarPreviewSurface(
    width: SidebarPreviewSurface.widthKnob(context),
    child: _SidebarFooterPreview(
      showUpsell: showUpsell,
      forceReloading: isLoading,
    ),
  );
}

class _SidebarFooterPreview extends StatefulWidget {
  const _SidebarFooterPreview({
    required this.showUpsell,
    required this.forceReloading,
  });

  final bool showUpsell;
  final bool forceReloading;

  @override
  State<_SidebarFooterPreview> createState() => _SidebarFooterPreviewState();
}

class _SidebarFooterPreviewState extends State<_SidebarFooterPreview> {
  var _isReloading = false;
  var _status = '28 GB available';

  Future<void> _reloadStorage() async {
    setState(() {
      _isReloading = true;
      _status = 'Refreshing storage…';
    });
    await Future<void>.delayed(const Duration(milliseconds: 750));
    if (!mounted) return;
    setState(() {
      _isReloading = false;
      _status = 'Storage refreshed';
    });
  }

  @override
  Widget build(BuildContext context) => LinagoraSidebarFooter(
        children: [
          LinagoraSidebarStorage(
            label: 'Storage',
            progress: 0.72,
            status: _status,
            trailing: LinagoraSidebarStorageReloadAction(
              isLoading: widget.forceReloading || _isReloading,
              semanticLabel: 'Reload storage',
              onPressed: _reloadStorage,
              iconWidget: const Icon(Icons.refresh),
            ),
          ),
          if (widget.showUpsell)
            LinagoraSidebarUpsellButton(
              label: 'Increase your space',
              icon: Icons.workspace_premium_outlined,
              onPressed: () {},
            ),
          const LinagoraSidebarVersion(text: 'version 0.3.0'),
        ],
      );
}
