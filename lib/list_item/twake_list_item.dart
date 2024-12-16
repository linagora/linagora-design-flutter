import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';

class TwakeListItem extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const TwakeListItem({
    Key? key,
    required this.child,
    this.height,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      decoration: BoxDecoration(
        border: LinagoraDividerStyle.material().borderDecoration,
      ),
      child: child,
    );
  }
}
