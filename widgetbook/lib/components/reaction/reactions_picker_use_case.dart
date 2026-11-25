import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/reaction/app_emojis.dart';
import 'package:linagora_design_flutter/reaction/reaction_picker.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: ReactionsPicker)
Widget reactionsPickerUseCase(BuildContext context) {
  final reacted = context.knobs.object.dropdown<String?>(
    label: 'My reaction',
    options: [null, ...AppEmojis.emojisDefault],
    labelBuilder: (emoji) => emoji ?? 'None',
  );

  return Center(child: ReactionsPicker(myEmojiReacted: reacted));
}
