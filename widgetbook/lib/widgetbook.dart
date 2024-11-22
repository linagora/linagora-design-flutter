import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart' hide AlignmentAddon;
import 'package:widgetbook_workspace/custom/github_addon.dart';
import 'package:widgetbook_workspace/theme/theme_data.dart';
import 'package:widgetbook_workspace/widgets/matrix_contact_item.dart';
import 'package:widgetbook_workspace/widgets/phonebook_contact_item.dart';

import 'custom/custom_addon.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.light(),
      addons: [
        GitHubAddon('widgetbook'),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.ios.iPad,
          ],
          initialDevice: Devices.ios.iPhone13,
        ),
        InspectorAddon(),
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: TwakeThemes.buildTheme(
                context,
                Brightness.light,
                LinagoraSysColors.material().onPrimary,
              ),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: TwakeThemes.buildTheme(
                context,
                Brightness.dark,
                LinagoraSysColors.material().onPrimary,
              ),
            ),
          ],
          themeBuilder: (context, theme, child) => ColoredBox(
            color: LinagoraSysColors.material().onPrimary,
            child: DefaultTextStyle(
              style: theme.textTheme.bodyLarge ?? const TextStyle(),
              child: AppTheme(
                data: theme,
                child: child,
              ),
            ),
          ),
        ),
        AlignmentAddon(),
        BuilderAddon(
          name: 'SafeArea',
          builder: (_, child) => SafeArea(
            child: child,
          ),
        ),
      ],
      directories: [
        WidgetbookFolder(
          name: 'Widgets',
          children: [
            WidgetbookComponent(
              name: 'Contact item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Phonebook contact style',
                  builder: (context) => phonebookContactUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Matrix contact style',
                  builder: (context) => matrixContactUseCase(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
