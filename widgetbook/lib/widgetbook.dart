import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' hide AlignmentAddon;
import 'package:widgetbook_workspace/chat_list_item/chat_list_item.dart';

import 'customs/custom_addon.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      addons: [
        InspectorAddon(),
        AlignmentAddon(),
        ZoomAddon(),
      ],
      directories: [
        WidgetbookFolder(
          name: 'Widgets',
          children: [
            WidgetbookComponent(
              name: 'Chat list item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default Style',
                  builder: (context) => chatListItemUseCase(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
