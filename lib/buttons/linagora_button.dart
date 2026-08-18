import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

class LinagoraButton extends StatelessWidget {
  /// Default icon theme size. An [iconWidget] keeps its own layout constraints.
  static const double defaultIconSize = 20;

  final String label;

  /// Used when [iconWidget] is null.
  final IconData? icon;

  /// Replaces [icon] when both are supplied, allowing a product to provide an
  /// SVG or other widget.
  final Widget? iconWidget;

  final VoidCallback? onPressed;
  final LinagoraButtonSize size;
  final LinagoraButtonVariant variant;

  /// Visual properties that override the variant and size defaults.
  final ButtonStyle? style;

  /// Space between [icon] and [label].
  final double iconSpacing;

  /// Padding outside the clickable button.
  ///
  /// This belongs to the button's layout rather than its Material tap target.
  /// Use [style] to change the target's internal padding.
  final EdgeInsetsGeometry? outerPadding;

  /// Fixed width for the button's layout box.
  ///
  /// Mutually exclusive with [constraints].
  final double? width;

  /// Layout constraints for the button's box.
  ///
  /// Mutually exclusive with [width].
  final BoxConstraints? constraints;

  /// Positions the button's layout box in its available space.
  ///
  /// When null, the button keeps the layout behaviour from earlier releases.
  final AlignmentGeometry? alignment;

  /// Key applied to the clickable Material button.
  ///
  /// [key] continues to identify the outer [LinagoraButton] widget, while
  /// this key lets a product independently target the interactive region.
  final Key? buttonKey;

  const LinagoraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.size = LinagoraButtonSize.m,
    this.variant = LinagoraButtonVariant.filled,
    this.style,
    this.iconSpacing = LinagoraSpacing.base,
    this.outerPadding,
    this.width,
    this.constraints,
    this.alignment,
    this.buttonKey,
  }) : assert(iconSpacing >= 0, 'Icon spacing cannot be negative'),
       assert(width == null || width >= 0, 'Button width cannot be negative'),
       assert(
         width == null || constraints == null,
         'Provide either width or constraints, not both',
       );

  @override
  Widget build(BuildContext context) {
    final defaultStyle = _buildStyle(context);
    // Caller values take precedence over the defaults.
    final buttonStyle = style?.merge(defaultStyle) ?? defaultStyle;
    final child = _buildChild();

    final button = switch (variant) {
      LinagoraButtonVariant.filled => FilledButton(
        key: buttonKey,
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      ),
      LinagoraButtonVariant.outlined => OutlinedButton(
        key: buttonKey,
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      ),
      LinagoraButtonVariant.text => TextButton(
        key: buttonKey,
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      ),
    };

    return _layout(button);
  }

  Widget _layout(Widget button) {
    Widget result = button;
    final width = this.width;
    final constraints = this.constraints;
    final alignment = this.alignment;
    final outerPadding = this.outerPadding;

    // Keep the constrained button separate from its outer positioning. A
    // Container with alignment expands in a bounded parent, while [Align]
    // positions only this button's layout box.
    if (width != null) result = SizedBox(width: width, child: result);
    if (constraints != null) {
      result = ConstrainedBox(constraints: constraints, child: result);
    }
    if (alignment != null) result = Align(alignment: alignment, child: result);
    if (outerPadding != null) {
      result = Padding(padding: outerPadding, child: result);
    }
    return result;
  }

  Widget _buildChild() {
    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
    final icon = this.icon;
    final iconWidget = this.iconWidget;
    if (icon == null && iconWidget == null) {
      return text;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (iconWidget != null)
          IconTheme.merge(
            data: const IconThemeData(size: defaultIconSize),
            child: iconWidget,
          )
        else
          Icon(icon),
        SizedBox(width: iconSpacing),
        Flexible(child: text),
      ],
    );
  }

  ButtonStyle _buildStyle(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ButtonStyle(
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      iconSize: const WidgetStatePropertyAll(20),
      side: variant == LinagoraButtonVariant.outlined
          ? WidgetStatePropertyAll(BorderSide(color: primary))
          : null,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: WidgetStatePropertyAll(
        switch (size) {
          LinagoraButtonSize.xs => const Size(0, 32),
          LinagoraButtonSize.m => const Size(0, 48),
        },
      ),
      padding: WidgetStatePropertyAll(
        switch (size) {
          LinagoraButtonSize.xs => const EdgeInsets.symmetric(
              horizontal: LinagoraSpacing.base * 1.5,
              vertical: 6,
            ),
          LinagoraButtonSize.m => const EdgeInsets.symmetric(
              horizontal: LinagoraSpacing.base * 3,
              vertical: LinagoraSpacing.base * 1.5,
            ),
        },
      ),
    );
  }
}
