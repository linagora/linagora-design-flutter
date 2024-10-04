import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/list_item_style.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';

class TwakeListItem extends StatelessWidget {
  final Widget child;

  const TwakeListItem({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ListItemStyle.height,
        decoration: BoxDecoration(
          border: LinagoraDividerStyle.material().dividerDecoration,
        ),
        child: child);
  }
}
