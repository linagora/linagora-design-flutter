import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraTextField)
Widget linagoraTextFieldUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<LinagoraTextFieldVariant>(
    label: 'Variant',
    options: LinagoraTextFieldVariant.values,
    initialOption: LinagoraTextFieldVariant.outline,
    labelBuilder: (v) => v.name,
  );
  final showError = context.knobs.boolean(
    label: 'Show error',
    initialValue: false,
  );
  final withTrailingIcon = context.knobs.boolean(
    label: 'With trailing icon',
    initialValue: true,
  );
  final withHeading = context.knobs.boolean(
    label: 'With title/description',
    initialValue: false,
  );
  final textInputAction = context.knobs.objectOrNull.dropdown<TextInputAction>(
    label: 'Text input action',
    options: const [
      TextInputAction.done,
      TextInputAction.next,
      TextInputAction.go,
      TextInputAction.search,
    ],
    initialOption: null,
    labelBuilder: (v) => v.name,
  );
  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    child: LinagoraTextField(
      title: withHeading
          ? context.knobs.string(
              label: 'Title',
              initialValue: 'Enter recovery key',
            )
          : null,
      description: withHeading
          ? context.knobs.string(
              label: 'Description',
              initialValue:
                  'Paste the key you saved when setting up secure backup.',
            )
          : null,
      label: context.knobs.string(label: 'Label', initialValue: 'Recovery key'),
      hintText: context.knobs.string(
        label: 'Hint text',
        initialValue: 'XXX-XXX-XXX',
      ),
      supportingText: context.knobs.string(
        label: 'Supporting text',
        initialValue: 'Supporting text',
      ),
      errorText: showError ? "recovery key doesn't match" : null,
      trailingIcon: withTrailingIcon ? Icons.error : null,
      onTrailingIconPressed: withTrailingIcon ? () {} : null,
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
      variant: variant,
      onChanged: (_) {},
      autofocus: context.knobs.boolean(
        label: 'Autofocus',
        initialValue: false,
      ),
      textInputAction: textInputAction,
      onSubmitted: (value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitted: $value')),
      ),
    ),
  );
}
