import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraReactionItem)
Widget linagoraReactionItemUseCase(BuildContext context) {
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: LinagoraReactionItemSize.values,
    initialOption: LinagoraReactionItemSize.small,
    labelBuilder: (size) => size.name,
  );
  final name = context.knobs.string(label: 'Name', initialValue: 'Name');

  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: LinagoraReactionItem(
      name: name,
      emoji: context.knobs.string(label: 'Emoji', initialValue: '😀'),
      avatar: RoundAvatar(text: name, size: size.avatarSize),
      size: size,
      onTap: () {},
    ),
  );
}
