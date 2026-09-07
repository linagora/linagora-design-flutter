import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Weight and colour treatments for a piece of event row content.
enum LinagoraEventInfoEmphasis {
  /// w400 at 90% ink. The default for plain values.
  normal,

  /// w600 at 90% ink. For the value a reader scans for.
  strong,

  /// w400 at 64% ink. For a value secondary to the one beside it.
  muted,
}

/// Ink colours shared by the event info rows.
abstract final class LinagoraEventInfoColors {
  /// Primary content.
  static const Color content = Color(0xE6424244);

  /// Prefix labels and secondary content.
  static const Color secondary = Color(0xA3424244);

  /// Inline links inside a content run.
  ///
  /// Deliberately distinct from [buttonLabel]; the design uses two blues.
  static const Color link = Color(0xFF0A84FF);

  /// Text button labels such as `Propose a new time`.
  static const Color buttonLabel = Color(0xFF0C8CE9);
}

/// The prefix label of a [LinagoraEventInfoRow] — `When`, `Where`, `Who`.
///
/// Callers own localisation; the text is never transformed.
class LinagoraEventInfoLabel extends StatelessWidget {
  static const double lineHeight = 15.8;

  final String text;
  final Color color;

  /// Merged over the resolved treatment.
  final TextStyle? style;

  final int? maxLines;
  final TextOverflow overflow;

  const LinagoraEventInfoLabel(
    this.text, {
    super.key,
    this.color = LinagoraEventInfoColors.secondary,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  /// The label treatment, for callers building their own span or widget.
  static TextStyle textStyle({
    Color color = LinagoraEventInfoColors.secondary,
  }) {
    return LinagoraTextTheme.material().labelMedium!.copyWith(
      fontWeight: FontWeight.w500,
      height: lineHeight / 12,
      letterSpacing: 0.5,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = textStyle(color: color);
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: style == null ? resolved : resolved.merge(style),
    );
  }
}

/// A single value inside an event info row's content run.
class LinagoraEventInfoText extends StatelessWidget {
  static const double lineHeight = 18.4;

  final String text;
  final LinagoraEventInfoEmphasis emphasis;

  /// Overrides the colour [emphasis] would pick.
  final Color? color;

  /// Merged over the resolved treatment.
  final TextStyle? style;

  final int? maxLines;
  final TextOverflow overflow;

  const LinagoraEventInfoText(
    this.text, {
    super.key,
    this.emphasis = LinagoraEventInfoEmphasis.normal,
    this.color,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  /// The body treatment for [emphasis].
  static TextStyle textStyle({
    LinagoraEventInfoEmphasis emphasis = LinagoraEventInfoEmphasis.normal,
    Color? color,
  }) {
    return LinagoraTextTheme.material().bodyMedium!.copyWith(
      fontWeight: _weightFor(emphasis),
      height: lineHeight / 14,
      letterSpacing: 0.25,
      color: color ?? _colorFor(emphasis),
    );
  }

  static FontWeight _weightFor(LinagoraEventInfoEmphasis emphasis) {
    return switch (emphasis) {
      LinagoraEventInfoEmphasis.strong => FontWeight.w600,
      LinagoraEventInfoEmphasis.normal ||
      LinagoraEventInfoEmphasis.muted => FontWeight.w400,
    };
  }

  static Color _colorFor(LinagoraEventInfoEmphasis emphasis) {
    return switch (emphasis) {
      LinagoraEventInfoEmphasis.muted => LinagoraEventInfoColors.secondary,
      LinagoraEventInfoEmphasis.normal ||
      LinagoraEventInfoEmphasis.strong => LinagoraEventInfoColors.content,
    };
  }

  @override
  Widget build(BuildContext context) {
    final resolved = textStyle(emphasis: emphasis, color: color);
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: style == null ? resolved : resolved.merge(style),
    );
  }
}

/// Row content that mixes emphases inside one wrapping paragraph.
///
/// For parts that stay independent, pass separate [LinagoraEventInfoText]
/// widgets to [LinagoraEventInfoRun] instead.
class LinagoraEventInfoRichText extends StatelessWidget {
  final List<InlineSpan> spans;
  final LinagoraEventInfoEmphasis emphasis;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign? textAlign;

  const LinagoraEventInfoRichText({
    super.key,
    required this.spans,
    this.emphasis = LinagoraEventInfoEmphasis.normal,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign,
  });

  /// Builds a span carrying the [emphasis] treatment, for composing [spans].
  static TextSpan span(
    String text, {
    LinagoraEventInfoEmphasis emphasis = LinagoraEventInfoEmphasis.normal,
    Color? color,
    TextStyle? style,
    GestureRecognizer? recognizer,
  }) {
    final resolved = LinagoraEventInfoText.textStyle(
      emphasis: emphasis,
      color: color,
    );
    return TextSpan(
      text: text,
      style: style == null ? resolved : resolved.merge(style),
      recognizer: recognizer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = LinagoraEventInfoText.textStyle(emphasis: emphasis);
    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: style == null ? resolved : resolved.merge(style),
    );
  }
}

/// A borderless action that sits inside a content run, such as `See in Map`.
///
/// Built on [LinagoraButton] to keep hover, focus, and keyboard activation,
/// but stripped of padding and minimum height so it aligns with the text it
/// follows.
class LinagoraEventInfoLink extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  /// Used when [iconWidget] is null.
  final IconData? icon;

  /// Replaces [icon] when both are supplied.
  final Widget? iconWidget;

  final double iconSpacing;
  final Color color;

  /// Merged over the resolved treatment.
  final TextStyle? textStyle;

  final String? tooltip;

  const LinagoraEventInfoLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.iconSpacing = 4,
    this.color = LinagoraEventInfoColors.link,
    this.textStyle,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = LinagoraEventInfoText.textStyle(
      color: color,
    ).copyWith(fontWeight: FontWeight.w500);

    return LinagoraButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      iconWidget: iconWidget,
      iconSpacing: iconSpacing,
      variant: LinagoraButtonVariant.text,
      padding: EdgeInsets.zero,
      minimumHeight: 0,
      foregroundColor: color,
      iconColor: color,
      textStyle: textStyle == null ? resolved : resolved.merge(textStyle),
      tooltip: tooltip,
    );
  }
}
