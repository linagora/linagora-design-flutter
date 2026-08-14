import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_item.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_menu.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// A footer column that omits hidden product slots without leaving a gap.
class LinagoraSidebarFooter extends StatelessWidget {
  const LinagoraSidebarFooter({
    super.key,
    required this.children,
    this.spacing = LinagoraSidebarMenu.footerItemSpacing,
    this.padding = EdgeInsets.zero,
  }) : assert(spacing >= 0, 'Sidebar footer spacing cannot be negative');

  /// Product-controlled footer blocks. Null entries are removed before spacing
  /// is applied, so a hidden quota or promotion does not leave an empty slot.
  final List<Widget?> children;
  final double spacing;
  /// Use [LinagoraSidebarMenu.footerPadding] when this footer is outside a
  /// [LinagoraSidebarMenu]. The menu applies that end inset itself.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final visibleChildren = children.whereType<Widget>().toList(growable: false);
    if (visibleChildren.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < visibleChildren.length; index++) ...[
            if (index > 0) SizedBox(height: spacing),
            visibleChildren[index],
          ],
        ],
      ),
    );
  }
}

/// Generic outlined promotional action for a sidebar footer.
class LinagoraSidebarUpsellButton extends StatelessWidget {
  static const double defaultMinWidth = 193;
  static const double height = 44;
  static const double borderRadius = 7;

  const LinagoraSidebarUpsellButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.semanticLabel,
    this.expanded = true,
    this.minWidth = defaultMinWidth,
    this.style,
  }) : assert(
         icon != null || iconWidget != null,
         'A sidebar upsell button needs an icon or iconWidget',
       ),
       assert(minWidth >= 0, 'A sidebar upsell minimum width cannot be negative');

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? iconWidget;
  final String? semanticLabel;
  final bool expanded;
  final double minWidth;
  final LinagoraSidebarStyle? style;

  @override
  Widget build(BuildContext context) {
    final sidebar = style ?? LinagoraSidebarStyle.of(context);
    final button = LinagoraButton(
      label: label,
      icon: icon,
      iconWidget: iconWidget,
      onPressed: onPressed,
      variant: LinagoraButtonVariant.outlined,
      iconSpacing: LinagoraSpacing.base,
      style: ButtonStyle(
        // Height through min/max, not `fixedSize`: a `Size.fromHeight` is
        // infinitely wide, which pins the width to the parent's maximum.
        minimumSize: WidgetStatePropertyAll(Size(minWidth, height)),
        maximumSize: const WidgetStatePropertyAll(
          Size(double.infinity, height),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsetsDirectional.symmetric(horizontal: LinagoraSpacing.base),
        ),
        foregroundColor: WidgetStatePropertyAll(
          sidebar.resolvedUpsellForeground,
        ),
        side: WidgetStatePropertyAll(
          BorderSide(color: sidebar.resolvedUpsellBorderColor),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
      ),
    );

    final labelledButton = semanticLabel == null
        ? button
        : Semantics(label: semanticLabel, child: button);
    if (!expanded) {
      // Align loosens the tight width a stretching parent hands down, such as
      // [LinagoraSidebarFooter], so hug mode can hug.
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth, minHeight: height),
          child: labelledButton,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.hasBoundedWidth ? double.infinity : null,
        height: height,
        child: labelledButton,
      ),
    );
  }
}

/// A compact reload control for [LinagoraSidebarStorage.trailing].
class LinagoraSidebarStorageReloadAction extends StatefulWidget {
  const LinagoraSidebarStorageReloadAction({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.semanticLabel,
    required this.iconWidget,
    this.style,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final String semanticLabel;
  final Widget iconWidget;
  final LinagoraSidebarStyle? style;

  @override
  State<LinagoraSidebarStorageReloadAction> createState() =>
      _LinagoraSidebarStorageReloadActionState();
}

class _LinagoraSidebarStorageReloadActionState
    extends State<LinagoraSidebarStorageReloadAction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void initState() {
    super.initState();
    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant LinagoraSidebarStorageReloadAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) _updateAnimation();
  }

  void _updateAnimation() {
    if (widget.isLoading) {
      _controller.repeat();
    } else {
      // Reset, not stop: a glyph frozen mid-turn reads as a broken control.
      _controller.reset();
    }
  }

  /// Named once: the inert loading state needs its own disabled node, while
  /// [LinagoraSidebarItemAction] names the tappable one.
  @override
  Widget build(BuildContext context) => _named(
    LinagoraSidebarItemAction(
      semanticLabel: widget.isLoading ? null : widget.semanticLabel,
      onTap: widget.isLoading ? null : widget.onPressed,
      padding: EdgeInsets.zero,
      style: widget.style,
      child: RotationTransition(
        turns: _controller,
        child: SizedBox.square(
          dimension: LinagoraSidebarItemAction.minimumDimension,
          child: Center(child: widget.iconWidget),
        ),
      ),
    ),
  );

  Widget _named(Widget action) {
    if (!widget.isLoading) return action;
    return Semantics(
      button: true,
      enabled: false,
      label: widget.semanticLabel,
      child: action,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
