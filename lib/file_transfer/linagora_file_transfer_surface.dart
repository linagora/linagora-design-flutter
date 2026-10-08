import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_layout.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_style.dart';

/// The card behind a file transfer dialog: a centred, width-capped card for
/// [LinagoraFileTransferLayout.wide], a bottom sheet for
/// [LinagoraFileTransferLayout.compact].
///
/// Route-agnostic: put it inside `showDialog`, `Get.dialog` or an overlay.
class LinagoraFileTransferSurface extends StatelessWidget {
  final Widget child;
  final LinagoraFileTransferLayout layout;

  /// Defaults to the Figma tokens of [layout].
  final LinagoraFileTransferStyle? style;

  /// Space kept around the wide card on small screens.
  final EdgeInsetsGeometry insetPadding;

  const LinagoraFileTransferSurface({
    super.key,
    required this.child,
    this.layout = LinagoraFileTransferLayout.wide,
    this.style,
    this.insetPadding =
        const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraFileTransferStyle.forLayout(layout);
    return layout == LinagoraFileTransferLayout.wide
        ? _buildWide(tokens)
        : _buildCompact(tokens);
  }

  Widget _buildWide(LinagoraFileTransferStyle tokens) => Center(
        child: Padding(
          padding: insetPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.maxWidth),
            child: Material(
              type: MaterialType.transparency,
              child: DecoratedBox(
                decoration: _decoration(
                  tokens,
                  BorderRadius.circular(tokens.surfaceRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(tokens.surfaceRadius),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildCompact(LinagoraFileTransferStyle tokens) {
    final radius = BorderRadius.vertical(
      top: Radius.circular(tokens.surfaceRadius),
    );
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: _decoration(tokens, radius),
          child: ClipRRect(
            borderRadius: radius,
            child: SizedBox(
              width: double.infinity,
              child: SafeArea(top: false, child: child),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(
    LinagoraFileTransferStyle tokens,
    BorderRadius radius,
  ) =>
      BoxDecoration(
        color: tokens.surfaceColor,
        borderRadius: radius,
        boxShadow: tokens.surfaceShadow,
      );
}
