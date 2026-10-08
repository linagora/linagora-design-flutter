import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_layout.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_style.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// Content of the "Attaching file" dialog: title, description, a list of
/// transfer rows and a Cancel action.
///
/// Wrap it in [LinagoraFileTransferSurface] (or any route surface you like).
/// Rows are built by the caller via [itemBuilder], typically one
/// `LinagoraFileTransferRow` each, so per-row state stays in the app.
class LinagoraFileTransferDialog extends StatelessWidget {
  static const Key closeButtonKey = ValueKey('linagora_file_transfer_close');
  static const Key cancelAllButtonKey =
      ValueKey('linagora_file_transfer_cancel_all');

  final String title;

  /// Rendered over [LinagoraFileTransferStyle.bodyTextStyle]; use child spans
  /// with `style.emphasisTextStyle` to emphasise a run.
  final InlineSpan description;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final String cancelLabel;

  /// Header close. Null hides the button.
  final VoidCallback? onClose;
  final String? closeTooltip;
  final VoidCallback? onCancelAll;

  /// False hides the footer Cancel but keeps its height, so the dialog does
  /// not jump when the last transfer settles.
  final bool showCancelAll;
  final LinagoraFileTransferLayout layout;

  /// Defaults to the Figma tokens of [layout].
  final LinagoraFileTransferStyle? style;

  const LinagoraFileTransferDialog({
    super.key,
    required this.title,
    required this.description,
    required this.itemCount,
    required this.itemBuilder,
    required this.cancelLabel,
    this.onClose,
    this.closeTooltip,
    this.onCancelAll,
    this.showCancelAll = true,
    this.layout = LinagoraFileTransferLayout.wide,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraFileTransferStyle.forLayout(layout);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(tokens),
        Padding(
          padding: tokens.descriptionPadding,
          child: Text.rich(
            TextSpan(style: tokens.bodyTextStyle, children: [description]),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: tokens.maxListHeight),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ),
        _buildFooter(tokens),
      ],
    );
  }

  Widget _buildHeader(LinagoraFileTransferStyle tokens) => Padding(
        padding: tokens.headerPadding,
        child: Row(
          children: [
            Expanded(child: Text(title, style: tokens.titleTextStyle)),
            SizedBox.square(
              dimension: tokens.closeButtonSize,
              child: onClose == null
                  ? null
                  : IconButton(
                      key: closeButtonKey,
                      tooltip: closeTooltip,
                      onPressed: onClose,
                      padding: EdgeInsets.zero,
                      icon: SvgPicture(
                        const AssetBytesLoader(
                          LinagoraDesignImages.svgBytesClose,
                        ),
                        width: tokens.headerCloseIconSize,
                        height: tokens.headerCloseIconSize,
                      ),
                    ),
            ),
          ],
        ),
      );

  Widget _buildFooter(LinagoraFileTransferStyle tokens) => Align(
        alignment: layout == LinagoraFileTransferLayout.wide
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Padding(
          padding: tokens.headerPadding,
          child: Opacity(
            opacity: showCancelAll ? 1 : 0,
            child: IgnorePointer(
              ignoring: !showCancelAll,
              child: TextButton(
                key: cancelAllButtonKey,
                onPressed: onCancelAll,
                style: TextButton.styleFrom(
                  padding: tokens.cancelPadding,
                  shape: const StadiumBorder(),
                  textStyle: tokens.cancelTextStyle,
                  foregroundColor: tokens.cancelTextStyle.color,
                ),
                child: Text(cancelLabel),
              ),
            ),
          ),
        ),
      );
}
