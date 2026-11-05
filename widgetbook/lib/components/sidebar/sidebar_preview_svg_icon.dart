import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

/// Small SVG used to exercise widget icon slots in Widgetbook, tinted with
/// the ambient icon colour.
///
/// The default is an inline square fixture. [SidebarPreviewSvgIcon.asset]
/// shows a design system asset instead.
class SidebarPreviewSvgIcon extends StatelessWidget {
  const SidebarPreviewSvgIcon({super.key}) : asset = null;

  const SidebarPreviewSvgIcon.asset(String this.asset, {super.key});

  final String? asset;

  static const String _svg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 3h18v18H3z" fill="currentColor"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    final asset = this.asset;
    final colorFilter = ColorFilter.mode(
      IconTheme.of(context).color ?? Colors.black,
      BlendMode.srcIn,
    );
    if (asset == null) return SvgPicture.string(_svg, colorFilter: colorFilter);
    return SvgPicture.asset(
      asset,
      package: LinagoraDesignImages.packageName,
      colorFilter: colorFilter,
    );
  }
}
