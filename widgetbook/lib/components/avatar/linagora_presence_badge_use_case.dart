import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraPresenceBadge)
Widget linagoraPresenceBadgeUseCase(BuildContext context) {
  final presence = context.knobs.objectOrNull.dropdown<LinagoraPresence>(
    label: 'Presence',
    options: LinagoraPresence.values,
    initialOption: LinagoraPresence.online,
    labelBuilder: (value) => value.name,
  );
  final size = context.knobs.double.slider(
    label: 'Avatar size',
    initialValue: 48,
    min: 24,
    max: 96,
  );
  final style = _style(context);

  return ColoredBox(
    color: style.ringColor,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: _badge(presence, size, style),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All states and sizes', type: LinagoraPresenceBadge)
Widget linagoraPresenceBadgeGalleryUseCase(BuildContext context) {
  final style = _style(context);
  const presences = [
    LinagoraPresence.online,
    LinagoraPresence.away,
    LinagoraPresence.offline,
    null,
  ];
  const sizes = [32.0, 40.0, 48.0, 56.0, 96.0];

  return ColoredBox(
    color: style.ringColor,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final presence in presences) ...[
            Text(presence?.name ?? 'unknown'),
            const SizedBox(height: LinagoraSpacing.base),
            Padding(
              padding: const EdgeInsets.only(bottom: LinagoraSpacing.base * 3),
              child: Wrap(
                spacing: LinagoraSpacing.base * 2,
                runSpacing: LinagoraSpacing.base * 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final size in sizes) _badge(presence, size, style),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

LinagoraPresenceBadgeStyle _style(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? LinagoraPresenceBadgeStyle.dark()
        : LinagoraPresenceBadgeStyle.material();

Widget _badge(
  LinagoraPresence? presence,
  double size,
  LinagoraPresenceBadgeStyle style,
) {
  return LinagoraPresenceBadge(
    presence: presence,
    size: size,
    style: style,
    child: RoundAvatar(
      text: 'Nina Hagen',
      size: size,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: size * 0.4,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
