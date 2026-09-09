import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// The activity that determines an [EventActivityBadge]'s default colour.
///
/// The text remains caller-owned so products can localise it and support
/// activity messages beyond the states represented in the Event Card design.
enum EventActivityBadgeState {
  created,
  reminder,
  updated,
  accepted,
  canceled,
  notInvited,
}

/// A compact, wrapping status message for a calendar event.
///
/// [activity] is required and is shown in regular weight. Provide [actorName]
/// when the message begins with a person whose name should be bold. The widget
/// separates the actor and activity with a 4px auto-layout gap.
///
/// The badge hugs short content and wraps when an ancestor supplies a finite
/// width. Its default background follows [state]; [backgroundColor] and
/// [foregroundColor] are optional product-specific overrides.
class EventActivityBadge extends StatelessWidget {
  /// Default light success colour.
  static const Color successBackground = Color(0xFFB9F6CA);

  /// Default foreground colour at 90% opacity.
  static const Color defaultForeground = Color(0xE6424244);

  final EventActivityBadgeState state;
  final String activity;
  final String? actorName;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const EventActivityBadge({
    super.key,
    required this.activity,
    this.state = EventActivityBadgeState.created,
    this.actorName,
    this.backgroundColor,
    this.foregroundColor,
  });

  bool get _hasActor => actorName != null && actorName!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final textStyle = _textStyle();
    final actorStyle = textStyle.copyWith(fontWeight: FontWeight.w600);

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? _backgroundFor(state),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Text.rich(
        TextSpan(children: _textSpans(actorStyle)),
        style: textStyle,
      ),
    );
  }

  List<InlineSpan> _textSpans(TextStyle actorStyle) {
    if (!_hasActor) return [TextSpan(text: activity)];

    return [
      TextSpan(text: actorName, style: actorStyle),
      const WidgetSpan(child: SizedBox(width: 4)),
      TextSpan(text: _activityWithoutLeadingWhitespace),
    ];
  }

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 2,
  );

  TextStyle _textStyle() {
    return LinagoraTextTheme.material().bodyMedium!.copyWith(
      color: foregroundColor ?? defaultForeground,
      fontWeight: FontWeight.w400,
      height: 18.4 / 14,
      letterSpacing: 0.25,
    );
  }

  Color _backgroundFor(EventActivityBadgeState state) {
    return switch (state) {
      EventActivityBadgeState.created ||
      EventActivityBadgeState.reminder ||
      EventActivityBadgeState.updated =>
        LinagoraSysColors.material().primaryContainer,
      EventActivityBadgeState.accepted => successBackground,
      EventActivityBadgeState.canceled || EventActivityBadgeState.notInvited =>
        LinagoraRefColors.material().error[90]!,
    };
  }

  String get _activityWithoutLeadingWhitespace =>
      _startsWithWhitespace(activity) ? activity.substring(1) : activity;

  static bool _startsWithWhitespace(String value) =>
      value.isNotEmpty && RegExp(r'\s').hasMatch(value.substring(0, 1));
}
