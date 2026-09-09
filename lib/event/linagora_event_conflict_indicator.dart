import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// Warns that an event conflicts with another item in the reader's schedule.
class LinagoraEventConflictIndicator extends StatelessWidget {
  static const double defaultSize = 20;

  final String message;
  final double size;
  final Color? color;

  const LinagoraEventConflictIndicator({
    super.key,
    required this.message,
    this.size = defaultSize,
    this.color,
  }) : assert(size > 0, 'Size must be positive');

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    final defaultColor = Theme.of(context).brightness == Brightness.dark
        ? colors.warningDark
        : colors.warning;

    return Tooltip(
      message: message,
      child: Icon(Icons.error, size: size, color: color ?? defaultColor),
    );
  }
}
