import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Small inline SVG used to exercise widget icon slots in Widgetbook.
///
/// A product would normally supply an asset-backed [SvgPicture]. Keeping this
/// fixture inline makes the component stories self-contained.
class SidebarPreviewSvgIcon extends StatelessWidget {
  const SidebarPreviewSvgIcon({super.key});

  static const String _svg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 3h18v18H3z" fill="currentColor"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svg,
      colorFilter: ColorFilter.mode(
        IconTheme.of(context).color ?? Colors.black,
        BlendMode.srcIn,
      ),
    );
  }
}
