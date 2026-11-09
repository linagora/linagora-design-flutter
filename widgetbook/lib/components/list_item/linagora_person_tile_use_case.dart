import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum _PersonTileTrailing { none, remove, check, status }

class _PersonTileKnobs {
  final String name;
  final String? subtitle;
  final int subtitleMaxLines;
  final bool showAvatar;
  final bool? selected;
  final bool tappable;
  final _PersonTileTrailing trailing;

  const _PersonTileKnobs({
    required this.name,
    required this.subtitle,
    required this.subtitleMaxLines,
    required this.showAvatar,
    required this.selected,
    required this.tappable,
    required this.trailing,
  });
}

_PersonTileKnobs _readPersonTileKnobs(BuildContext context) {
  return _PersonTileKnobs(
    name: context.knobs.string(label: 'Name', initialValue: 'Nora Hale'),
    subtitle: context.knobs.stringOrNull(
      label: 'Subtitle',
      initialValue: 'nora.hale@example.com',
    ),
    subtitleMaxLines: context.knobs.int.slider(
      label: 'Subtitle max lines',
      initialValue: 2,
      min: 1,
      max: 3,
    ),
    showAvatar: context.knobs.boolean(label: 'Avatar', initialValue: true),
    selected: context.knobs.booleanOrNull(
      label: 'Selected',
      initialValue: null,
      defaultToNull: true,
    ),
    tappable: context.knobs.boolean(label: 'Tappable', initialValue: true),
    trailing: context.knobs.object.dropdown(
      label: 'Trailing',
      options: _PersonTileTrailing.values,
      initialOption: _PersonTileTrailing.remove,
      labelBuilder: (value) => value.name,
    ),
  );
}

LinagoraPersonTileStyle _styleOf(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark
      ? LinagoraPersonTileStyle.dark()
      : LinagoraPersonTileStyle.material();
}

Widget _wrapPreview(bool isDark, Widget child) {
  return ColoredBox(
    color: _surface(isDark),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 2),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: SizedBox(width: 398, child: child),
      ),
    ),
  );
}

Widget? _trailingFor(
  _PersonTileTrailing trailing,
  LinagoraPersonTileStyle style, {
  required bool isDark,
}) {
  return switch (trailing) {
    _PersonTileTrailing.check => Icon(
        Icons.check,
        color: isDark ? const Color(0xFF9BBEFA) : const Color(0xFF0A84FF),
      ),
    _PersonTileTrailing.status => Text(
        'deleted',
        style: style.subtitleTextStyle,
      ),
    _ => null,
  };
}

@widgetbook.UseCase(name: 'Default', type: LinagoraPersonTile)
Widget linagoraPersonTileUseCase(BuildContext context) {
  final knobs = _readPersonTileKnobs(context);
  final style = _styleOf(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return _wrapPreview(
    isDark,
    LinagoraPersonTile(
      style: style,
      name: knobs.name,
      subtitle: knobs.subtitle,
      subtitleMaxLines: knobs.subtitleMaxLines,
      selected: knobs.selected,
      onTap: knobs.tappable ? () {} : null,
      avatar: knobs.showAvatar
          ? RoundAvatar(
              text: knobs.name.initials,
              size: style.avatarSize,
              textStyle: _initialsStyle(style.avatarSize),
            )
          : null,
      action: knobs.trailing == _PersonTileTrailing.remove
          ? const LinagoraPersonTileAction(
              tooltip: 'Remove',
              onPressed: _noop,
            )
          : null,
      trailing: _trailingFor(knobs.trailing, style, isDark: isDark),
    ),
  );
}

@widgetbook.UseCase(name: 'Default', type: LinagoraTileGroup)
Widget linagoraTileGroupUseCase(BuildContext context) {
  final header = context.knobs.string(
    label: 'Header',
    initialValue: 'Who has access',
  );
  final filled = context.knobs.boolean(label: 'Filled', initialValue: false);
  final rows = context.knobs.int.slider(
    label: 'Rows',
    initialValue: 2,
    min: 0,
    max: 4,
  );
  final showSubtitle = context.knobs.boolean(
    label: 'Subtitle',
    initialValue: false,
  );
  final showRemove = context.knobs.boolean(label: 'Remove', initialValue: true);
  final style = _styleOf(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return _wrapPreview(
    isDark,
    LinagoraTileGroup(
      filled: filled,
      style: style,
      header: header.isEmpty ? null : Text(header, style: style.headerTextStyle),
      children: [
        for (var index = 1; index <= rows; index++)
          LinagoraPersonTile(
            name: 'Nora Hale $index',
            subtitle:
                showSubtitle ? 'Had access Jan 1, 2024 – Mar 2, 2025' : null,
            style: style,
            avatar: RoundAvatar(
              text: 'NH',
              size: style.avatarSize,
              textStyle: _initialsStyle(style.avatarSize),
            ),
            action: showRemove
                ? LinagoraPersonTileAction(
                    key: LinagoraPersonTile.actionKeyFor(index),
                    tooltip: 'Remove',
                    onPressed: _noop,
                  )
                : null,
          ),
      ],
    ),
  );
}

void _noop() {}

/// Initials scaled to the avatar so they stay inside the circle.
TextStyle _initialsStyle(double size) => TextStyle(
      color: Colors.white,
      fontSize: size * 0.44,
      fontWeight: FontWeight.w600,
    );

Color _surface(bool isDark) => isDark ? const Color(0xFF3F4249) : Colors.white;
