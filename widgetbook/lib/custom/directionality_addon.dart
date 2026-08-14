import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// Lets every use case verify direction-aware sidebar layout.
class DirectionalityAddon extends WidgetbookAddon<TextDirection> {
  DirectionalityAddon() : super(name: 'Directionality');

  @override
  List<Field<TextDirection>> get fields => [
    ObjectDropdownField<TextDirection>(
      name: 'text direction',
      initialValue: TextDirection.ltr,
      values: TextDirection.values,
    ),
  ];

  @override
  TextDirection valueFromQueryGroup(Map<String, String> group) =>
      valueOf<TextDirection>('text direction', group)!;

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    TextDirection setting,
  ) => Directionality(textDirection: setting, child: child);
}
