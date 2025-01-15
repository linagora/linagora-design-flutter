import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/utils/twake_chat_widget/contact/contact_item_widget.dart';
import 'package:widgetbook_workspace/utils/twake_chat_widget/contact/contact_status.dart';

@widgetbook.UseCase(name: 'Phonebook contact', type: ContactItem)
Widget matrixContactUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 24.0,
    ),
    child: ContactItem(
      avatarUrl: context.knobs.string(
        label: 'Avatar URL',
        initialValue:
        'https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg',
      ),
      displayName: context.knobs.string(
        label: 'Display Name',
        initialValue: 'John Doe',
      ),
      isCurrentMatrixId: context.knobs.boolean(
        label: 'Is Current Matrix ID',
        initialValue: false,
      ),
      contactStatus: context.knobs.list(
        label: 'Contact Status',
        options: ContactStatus.values,
        labelBuilder: (status) => status?.label ?? '',
      ),
      matrixId: context.knobs.string(
        label: 'Matrix ID',
        initialValue: '@john.doe:matrix.com',
      ),
      email: context.knobs.string(
        label: 'Email',
        initialValue: 'john.doe@matrix.com',
      ),
    ),
  );
}