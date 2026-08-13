import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart' hide AlignmentAddon;
import 'package:widgetbook_workspace/components/banners/linagora_banner_use_case.dart';
import 'package:widgetbook_workspace/components/buttons/linagora_button_use_case.dart';
import 'package:widgetbook_workspace/components/chat/message_bubble_use_case.dart';
import 'package:widgetbook_workspace/components/contact_component/matrix_contact_use_case.dart';
import 'package:widgetbook_workspace/components/contact_component/phonebook_contact_use_case.dart';
import 'package:widgetbook_workspace/components/list_item/linagora_setting_item_use_case.dart';
import 'package:widgetbook_workspace/components/list_item/session_device_list_item_use_case.dart';
import 'package:widgetbook_workspace/components/sidebar/linagora_sidebar_item_use_case.dart';
import 'package:widgetbook_workspace/components/sidebar/linagora_sidebar_tree_list_use_case.dart';
import 'package:widgetbook_workspace/components/text_field/linagora_text_field_use_case.dart';
import 'package:widgetbook_workspace/components/typography/linagora_text_theme_use_case.dart';
import 'package:widgetbook_workspace/custom/github_addon.dart';
import 'package:widgetbook_workspace/theme/theme_data.dart';

import 'custom/alignment_addon.dart';

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
        ViewportAddon(
          [
            IosViewports.iPhone13,
            IosViewports.iPad,
          ],
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
              child: Theme(
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
          name: 'Banners',
          children: [
            WidgetbookComponent(
              name: 'Linagora banner',
              useCases: [
                WidgetbookUseCase(
                  name: 'No action',
                  builder: (context) => linagoraBannerNoActionUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Has action',
                  builder: (context) => linagoraBannerHasActionUseCase(context),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Buttons',
          children: [
            WidgetbookComponent(
              name: 'Linagora button',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => linagoraButtonUseCase(context),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Text field',
          children: [
            WidgetbookComponent(
              name: 'Linagora text field',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => linagoraTextFieldUseCase(context),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Typography',
          children: [
            WidgetbookComponent(
              name: 'Text theme',
              useCases: [
                WidgetbookUseCase(
                  name: 'Type scale',
                  builder: (context) => linagoraTextThemeUseCase(context),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Chat',
          children: [
            WidgetbookComponent(
              name: 'Message bubble',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => messageBubbleUseCase(context),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'List item',
          children: [
            WidgetbookComponent(
              name: 'Session device list item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Verified',
                  builder: (context) =>
                      sessionDeviceListItemVerifiedUseCase(context),
                ),
                WidgetbookUseCase(
                  name: 'Unverified',
                  builder: (context) =>
                      sessionDeviceListItemUnverifiedUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Linagora setting item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => linagoraSettingItemUseCase(context),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Sidebar',
          children: [
            WidgetbookComponent(
              name: 'Linagora sidebar tree list',
              useCases: [
                WidgetbookUseCase(
                  name: 'Virtualized folder tree',
                  builder: (context) =>
                      linagoraSidebarTreeListUseCase(context),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Linagora sidebar item',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => linagoraSidebarItemUseCase(context),
                ),
              ],
            ),
          ],
        ),
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
