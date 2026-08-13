import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// A compact build/version line for a sidebar footer.
///
/// It is independent from [LinagoraSidebarStorage], so products without a
/// quota display can still show their application version in a sidebar.
///
/// The text centres itself in whatever width its parent gives it — a footer
/// [Column] with [CrossAxisAlignment.stretch] hands it the sidebar width — and
/// hugs its content otherwise.
class LinagoraSidebarVersion extends StatelessWidget {
  const LinagoraSidebarVersion({super.key, required this.text, this.style});

  final String text;

  final LinagoraSidebarStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? LinagoraSidebarStyle.of(context);

    // No SizedBox forcing an infinite width: that threw whenever a caller
    // placed the line in a Row or any other horizontally unbounded parent.
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: LinagoraTextTheme.material().labelSmall?.copyWith(
        color: style.resolvedStorageVersionForeground,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
