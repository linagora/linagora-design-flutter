import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// A compact calendar date marker for event-related content.
///
/// [month] is the already-localized three-character month label to display.
/// The widget uppercases that label to preserve the Figma component's
/// presentation. [day] is a one- or two-digit calendar day from 1 through 31.
class LinagoraEventDateIcon extends StatelessWidget {
  /// The Figma component's default square dimension.
  static const double defaultSize = 50;

  /// The Figma `Primary/main` value used by the calendar header.
  static const Color defaultHeaderColor = Color(0xFFF67E35);

  static const Color defaultBackgroundColor = Color(0xFFFFFFFF);
  static const Color defaultMonthTextColor = Color(0xFFFFFFFF);
  static const Color defaultDayTextColor = Color(0xFF27292D);

  /// The exact shadow specified by the Figma `date-icon` component at 50px.
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color(0x26000000),
    offset: Offset(0, 0.98),
    blurRadius: 1.471,
  );

  final String month;
  final String day;

  /// The square dimension of the icon. All Figma geometry scales with it.
  final double size;

  final Color headerColor;
  final Color backgroundColor;
  final Color monthTextColor;
  final Color dayTextColor;

  /// Set to null when the date icon must sit flat against its surface.
  ///
  /// A supplied shadow uses the Figma 50px coordinate space and scales with
  /// [size].
  final BoxShadow? shadow;

  /// An optional accessible description. Defaults to the displayed date.
  final String? semanticLabel;

  LinagoraEventDateIcon({
    super.key,
    required this.month,
    required this.day,
    this.size = defaultSize,
    this.headerColor = defaultHeaderColor,
    this.backgroundColor = defaultBackgroundColor,
    this.monthTextColor = defaultMonthTextColor,
    this.dayTextColor = defaultDayTextColor,
    this.shadow = defaultShadow,
    this.semanticLabel,
  }) {
    final datePartsError = validateDateParts(month: month, day: day);
    if (datePartsError != null) {
      throw ArgumentError.value(
        <String, String>{'month': month, 'day': day},
        'dateParts',
        datePartsError,
      );
    }
    if (!size.isFinite || size <= 0) {
      throw ArgumentError.value(
        size,
        'size',
        'Size must be finite and positive',
      );
    }
  }

  /// Returns a user-facing validation message when [month] or [day] cannot
  /// fit the Figma date-icon layout; otherwise returns null.
  static String? validateDateParts({
    required String month,
    required String day,
  }) {
    if (month.length != 3) {
      return 'Month must contain exactly three characters.';
    }

    final dayValue = int.tryParse(day);
    if (dayValue == null || dayValue < 1 || dayValue > 31 || day.length > 2) {
      return 'Day must be a number from 1 to 31.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scale = size / defaultSize;
    final radius = 11.765 * scale;
    final scaledShadow = shadow?.scale(scale);

    return Semantics(
      label: semanticLabel ?? '$month $day',
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: scaledShadow == null ? null : [scaledShadow],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: size * 0.3137,
                    child: ColoredBox(color: headerColor),
                  ),
                  Positioned(
                    top: size * 0.0588,
                    left: size * 0.3137,
                    right: size * 0.2941,
                    bottom: size * 0.7059,
                    child: Center(
                      child: Text(
                        month.toUpperCase(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: LinagoraTextTheme.material().labelSmall!
                            .copyWith(
                              fontSize: 8.824 * scale,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              letterSpacing: 0,
                              color: monthTextColor,
                            ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size * 0.2941,
                    left: size * 0.2157,
                    right: size * 0.2043,
                    bottom: size * 0.0459,
                    child: Center(
                      child: Text(
                        day,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: LinagoraTextTheme.material().headlineMedium!
                            .copyWith(
                              fontSize: 27.451 * scale,
                              fontWeight: FontWeight.w300,
                              height: 1,
                              letterSpacing: 0,
                              color: dayTextColor,
                            ),
                      ),
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
}
