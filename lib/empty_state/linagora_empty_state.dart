import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Card shown in place of a content that cannot be displayed.
class LinagoraEmptyState extends StatelessWidget {
  static const double illustrationSize = 180;
  static const double compactIllustrationSize = 140;

  static const double _width = 384;
  static const double _compactWidth = 330;
  static const double _backgroundOpacity = 0.5;
  static const double _radius = 20;
  static const double _padding = LinagoraSpacing.base * 4;
  static const double _gap = LinagoraSpacing.base * 2;

  /// Laid out in an [illustrationSize] square, or [compactIllustrationSize]
  /// when [compact].
  final Widget illustration;

  final String title;

  final String? description;

  /// Narrow-screen variant: smaller illustration and text.
  final bool compact;

  const LinagoraEmptyState({
    super.key,
    required this.illustration,
    required this.title,
    this.description,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = LinagoraTextTheme.material();
    final description = this.description;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: compact ? _compactWidth : _width),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: LinagoraRefColors.material().primary[100]?.withValues(
            alpha: _backgroundOpacity,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(_radius)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox.square(
                  dimension: compact
                      ? compactIllustrationSize
                      : illustrationSize,
                  child: illustration,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: _gap),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: (compact ? textTheme.labelLarge : textTheme.bodyLarge)
                      ?.copyWith(
                        color: LinagoraRefColors.material().tertiary[20],
                      ),
                ),
              ],
              const SizedBox(height: _gap),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    (compact
                            ? textTheme.headlineSmall
                            : textTheme.headlineLarge)
                        ?.copyWith(
                          color: LinagoraSysColors.material().onSurface,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
