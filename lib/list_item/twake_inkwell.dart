import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';

class TwakeInkWell extends StatefulWidget {
  final Function()? onTap;
  final Function(TapDownDetails)? onSecondaryTapDown;
  final Function()? onLongPress;
  final Widget child;
  final bool isSelected;

  const TwakeInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.onSecondaryTapDown,
    this.onLongPress,
  });

  @override
  State<StatefulWidget> createState() {
    return TwakeInkWellState();
  }
}

class TwakeInkWellState extends State<TwakeInkWell> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: LinagoraHoverStyle.material().borderRadius,
      color: widget.isSelected
          ? LinagoraHoverStyle.material().selectedColor
          : Colors.transparent,
      child: InkWell(
        borderRadius: LinagoraHoverStyle.material().hoverBorderRadius,
        splashColor: LinagoraHoverStyle.material().hoverColor,
        onTap: widget.onTap,
        onSecondaryTapDown: widget.onSecondaryTapDown,
        onLongPress: widget.onLongPress,
        child: widget.child,
      ),
    );
  }
}
