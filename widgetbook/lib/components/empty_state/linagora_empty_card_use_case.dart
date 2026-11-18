import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum _EmptyCardIllustration { none, share, mail }

@widgetbook.UseCase(name: 'Default', type: LinagoraEmptyCard)
Widget linagoraEmptyCardUseCase(BuildContext context) {
  final knobs = _readKnobs(context);
  final style = _styleOf(context, knobs);
  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
    child: LinagoraEmptyCard(
      title: knobs.title,
      message: knobs.message.isEmpty ? null : knobs.message,
      bordered: knobs.bordered,
      width: knobs.width,
      style: style,
      illustration: _illustrationOf(knobs.illustration),
      action: knobs.showAction
          ? LinagoraEmptyCardAction(
              label: 'Add',
              icon: Icons.add,
              onPressed: () {},
            )
          : null,
    ),
  );
}

class _EmptyCardKnobs {
  final String title;
  final String message;
  final _EmptyCardIllustration illustration;
  final bool showAction;
  final bool bordered;
  final double? width;
  final double radius;
  final bool overrideBackground;
  final Color? backgroundColor;

  const _EmptyCardKnobs({
    required this.title,
    required this.message,
    required this.illustration,
    required this.showAction,
    required this.bordered,
    required this.width,
    required this.radius,
    required this.overrideBackground,
    required this.backgroundColor,
  });
}

_EmptyCardKnobs _readKnobs(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final defaults = isDark
      ? LinagoraEmptyCardStyle.dark()
      : LinagoraEmptyCardStyle.material();
  final matchParentWidth = context.knobs.boolean(
    label: 'Match parent width',
    initialValue: true,
  );
  final overrideBackground = context.knobs.boolean(
    label: 'Override background',
    initialValue: false,
  );
  return _EmptyCardKnobs(
    title: context.knobs.string(
      label: 'Title',
      initialValue: 'No one has access yet',
    ),
    message: context.knobs.string(
      label: 'Message',
      initialValue: 'Add someone below to share access to your inbox.',
    ),
    illustration: context.knobs.object.dropdown(
      label: 'Illustration',
      options: _EmptyCardIllustration.values,
      initialOption: _EmptyCardIllustration.share,
      labelBuilder: (value) => switch (value) {
        _EmptyCardIllustration.none => 'None',
        _EmptyCardIllustration.share => 'Share',
        _EmptyCardIllustration.mail => 'Mail',
      },
    ),
    showAction: context.knobs.boolean(label: 'Action', initialValue: true),
    bordered: context.knobs.boolean(label: 'Border', initialValue: true),
    width: matchParentWidth
        ? null
        : context.knobs.double.slider(
            label: 'Width',
            initialValue: 398,
            min: 200,
            max: 600,
          ),
    radius: context.knobs.double.slider(
      label: 'Radius',
      initialValue: defaults.radius,
      min: 0,
      max: 32,
    ),
    overrideBackground: overrideBackground,
    backgroundColor: overrideBackground
        ? context.knobs.color(
            label: 'Background',
            initialValue: defaults.backgroundColor,
          )
        : null,
  );
}

LinagoraEmptyCardStyle _styleOf(BuildContext context, _EmptyCardKnobs knobs) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final defaults = isDark
      ? LinagoraEmptyCardStyle.dark()
      : LinagoraEmptyCardStyle.material();
  return defaults.copyWith(
    radius: knobs.radius,
    backgroundColor: knobs.backgroundColor,
  );
}

Widget? _illustrationOf(_EmptyCardIllustration illustration) {
  final (asset, width, height) = switch (illustration) {
    _EmptyCardIllustration.none => (null, 0.0, 0.0),
    _EmptyCardIllustration.share => (
        LinagoraDesignImages.emptyCardShareIcon,
        74.45,
        48.0,
      ),
    _EmptyCardIllustration.mail => (
        LinagoraDesignImages.emptyCardMailIcon,
        44.0,
        44.0,
      ),
  };
  if (asset == null) return null;
  return SvgPicture.asset(
    asset,
    package: LinagoraDesignImages.packageName,
    width: width,
    height: height,
  );
}
