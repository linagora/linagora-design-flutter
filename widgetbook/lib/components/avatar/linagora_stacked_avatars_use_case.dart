import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _initials = ['NH', 'MC', 'AL', 'KT'];

@widgetbook.UseCase(name: 'Default', type: LinagoraStackedAvatars)
Widget linagoraStackedAvatarsUseCase(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Avatars',
    initialValue: 2,
    min: 0,
    max: _initials.length,
  );
  final maxVisible = context.knobs.int.slider(
    label: 'Max visible',
    initialValue: 3,
    min: 1,
    max: _initials.length,
  );
  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: 32,
    min: 16,
    max: 48,
  );

  final isDark = Theme.of(context).brightness == Brightness.dark;
  final style = (isDark
          ? LinagoraStackedAvatarsStyle.dark()
          : LinagoraStackedAvatarsStyle.material())
      .copyWith(size: size);

  return ColoredBox(
    color: style.ringColor,
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: LinagoraStackedAvatars(
          style: style,
          maxVisible: maxVisible,
          semanticLabel: 'Stacked avatars',
          avatars: [
            for (final initials in _initials.take(count))
              RoundAvatar(
                text: initials,
                size: size,
                textStyle: _initialsStyle(size),
              ),
          ],
        ),
      ),
    ),
  );
}

/// Initials scaled to the avatar so they stay inside the circle.
TextStyle _initialsStyle(double size) => TextStyle(
      color: Colors.white,
      fontSize: size * 0.44,
      fontWeight: FontWeight.w600,
    );
