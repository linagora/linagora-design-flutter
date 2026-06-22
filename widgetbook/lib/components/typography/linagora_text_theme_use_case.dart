import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Type scale', type: LinagoraTextTheme)
Widget linagoraTextThemeUseCase(BuildContext context) {
  final textTheme = LinagoraTextTheme.material();
  final extras = Theme.of(context).extension<LinagoraTextThemeExtension>();
  final slots = <String, TextStyle?>{
    'displayLarge': textTheme.displayLarge,
    'displayMedium': textTheme.displayMedium,
    'displaySmall': textTheme.displaySmall,
    'headlineLarge': textTheme.headlineLarge,
    'headlineMedium': textTheme.headlineMedium,
    'headlineSmall': textTheme.headlineSmall,
    'titleLarge': textTheme.titleLarge,
    'titleMedium': textTheme.titleMedium,
    'titleSmall': textTheme.titleSmall,
    'labelLarge': textTheme.labelLarge,
    'labelMedium': textTheme.labelMedium,
    'labelSmall': textTheme.labelSmall,
    'bodyLarge': textTheme.bodyLarge,
    'bodyMedium': textTheme.bodyMedium,
    'bodySmall': textTheme.bodySmall,
    'titleSemibold': extras?.titleSemibold,
    'bodyLargeBold': extras?.bodyLargeBold,
    'bodyLarge1': extras?.bodyLarge1,
    'bodyLarge2': extras?.bodyLarge2,
    'bodyMedium1': extras?.bodyMedium1,
    'bodyMedium2': extras?.bodyMedium2,
    'bodyMedium3': extras?.bodyMedium3,
  };
  final captionStyle = textTheme.labelMedium?.copyWith(
    color: LinagoraSysColors.material().onSurfaceVariant,
  );
  return ListView(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
    children: slots.entries.map((entry) {
      final style = entry.value;
      final weight =
          style?.fontWeight?.toString().replaceAll('FontWeight.', '');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: LinagoraSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.key} · ${style?.fontSize?.toStringAsFixed(0)}px · $weight',
              style: captionStyle,
            ),
            Text('The quick brown fox jumps over the lazy dog', style: style),
          ],
        ),
      );
    }).toList(),
  );
}
