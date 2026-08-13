import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Semantic colour treatments for a storage quota indicator.
///
/// The host application chooses the state from its own quota policy; this
/// component does not infer a warning threshold from [LinagoraSidebarStorage.progress].
enum LinagoraSidebarStorageProgressState { normal, warning, full }

/// Displays storage quota information at the bottom of a sidebar.
///
/// Formatting and localisation belong to the host application. This widget
/// only lays out the already-formatted [label] and [caption]. Compose it with
/// [LinagoraSidebarVersion] when a footer also needs a build/version line.
class LinagoraSidebarStorage extends StatelessWidget {
  /// Size of the storage glyph from the sidebar specification.
  static const double iconSize = 24;

  /// Space between the cloud glyph and [label].
  static const double labelSpacing = 8;

  /// Vertical rhythm between storage rows.
  static const double contentSpacing = 12;

  const LinagoraSidebarStorage({
    super.key,
    required this.label,
    required this.progress,
    this.caption,
    this.icon = Icons.cloud_outlined,
    this.iconWidget,
    this.progressState = LinagoraSidebarStorageProgressState.normal,
    this.progressColor,
    this.progressTrackColor,
    this.onTap,
    this.style,
  });

  /// Storage title, for example `Storage`.
  final String label;

  /// Used storage proportion. Values outside 0..1, and a `NaN` from an unknown
  /// quota, are normalised before they reach [LinearProgressIndicator].
  final double progress;

  /// Caller-formatted available-space message, for example `497.28 GB free`.
  final String? caption;

  final IconData icon;

  /// Replaces [icon], allowing products to provide their own cloud asset.
  final Widget? iconWidget;

  /// Visual quota state. [warning] uses yellow and [full] uses red.
  final LinagoraSidebarStorageProgressState progressState;

  /// Overrides the colour selected by [progressState].
  final Color? progressColor;

  /// Overrides the unfilled quota-bar colour.
  final Color? progressTrackColor;

  /// Makes the full block tappable when supplied.
  final VoidCallback? onTap;

  final LinagoraSidebarStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? LinagoraSidebarStyle.of(context);
    final foreground = style.resolvedStorageForeground;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(style.resolvedStorageIconForeground, foreground),
        const SizedBox(height: contentSpacing),
        LinearProgressIndicator(
          value: _resolvedProgress,
          minHeight: style.progressHeight,
          color: progressColor ?? _progressColor(style),
          backgroundColor:
              progressTrackColor ?? style.resolvedProgressTrackColor,
          borderRadius: BorderRadius.circular(style.progressHeight / 2),
        ),
        if (caption != null) ...[
          const SizedBox(height: contentSpacing),
          Text(
            caption!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionStyle(foreground),
          ),
        ],
      ],
    );

    if (onTap == null) return content;

    return Semantics(
      // Role only. The block's own [Text]s already name it, so repeating
      // [label] here announced the storage title twice.
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
  }

  /// [num.clamp] orders `NaN` above every number, so a host dividing by a zero
  /// or unknown total would otherwise paint a full — and, in [full], red — bar
  /// rather than an empty one.
  double get _resolvedProgress =>
      progress.isNaN ? 0 : progress.clamp(0, 1).toDouble();

  Widget _header(Color iconForeground, Color foreground) => Row(
    children: [
      // Sized here rather than through [IconTheme] alone: a product asset such
      // as an SVG or an image does not read the theme and would otherwise
      // render at its own size and break the footer layout.
      SizedBox.square(
        dimension: iconSize,
        child: IconTheme.merge(
          data: IconThemeData(color: iconForeground, size: iconSize),
          child: iconWidget ?? Icon(icon, color: iconForeground),
        ),
      ),
      const SizedBox(width: labelSpacing),
      Expanded(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _captionStyle(foreground),
        ),
      ),
    ],
  );

  TextStyle? _captionStyle(Color foreground) => LinagoraTextTheme.material()
      .bodySmall
      ?.copyWith(color: foreground, letterSpacing: 0.5);

  Color _progressColor(LinagoraSidebarStyle style) => switch (progressState) {
      LinagoraSidebarStorageProgressState.normal => style.resolvedProgressColor,
      LinagoraSidebarStorageProgressState.warning =>
        style.resolvedProgressWarningColor,
      LinagoraSidebarStorageProgressState.full =>
        style.resolvedProgressFullColor,
    };
}
