import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_layout.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_leading.dart';
import 'package:linagora_design_flutter/file_transfer/linagora_file_transfer_style.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// One file in a transfer: name chip, status label, progress bar and a cancel
/// button.
///
/// [wide] puts the bar inline; [compact] puts it on its own line underneath.
/// The widget is stateless: the caller owns [progress] and the label text.
class LinagoraFileTransferRow extends StatelessWidget {
  static const Key cancelButtonKey = ValueKey('linagora_file_transfer_cancel');

  final String fileName;

  /// Already formatted by the caller: a size while running, a word once done.
  final String statusLabel;

  /// 0..1, or null for an indeterminate bar. Out-of-range values are clamped.
  final double? progress;

  /// Null removes the cancel button but keeps its slot, so the row keeps its
  /// width when a transfer settles.
  final VoidCallback? onCancel;
  final String? cancelTooltip;
  final Widget leading;
  final LinagoraFileTransferLayout layout;

  /// Defaults to the Figma tokens of [layout].
  final LinagoraFileTransferStyle? style;

  const LinagoraFileTransferRow({
    super.key,
    required this.fileName,
    required this.statusLabel,
    this.progress,
    this.onCancel,
    this.cancelTooltip,
    this.leading = const LinagoraFileTransferLeading(),
    this.layout = LinagoraFileTransferLayout.wide,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraFileTransferStyle.forLayout(layout);
    final wide = layout == LinagoraFileTransferLayout.wide;
    final topLine = Row(
      children: [
        _buildChip(tokens),
        if (wide) SizedBox(width: tokens.itemGap) else const Spacer(),
        SizedBox(
          width: tokens.statusLabelWidth,
          child: Text(
            statusLabel,
            textAlign: wide ? TextAlign.start : TextAlign.end,
            style: tokens.statusTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        if (wide) ...[
          SizedBox(width: tokens.itemGap),
          Expanded(child: _buildBar(tokens)),
        ],
        _buildCancel(tokens),
      ],
    );
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: '$fileName, $statusLabel',
      child: Padding(
        padding: tokens.rowPadding,
        child: wide
            ? topLine
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  topLine,
                  SizedBox(height: tokens.compactBarGap),
                  Padding(
                    padding: tokens.compactBarPadding,
                    child: _buildBar(tokens),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildChip(LinagoraFileTransferStyle tokens) => SizedBox(
        width: tokens.chipWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.chipBackgroundColor,
            borderRadius: BorderRadius.circular(tokens.chipRadius),
            border: Border.all(color: tokens.chipBorderColor),
          ),
          child: Padding(
            padding: tokens.chipPadding,
            child: Row(
              children: [
                leading,
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.fileNameTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildBar(LinagoraFileTransferStyle tokens) {
    final radius = BorderRadius.circular(tokens.barRadius);
    final value = progress;
    if (value == null) {
      return LinearProgressIndicator(
        minHeight: tokens.barHeight,
        borderRadius: radius,
        backgroundColor: tokens.barTrackColor,
        color: tokens.barColor,
      );
    }
    final target = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: target),
      duration: tokens.progressAnimationDuration,
      builder: (_, animated, __) => LinearProgressIndicator(
        value: animated,
        minHeight: tokens.barHeight,
        borderRadius: radius,
        backgroundColor: tokens.barTrackColor,
        color: tokens.barColor,
      ),
    );
  }

  Widget _buildCancel(LinagoraFileTransferStyle tokens) => SizedBox.square(
        dimension: tokens.closeButtonSize,
        child: onCancel == null
            ? null
            : IconButton(
                key: cancelButtonKey,
                tooltip: cancelTooltip,
                onPressed: onCancel,
                padding: EdgeInsets.zero,
                icon: SvgPicture(
                  const AssetBytesLoader(LinagoraDesignImages.svgBytesClose),
                  width: tokens.rowCloseIconSize,
                  height: tokens.rowCloseIconSize,
                  colorFilter: ColorFilter.mode(
                    tokens.closeIconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      );
}
