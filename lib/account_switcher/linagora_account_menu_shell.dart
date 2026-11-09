import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/account_switcher/linagora_account_switcher_style.dart';

/// Surface around a [LinagoraAccountMenu]: wraps content height, caps at
/// [maxHeight], and scrolls only when taller. The scrollbar sits on the panel
/// edge; [LinagoraAccountSwitcherStyle.menuPadding] still insets the items.
class LinagoraAccountMenuShell extends StatelessWidget {
  final double maxHeight;
  final Widget child;
  final LinagoraAccountSwitcherStyle? style;
  final double? width;
  final Key? menuMaterialKey;

  const LinagoraAccountMenuShell({
    super.key,
    required this.maxHeight,
    required this.child,
    this.style,
    this.width,
    this.menuMaterialKey,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraAccountSwitcherStyle.material();
    return Material(
      key: menuMaterialKey,
      type: MaterialType.transparency,
      child: Container(
        width: width ?? tokens.menuWidth,
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: tokens.menuColor,
          borderRadius: BorderRadius.circular(tokens.menuRadius),
          boxShadow: tokens.menuShadow,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            primary: true,
            child: Padding(padding: tokens.menuPadding, child: child),
          ),
        ),
      ),
    );
  }
}
