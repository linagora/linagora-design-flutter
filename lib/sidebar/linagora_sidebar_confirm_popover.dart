import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_popover_shape.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// The visual treatment of a [LinagoraSidebarConfirmPopover].
///
/// The defaults match the shared sidebar confirmation design: a 300px card,
/// 12px content inset, 32px action buttons, a 16px card radius and the
/// standard 0/8/24 popover shadow. Products can tailor a token here without
/// rebuilding the confirmation layout.
@immutable
class LinagoraSidebarConfirmPopoverStyle {
  const LinagoraSidebarConfirmPopoverStyle({
    this.width = defaultWidth,
    this.horizontalContentInset = 12,
    this.topContentInset = 12,
    this.bottomContentInset = 12,
    this.titleBodySpacing = 12,
    this.bodyActionsSpacing = 12,
    this.actionsSpacing = 9,
    this.actionsEndInset = 12,
    this.cardBorderRadius = 16,
    this.arrowSize = 8,
    this.arrowOffset = 30,
    this.shadowColor,
    this.shadowOffset = const Offset(0, 8),
    this.shadowBlurRadius = 24,
    this.closeIconSize = 24,
    this.closeButtonSize = 32,
    this.buttonHeight = 32,
    this.buttonHorizontalPadding = 12,
    this.buttonBorderRadius = 8,
    this.backgroundColor,
    this.foregroundColor,
    this.closeIconColor,
    this.cancelBackgroundColor,
    this.cancelForegroundColor,
    this.primaryConfirmBackgroundColor,
    this.destructiveConfirmBackgroundColor,
    this.confirmForegroundColor,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.buttonTextStyle,
  }) : assert(width > 0, 'A sidebar confirmation popover needs a width'),
       assert(
         horizontalContentInset >= 0 &&
             topContentInset >= 0 &&
             bottomContentInset >= 0,
         'Confirmation content insets cannot be negative',
       ),
       assert(
         titleBodySpacing >= 0 &&
             bodyActionsSpacing >= 0 &&
             actionsSpacing >= 0 &&
             actionsEndInset >= 0,
         'Confirmation spacing cannot be negative',
       ),
       assert(
         cardBorderRadius >= 0 &&
             arrowSize >= 0 &&
             arrowOffset >= 0 &&
             shadowBlurRadius >= 0,
         'Confirmation shape and shadow values cannot be negative',
       ),
       assert(
         closeIconSize >= 0 &&
             closeButtonSize >= closeIconSize &&
             buttonHeight > 0 &&
             buttonHorizontalPadding >= 0 &&
             buttonBorderRadius >= 0,
         'Confirmation button values must be valid',
       );

  /// Width of the rounded card surface, excluding the side arrow.
  static const double defaultWidth = 300;

  final double width;
  final double horizontalContentInset;
  final double topContentInset;
  final double bottomContentInset;
  final double titleBodySpacing;
  final double bodyActionsSpacing;
  final double actionsSpacing;

  /// The actions sit 16px from the card edge, one step tighter than body copy.
  final double actionsEndInset;
  final double cardBorderRadius;
  final double arrowSize;

  /// Distance from the bottom card edge to the arrow's lower point.
  ///
  /// The default aligns the arrow tip with the centre of the standard 24px
  /// sidebar action through [LinagoraSidebarPopoverAction]'s default anchor.
  final double arrowOffset;

  /// Defaults to the sidebar popover-shadow colour (black at 24% opacity).
  final Color? shadowColor;
  final Offset shadowOffset;
  final double shadowBlurRadius;
  final double closeIconSize;
  final double closeButtonSize;
  final double buttonHeight;
  final double buttonHorizontalPadding;
  final double buttonBorderRadius;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? closeIconColor;
  final Color? cancelBackgroundColor;
  final Color? cancelForegroundColor;
  final Color? primaryConfirmBackgroundColor;
  final Color? destructiveConfirmBackgroundColor;
  final Color? confirmForegroundColor;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final TextStyle? buttonTextStyle;

  /// Resolves the Figma 0/8/24 shadow against a sidebar colour override.
  BoxShadow resolveShadow(LinagoraSidebarStyle sidebar) => BoxShadow(
    color: shadowColor ?? sidebar.resolvedPopoverShadowColor,
    offset: shadowOffset,
    blurRadius: shadowBlurRadius,
  );
}

/// The visual colour treatment for a confirmation's primary action.
///
/// This is intentionally independent of whether the product operation is
/// destructive. For example, deleting a folder can retain the brand-blue
/// [primary] treatment when that is the surrounding product design.
enum LinagoraSidebarConfirmButtonVariant { primary, destructive }

/// Generic confirmation card intended for [LinagoraSidebarPopoverAction].
///
/// Applications supply localized copy and business callbacks. The component
/// deliberately has no knowledge of the resource an action affects.
class LinagoraSidebarConfirmPopover extends StatelessWidget {
  static const double defaultWidth =
      LinagoraSidebarConfirmPopoverStyle.defaultWidth;

  const LinagoraSidebarConfirmPopover({
    super.key,
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
    required this.closeSemanticLabel,
    this.closeIcon,
    double? width,
    this.maxHeight,
    this.confirmButtonVariant = LinagoraSidebarConfirmButtonVariant.primary,
    this.style,
    this.popoverStyle,
  }) : width = width ?? defaultWidth,
       _hasExplicitWidth = width != null,
       assert(
         width == null || width > 0,
         'A sidebar confirmation popover needs a width',
       ),
       assert(
         maxHeight == null || maxHeight > 0,
         'A sidebar confirmation popover maximum height must be positive',
       );

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String closeSemanticLabel;
  final Widget? closeIcon;

  /// Width of the rounded card surface, excluding the side arrow.
  ///
  /// Supplying this value wins over [popoverStyle]. Omit it to use
  /// [LinagoraSidebarConfirmPopoverStyle.width].
  final double width;

  // Retain whether [width] was supplied so an explicit [defaultWidth] still
  // overrides a custom [popoverStyle] width.
  final bool _hasExplicitWidth;
  final double? maxHeight;

  /// Select [LinagoraSidebarConfirmButtonVariant.destructive] explicitly when
  /// the red semantic treatment is desired. The default is app-primary blue.
  final LinagoraSidebarConfirmButtonVariant confirmButtonVariant;

  /// Legacy shared sidebar palette override.
  final LinagoraSidebarStyle? style;

  /// Reusable card, button, typography and shadow tokens for this popover.
  final LinagoraSidebarConfirmPopoverStyle? popoverStyle;

  @override
  Widget build(BuildContext context) {
    final sidebar = style ?? LinagoraSidebarStyle.of(context);
    final popoverStyle =
        this.popoverStyle ?? const LinagoraSidebarConfirmPopoverStyle();
    final textThemeExtension = LinagoraTextThemeExtension.material();
    final colors = LinagoraSysColors.material();
    final isDark = sidebar.brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final arrowSide = isRtl
        ? LinagoraSidebarPopoverArrowSide.end
        : LinagoraSidebarPopoverArrowSide.start;
    final shape = LinagoraSidebarPopoverShape(
      arrowSide: arrowSide,
      arrowSize: popoverStyle.arrowSize,
      arrowOffset: popoverStyle.arrowOffset,
      borderRadius: popoverStyle.cardBorderRadius,
    );
    final cardWidth = _hasExplicitWidth ? width : popoverStyle.width;
    final effectiveWidth = cardWidth + popoverStyle.arrowSize;
    final foreground =
        popoverStyle.foregroundColor ??
        (isDark ? colors.onSurfaceDark : colors.onSurface);
    final cancelBackground =
        popoverStyle.cancelBackgroundColor ??
        (isDark ? colors.surfaceVariantDark : colors.surface);
    final cancelForeground = popoverStyle.cancelForegroundColor ?? foreground;
    final confirmForeground =
        popoverStyle.confirmForegroundColor ??
        sidebar.resolvedConfirmForeground;
    final confirmBackground = _confirmBackground(sidebar, popoverStyle);
    final buttonTextStyle =
        popoverStyle.buttonTextStyle ??
        textThemeExtension.bodyMedium3.copyWith(
          fontSize: 13,
          height: 16 / 13,
          letterSpacing: 0,
        );
    // The arrow occupies the directional start edge (left in LTR, right in
    // RTL), so only that side needs an additional inset before content begins.
    final startPadding =
        popoverStyle.horizontalContentInset + popoverStyle.arrowSize;
    final endPadding = popoverStyle.horizontalContentInset;
    final actionsOffset =
        popoverStyle.horizontalContentInset - popoverStyle.actionsEndInset;

    return SizedBox(
      width: effectiveWidth,
      child: CustomPaint(
        painter: _LinagoraSidebarConfirmPopoverPainter(
          shape: shape,
          backgroundColor:
              popoverStyle.backgroundColor ?? sidebar.resolvedPopoverBackground,
          shadow: popoverStyle.resolveShadow(sidebar),
        ),
        child: ClipPath(
          clipper: shape,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? double.infinity,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                startPadding,
                popoverStyle.topContentInset,
                endPadding,
                popoverStyle.bottomContentInset,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style:
                              popoverStyle.titleTextStyle ??
                              textThemeExtension.bodyLargeBold.copyWith(
                                color: foreground,
                                letterSpacing: 0,
                              ),
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: closeSemanticLabel,
                        child: Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkResponse(
                            onTap: onCancel,
                            containedInkWell: true,
                            highlightShape: BoxShape.circle,
                            radius: popoverStyle.closeButtonSize / 2,
                            customBorder: const CircleBorder(),
                            child: SizedBox.square(
                              dimension: popoverStyle.closeButtonSize,
                              child: Center(
                                child: IconTheme.merge(
                                  data: IconThemeData(
                                    color:
                                        popoverStyle.closeIconColor ??
                                        sidebar.trailingForeground,
                                    size: popoverStyle.closeIconSize,
                                  ),
                                  child: closeIcon ?? Icon(
                                    Icons.close,
                                    size: popoverStyle.closeIconSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: popoverStyle.titleBodySpacing),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        message,
                        style:
                            popoverStyle.bodyTextStyle ??
                            textThemeExtension.bodyMedium3.copyWith(
                              color: foreground,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: popoverStyle.bodyActionsSpacing),
                  Transform.translate(
                    offset: Offset(isRtl ? -actionsOffset : actionsOffset, 0),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: popoverStyle.actionsSpacing,
                      runSpacing: popoverStyle.actionsSpacing,
                      children: [
                        LinagoraButton(
                          label: cancelLabel,
                          onPressed: onCancel,
                          size: LinagoraButtonSize.xs,
                          style: _buttonStyle(
                            popoverStyle,
                            foreground: cancelForeground,
                            background: cancelBackground,
                            textStyle: buttonTextStyle,
                          ),
                        ),
                        LinagoraButton(
                          label: confirmLabel,
                          onPressed: onConfirm,
                          size: LinagoraButtonSize.xs,
                          style: _buttonStyle(
                            popoverStyle,
                            foreground: confirmForeground,
                            background: confirmBackground,
                            textStyle: buttonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _confirmBackground(
    LinagoraSidebarStyle sidebar,
    LinagoraSidebarConfirmPopoverStyle popoverStyle,
  ) {
    return switch (confirmButtonVariant) {
      LinagoraSidebarConfirmButtonVariant.primary =>
        popoverStyle.primaryConfirmBackgroundColor ?? sidebar.activeForeground,
      LinagoraSidebarConfirmButtonVariant.destructive =>
        popoverStyle.destructiveConfirmBackgroundColor ??
            sidebar.resolvedDestructiveBackground,
    };
  }

  ButtonStyle _buttonStyle(
    LinagoraSidebarConfirmPopoverStyle popoverStyle, {
    required Color foreground,
    required Color background,
    required TextStyle textStyle,
  }) => ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(foreground),
    backgroundColor: WidgetStatePropertyAll(background),
    minimumSize: WidgetStatePropertyAll(Size(0, popoverStyle.buttonHeight)),
    padding: WidgetStatePropertyAll(
      EdgeInsetsDirectional.symmetric(
        horizontal: popoverStyle.buttonHorizontalPadding,
      ),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(popoverStyle.buttonBorderRadius),
        ),
      ),
    ),
    textStyle: WidgetStatePropertyAll(textStyle),
  );
}

class _LinagoraSidebarConfirmPopoverPainter extends CustomPainter {
  const _LinagoraSidebarConfirmPopoverPainter({
    required this.shape,
    required this.backgroundColor,
    required this.shadow,
  });

  final LinagoraSidebarPopoverShape shape;
  final Color backgroundColor;
  final BoxShadow shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final path = shape.getClip(size);
    // Match Flutter's normal golden-test convention. The stable card shape and
    // shadow token are covered by tests, while the platform-specific blur is
    // omitted only when a test explicitly sets [debugDisableShadows].
    if (!debugDisableShadows) {
      final shadowPaint = Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(shadow.blurStyle, shadow.blurSigma);
      canvas.save();
      canvas.translate(shadow.offset.dx, shadow.offset.dy);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();
    }
    canvas.drawPath(path, Paint()..color = backgroundColor);
  }

  @override
  bool shouldRepaint(covariant _LinagoraSidebarConfirmPopoverPainter old) =>
      old.shape != shape ||
      old.backgroundColor != backgroundColor ||
      old.shadow != shadow;
}
