import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/chips/linagora_status_badge_style.dart';

/// A read-only pill naming a state, such as "Delegated mailbox".
class LinagoraStatusBadge extends StatelessWidget {
  final String label;
  final LinagoraStatusBadgeStyle? style;

  const LinagoraStatusBadge({super.key, required this.label, this.style});

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraStatusBadgeStyle.material();
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: tokens.color,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: tokens.padding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tokens.textStyle,
        ),
      ),
    );
  }
}
