import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

class LinagoraButton extends StatelessWidget {
  /// Default icon size, supplied through the generated [ButtonStyle].
  static const double defaultIconSize = 20;

  /// Height of the medium button, which sits between [LinagoraButtonSize.xs]
  /// and [LinagoraButtonSize.m]. Pass it to [minimumHeight] alongside
  /// [mediumPadding].
  static const double mediumHeight = 40;

  /// Padding that goes with [mediumHeight].
  static const EdgeInsets mediumPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 10,
  );

  /// Container of a hovered, focused, or pressed filled button in the primary
  /// colour. The container darkens instead of taking a state layer.
  static const Color primaryHoverBackgroundColor = Color(0xFF006BD8);

  /// State layer over a hovered, focused, or pressed button that draws no
  /// container of its own, in the primary colour.
  static const Color primaryHoverOverlayColor = Color(0x0A0080FF);

  /// Container of a disabled button that draws one.
  static const Color disabledContainerColor = Color(0x1F191929);

  /// Label and icon of a disabled button.
  static const Color disabledContentColor = Color(0x61424244);

  /// States that share the hover treatment. Only one hovered appearance is
  /// specified, so focus and press reuse it rather than inventing colours.
  static const Set<WidgetState> _hoverStates = {
    WidgetState.hovered,
    WidgetState.focused,
    WidgetState.pressed,
  };

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
  /// Use [padding] or [style] to change the target's internal padding.
  final EdgeInsetsGeometry? outerPadding;

  /// Padding between the tap target's edge and its content.
  ///
  /// Defaults to the [size]'s padding. Pass [EdgeInsets.zero] together with
  /// `minimumHeight: 0` for an inline link that sits in a run of text.
  final EdgeInsetsGeometry? padding;

  /// Fixed width for the button's layout box.
  ///
  /// Mutually exclusive with [constraints].
  final double? width;

  /// Layout constraints for the button's box.
  ///
  /// Use `BoxConstraints(maxWidth: …)` to cap the width — [label] ellipsizes
  /// once the cap is hit. Mutually exclusive with [width].
  final BoxConstraints? constraints;

  /// Positions the button's layout box in its available space.
  ///
  /// When null, the button keeps the layout behaviour from earlier releases.
  final AlignmentGeometry? alignment;

  /// Container colour while enabled. Null defers to the ambient button theme.
  final Color? backgroundColor;

  /// Label colour while enabled. Null defers to the ambient button theme.
  final Color? foregroundColor;

  /// Container colour while disabled. Null defers to the ambient button theme.
  final Color? disabledBackgroundColor;

  /// Label and icon colour while disabled. Null defers to the ambient button
  /// theme.
  final Color? disabledForegroundColor;

  /// Container colour while hovered, focused, or pressed.
  ///
  /// Setting this suppresses the state layer, since the container itself
  /// already carries the change.
  final Color? hoverBackgroundColor;

  /// State layer painted while hovered, focused, or pressed. Suits variants
  /// that draw no container of their own.
  final Color? hoverOverlayColor;

  /// Corner radius of the container. Null keeps the fully rounded stadium.
  final double? borderRadius;

  /// Colour applied to the leading icon, whichever form it takes.
  ///
  /// An [icon] glyph is painted in it; an [iconWidget] — an `SvgPicture`,
  /// `Image`, or composed widget — is recoloured through a `srcIn` filter,
  /// which is also what dims it while the button is disabled. Leave it null to
  /// keep a multi-colour asset's own palette, and to let an [icon] glyph
  /// inherit the button's own content colour.
  final Color? iconColor;

  /// Outer size of the leading icon slot. Null keeps [defaultIconSize] for an
  /// [icon] glyph and leaves an [iconWidget] to size itself.
  final double? iconSize;

  /// Pins the tap target to an exact height.
  ///
  /// Content taller than this is squashed, so prefer [minimumHeight] unless an
  /// exact box is required.
  final double? height;

  /// Height the tap target never drops below, overriding the [size]'s own.
  ///
  /// Unlike [height] the button still grows for taller content. Pass 0 to let
  /// it shrink to its label.
  final double? minimumHeight;

  /// Overrides the ambient label style. Colour still comes from
  /// [foregroundColor] and [disabledForegroundColor].
  final TextStyle? textStyle;

  /// Tooltip and semantic hint, useful when [constraints] truncate [label].
  final String? tooltip;

  /// Key applied to the clickable Material button.
  ///
  /// [key] continues to identify the outer [LinagoraButton] widget, while
  /// this key lets a product independently target the interactive region.
  final Key? buttonKey;

  /// How much the tap target tightens around its content.
  ///
  /// Defaults to [VisualDensity.standard] rather than the ambient theme's,
  /// because the design specifies absolute heights and the desktop and web
  /// platform default — [VisualDensity.compact] — takes 8px off every one of
  /// them. Pass the theme's own density to opt a button back into it.
  final VisualDensity visualDensity;

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
    this.padding,
    this.width,
    this.constraints,
    this.alignment,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.hoverBackgroundColor,
    this.hoverOverlayColor,
    this.borderRadius,
    this.iconColor,
    this.iconSize,
    this.height,
    this.minimumHeight,
    this.textStyle,
    this.tooltip,
    this.buttonKey,
    this.visualDensity = VisualDensity.standard,
  }) : assert(iconSpacing >= 0, 'Icon spacing cannot be negative'),
       assert(width == null || width >= 0, 'Button width cannot be negative'),
       assert(
         width == null || constraints == null,
         'Provide either width or constraints, not both',
       ),
       assert(
         borderRadius == null || borderRadius >= 0,
         'Border radius cannot be negative',
       ),
       assert(iconSize == null || iconSize > 0, 'Icon size must be positive'),
       assert(height == null || height > 0, 'Height must be positive'),
       assert(
         minimumHeight == null || minimumHeight >= 0,
         'Minimum height cannot be negative',
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

    final tooltip = this.tooltip;
    return _layout(
      tooltip == null ? button : Tooltip(message: tooltip, child: button),
    );
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
    final leading = _buildLeadingIcon();
    if (leading == null) {
      return text;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading,
        SizedBox(width: iconSpacing),
        Flexible(child: text),
      ],
    );
  }

  /// Colour the leading icon actually paints in.
  ///
  /// Null when the caller set no [iconColor], which leaves an [iconWidget]
  /// untouched and lets an [icon] glyph inherit from the button's own
  /// IconTheme — including the theme's disabled colour.
  Color? get _resolvedIconColor {
    if (iconColor == null) return null;
    if (onPressed == null) return disabledForegroundColor ?? iconColor;
    return iconColor;
  }

  /// Builds the leading slot from whichever icon form the caller supplied: an
  /// [IconData] glyph, or an arbitrary [iconWidget].
  Widget? _buildLeadingIcon() {
    final iconWidget = this.iconWidget;
    if (iconWidget != null) {
      final iconColor = _resolvedIconColor;
      // Without a colour the widget is left exactly as the caller built it.
      if (iconColor == null) return iconWidget;
      // IconTheme reaches nested [Icon]s; the colour filter reaches painted
      // assets — an SVG or a bitmap — which read no theme. srcIn keeps the
      // glyph's alpha and replaces only its colour.
      return SizedBox.square(
        dimension: iconSize ?? defaultIconSize,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          child: IconTheme.merge(
            data: IconThemeData(
              color: iconColor,
              size: iconSize ?? defaultIconSize,
            ),
            child: iconWidget,
          ),
        ),
      );
    }
    final icon = this.icon;
    if (icon == null) return null;
    // Both arguments stay null unless the caller set them, so the glyph keeps
    // inheriting size and colour from the button's own IconTheme.
    return Icon(icon, size: iconSize, color: _resolvedIconColor);
  }

  ButtonStyle _buildStyle(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final height = this.height;
    return ButtonStyle(
      shape: WidgetStatePropertyAll(_shape()),
      iconSize: WidgetStatePropertyAll(iconSize ?? defaultIconSize),
      side: variant == LinagoraButtonVariant.outlined
          ? WidgetStatePropertyAll(BorderSide(color: primary))
          : null,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: visualDensity,
      backgroundColor: _backgroundProperty(),
      foregroundColor: _foregroundProperty(),
      overlayColor: _overlayProperty(),
      textStyle: textStyle == null ? null : WidgetStatePropertyAll(textStyle),
      fixedSize: height == null
          ? null
          : WidgetStatePropertyAll(Size.fromHeight(height)),
      minimumSize: WidgetStatePropertyAll(
        Size(0, minimumHeight ?? height ?? _sizeHeight),
      ),
      padding: WidgetStatePropertyAll(padding ?? _sizePadding),
    );
  }

  OutlinedBorder _shape() {
    final borderRadius = this.borderRadius;
    if (borderRadius == null) return const StadiumBorder();
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    );
  }

  double get _sizeHeight => switch (size) {
    LinagoraButtonSize.xs => 32,
    LinagoraButtonSize.m => 48,
  };

  EdgeInsetsGeometry get _sizePadding => switch (size) {
    LinagoraButtonSize.xs => const EdgeInsets.symmetric(
      horizontal: LinagoraSpacing.base * 1.5,
      vertical: 6,
    ),
    LinagoraButtonSize.m => const EdgeInsets.symmetric(
      horizontal: LinagoraSpacing.base * 3,
      vertical: LinagoraSpacing.base * 1.5,
    ),
  };

  /// Null leaves the ambient button theme in charge, which is what callers
  /// that set no colours have always got.
  WidgetStateProperty<Color?>? _backgroundProperty() {
    final base = backgroundColor;
    final disabled = disabledBackgroundColor;
    final hover = hoverBackgroundColor;
    if (base == null && disabled == null && hover == null) return null;
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return disabled ?? base;
      if (hover != null && states.any(_hoverStates.contains)) return hover;
      return base;
    });
  }

  WidgetStateProperty<Color?>? _foregroundProperty() {
    final base = foregroundColor;
    final disabled = disabledForegroundColor;
    if (base == null && disabled == null) return null;
    return WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.disabled) ? disabled ?? base : base,
    );
  }

  WidgetStateProperty<Color?>? _overlayProperty() {
    final wash = hoverOverlayColor;
    if (wash == null) {
      // A button that swaps its container on hover needs no layer on top.
      return hoverBackgroundColor == null
          ? null
          : const WidgetStatePropertyAll(Colors.transparent);
    }
    return WidgetStateProperty.resolveWith(
      (states) => states.any(_hoverStates.contains) ? wash : null,
    );
  }
}
