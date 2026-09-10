import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraEventDateIcon)
Widget linagoraEventDateIconUseCase(BuildContext context) {
  final showShadow = context.knobs.boolean(
    label: 'Show shadow',
    initialValue: true,
  );
  final month = context.knobs.string(
    label: 'Month',
    description:
        'Three-character localized month abbreviation, for example JUN.',
    initialValue: 'JUN',
  );
  final day = context.knobs.string(
    label: 'Day',
    description: 'Calendar day from 1 to 31.',
    initialValue: '16',
  );
  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: LinagoraEventDateIcon.defaultSize,
    min: 32,
    max: 120,
  );
  final headerColor = context.knobs.color(
    label: 'Header color',
    initialValue: LinagoraEventDateIcon.defaultHeaderColor,
  );
  final backgroundColor = context.knobs.color(
    label: 'Background color',
    initialValue: LinagoraEventDateIcon.defaultBackgroundColor,
  );
  final monthTextColor = context.knobs.color(
    label: 'Month text color',
    initialValue: LinagoraEventDateIcon.defaultMonthTextColor,
  );
  final dayTextColor = context.knobs.color(
    label: 'Day text color',
    initialValue: LinagoraEventDateIcon.defaultDayTextColor,
  );
  final semanticLabel = context.knobs.stringOrNull(
    label: 'Accessibility label',
    defaultToNull: true,
  );
  final inputError = LinagoraEventDateIcon.validateDateParts(
    month: month,
    day: day,
  );

  return Center(
    child: inputError == null
        ? LinagoraEventDateIcon(
            month: month,
            day: day,
            size: size,
            headerColor: headerColor,
            backgroundColor: backgroundColor,
            monthTextColor: monthTextColor,
            dayTextColor: dayTextColor,
            shadow: showShadow ? LinagoraEventDateIcon.defaultShadow : null,
            semanticLabel: semanticLabel,
          )
        : _DateInputError(message: inputError),
  );
}

class _DateInputError extends StatelessWidget {
  const _DateInputError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        message,
        style: LinagoraTextTheme.material().bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
