import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_callback_utils.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Semantic colour treatments for a storage quota indicator.
///
/// The host application chooses the state from its own quota policy; this
/// component does not infer a warning threshold from [LinagoraSidebarStorage.progress].
enum LinagoraSidebarStorageProgressState { normal, warning, full }

/// Semantic colour treatments for the secondary storage [status].
enum LinagoraSidebarStorageStatusState { normal, warning, error }

/// Reports activation of a storage trailing action.
typedef OnLinagoraSidebarStorageTrailingActionPressed =
    FutureOr<void> Function(LinagoraSidebarStorageActionDetails details);

/// Storage data supplied to a trailing-action callback.
class LinagoraSidebarStorageActionDetails {
  const LinagoraSidebarStorageActionDetails({
    required this.label,
    required this.progress,
    required this.isLoading,
    required this.progressState,
    required this.statusState,
  });

  final String label;
  final double progress;
  final bool isLoading;
  final LinagoraSidebarStorageProgressState progressState;
  final LinagoraSidebarStorageStatusState statusState;
}

/// Displays storage quota information at the bottom of a sidebar.
///
/// Formatting and localisation belong to the host application. This widget
/// lays out already-formatted label and status content, leaving quota policy,
/// trailing-action behaviour, and any product UI outside the design system.
/// Compose it with [LinagoraSidebarVersion] when a footer also needs a
/// build/version line.
class LinagoraSidebarStorage extends StatelessWidget {
  /// Size of the storage glyph from the sidebar specification.
  static const double iconSize = 24;

  /// Space between the cloud glyph and [label].
  static const double labelSpacing = 8;

  /// Vertical rhythm between storage rows.
  static const double contentSpacing = 12;

  /// Gap between the title and a trailing visual or action.
  static const double trailingSpacing = 8;

  /// Touch target reserved for an interactive trailing action.
  static const double trailingActionSize = 24;

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
    this.semanticLabel,
    this.trailing,
    this.onTrailingActionPressed,
    this.trailingSemanticLabel,
    this.isLoading = false,
    this.status,
    this.statusContent,
    this.statusState = LinagoraSidebarStorageStatusState.normal,
    this.statusColor,
    this.statusSemanticLabel,
    this.style,
  }) : assert(
         onTrailingActionPressed == null || trailing != null,
         'A storage trailing callback needs trailing content',
       ),
       assert(
         onTrailingActionPressed == null || trailingSemanticLabel != null,
         'An interactive storage trailing action needs a semanticLabel',
       );

  /// Storage title, for example `Storage`.
  final String label;

  /// Used storage proportion. Values outside 0..1, and a `NaN` from an unknown
  /// quota, are normalised before they reach [LinearProgressIndicator].
  final double progress;

  /// Legacy caller-formatted available-space message, for example
  /// `497.28 GB free`.
  ///
  /// [status] takes precedence and supports two lines. This stays available
  /// for source compatibility with earlier releases.
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

  /// Accessible replacement name for the storage block.
  ///
  /// Use this when visible strings alone do not describe the quota state.
  final String? semanticLabel;

  /// Generic visual content after the storage title.
  ///
  /// Pair it with [onTrailingActionPressed] to make it an independent action.
  final Widget? trailing;

  /// Async-capable callback for the trailing action.
  final OnLinagoraSidebarStorageTrailingActionPressed? onTrailingActionPressed;

  /// Localized accessible name required for an interactive [trailing] action.
  final String? trailingSemanticLabel;

  /// Uses an indeterminate progress bar while the product loads quota data.
  final bool isLoading;

  /// Caller-formatted secondary status, rendered beneath the progress bar.
  ///
  /// The status can use two lines; [statusContent] takes precedence when both
  /// are supplied. [caption] remains its compatibility fallback.
  final String? status;

  /// Generic secondary status content, such as a product-owned status chip.
  final Widget? statusContent;

  /// Semantic visual treatment for [status] or [statusContent].
  final LinagoraSidebarStorageStatusState statusState;

  /// Overrides the colour selected by [statusState].
  final Color? statusColor;

  /// Accessible status text, including a meaning normally carried by colour.
  final String? statusSemanticLabel;

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
          value: isLoading ? null : _resolvedProgress,
          minHeight: style.progressHeight,
          color: progressColor ?? _progressColor(style),
          backgroundColor:
              progressTrackColor ?? style.resolvedProgressTrackColor,
          borderRadius: BorderRadius.circular(style.progressHeight / 2),
        ),
        if (_hasStatus) ...[
          const SizedBox(height: contentSpacing),
          _secondaryContent(style, foreground),
        ],
      ],
    );

    final tap = onTap;
    final needsMaterial = tap != null || onTrailingActionPressed != null;
    final inkContent = tap == null
        ? content
        : InkWell(onTap: tap, child: content);
    final body = needsMaterial
        ? Material(color: Colors.transparent, child: inkContent)
        : inkContent;

    if (tap == null && semanticLabel == null) return body;

    return Semantics(
      // With no explicit label, the block's [Text]s already name it. An
      // explicit label replaces that assembled name rather than repeating it.
      button: tap != null,
      label: semanticLabel,
      container: semanticLabel != null,
      explicitChildNodes: semanticLabel != null,
      child: body,
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
      if (trailing != null) ...[
        const SizedBox(width: trailingSpacing),
        _trailingWidget(iconForeground),
      ],
    ],
  );

  Widget _trailingWidget(Color foreground) {
    final visual = SizedBox.square(
      dimension: trailingActionSize,
      child: Center(
        child: IconTheme.merge(
          data: IconThemeData(color: foreground, size: iconSize),
          child: trailing!,
        ),
      ),
    );
    final callback = onTrailingActionPressed;
    if (callback == null) return visual;

    return Semantics(
      button: true,
      label: trailingSemanticLabel,
      child: InkWell(
        onTap: () => unawaited(
          runLinagoraSidebarCallback(
            () => callback(_trailingActionDetails),
            callbackName: 'LinagoraSidebarStorage.onTrailingActionPressed',
          ),
        ),
        borderRadius: BorderRadius.circular(trailingActionSize / 2),
        child: ExcludeSemantics(child: visual),
      ),
    );
  }

  Widget _secondaryContent(LinagoraSidebarStyle style, Color foreground) {
    if (statusContent != null || status != null) {
      return _statusWidget(style, foreground);
    }

    return _legacyCaptionWidget(foreground);
  }

  Widget _legacyCaptionWidget(Color foreground) => _withStatusSemantics(
    Text(
      caption!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _captionStyle(foreground),
    ),
  );

  Widget _statusWidget(LinagoraSidebarStyle style, Color foreground) {
    final textStyle = _captionStyle(
      statusColor ?? _statusColor(style, foreground),
    );
    final content = statusContent;
    final status = content == null
        ? Text(
            _status!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          )
        : DefaultTextStyle.merge(style: textStyle, child: content);
    return _withStatusSemantics(status);
  }

  Widget _withStatusSemantics(Widget content) {
    final semanticLabel = statusSemanticLabel;
    if (semanticLabel == null) return content;
    return Semantics(
      label: semanticLabel,
      container: true,
      excludeSemantics: true,
      child: content,
    );
  }

  bool get _hasStatus =>
      statusContent != null || status != null || caption != null;

  String? get _status => status ?? caption;

  LinagoraSidebarStorageActionDetails get _trailingActionDetails =>
      LinagoraSidebarStorageActionDetails(
        label: label,
        progress: _resolvedProgress,
        isLoading: isLoading,
        progressState: progressState,
        statusState: statusState,
      );

  TextStyle? _captionStyle(Color foreground) =>
      LinagoraTextTheme.material().bodySmall?.copyWith(
        color: foreground,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 15.76 / 12,
        letterSpacing: 0.5,
      );

  Color _statusColor(LinagoraSidebarStyle style, Color foreground) =>
      switch (statusState) {
        LinagoraSidebarStorageStatusState.normal => foreground,
        LinagoraSidebarStorageStatusState.warning =>
          style.resolvedProgressWarningColor,
        LinagoraSidebarStorageStatusState.error =>
          style.resolvedProgressFullColor,
      };

  Color _progressColor(LinagoraSidebarStyle style) => switch (progressState) {
    LinagoraSidebarStorageProgressState.normal => style.resolvedProgressColor,
    LinagoraSidebarStorageProgressState.warning =>
      style.resolvedProgressWarningColor,
    LinagoraSidebarStorageProgressState.full => style.resolvedProgressFullColor,
  };
}
