import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: implementation_imports
import 'package:widgetbook/src/settings/setting.dart';
import 'package:widgetbook/widgetbook.dart';

/// An addon to display a link to a GitHub repository.
class GitHubAddon extends WidgetbookAddon<void> {
  GitHubAddon(this.repository) : super(name: 'GitHub');

  final String repository;

  @override
  List<Field> get fields {
    return [
      StringField(name: ''),
    ];
  }

  @override
  void valueFromQueryGroup(Map<String, String> group) {}

  @override
  Widget buildFields(BuildContext context) {
    return Setting(
      name: 'Repository',
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(
              Icons.source,
              size: 18,
            ),
            label: Text(repository),
            onPressed: () => launchUrl(
              Uri.parse('https://github.com/linagora/linagora-design-flutter/$repository'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              padding: const EdgeInsets.all(16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}