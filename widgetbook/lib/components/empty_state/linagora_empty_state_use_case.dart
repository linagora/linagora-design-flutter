import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraEmptyState)
Widget linagoraEmptyStateUseCase(BuildContext context) {
  final compact = context.knobs.boolean(label: 'Compact', initialValue: false);

  return DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFBEDDFF), Color(0xFFECE0FE)],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: LinagoraEmptyState(
                illustration: const FittedBox(
                  child: Icon(Icons.lock_outline, color: Colors.white),
                ),
                title: context.knobs.string(
                  label: 'Title',
                  initialValue: 'Nothing to show',
                ),
                description: context.knobs.stringOrNull(
                  label: 'Description',
                  initialValue: 'This content is hidden by the administrator.',
                ),
                compact: compact,
              ),
            ),
          ),
          LinagoraButton(
            label: 'Request access',
            onPressed: () {},
            width: compact ? double.infinity : 242,
            minimumHeight: LinagoraButton.mediumHeight,
            padding: LinagoraButton.mediumPadding,
          ),
        ],
      ),
    ),
  );
}
