import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraAvatarListItem)
Widget linagoraAvatarListItemUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Stay in Paris',
  );

  return Padding(
    padding: const EdgeInsets.all(LinagoraSpacing.base),
    child: LinagoraAvatarListItem(
      avatar: RoundAvatar(
        text: title,
        size: LinagoraAvatarListItem.avatarSize,
      ),
      title: title,
      subtitle: context.knobs.stringOrNull(
        label: 'Subtitle',
        initialValue: '3976 members',
      ),
      subtitleHeading: context.knobs.stringOrNull(
        label: 'Subtitle heading',
        initialValue: null,
      ),
      subtitleMaxLines: context.knobs.int.slider(
        label: 'Subtitle max lines',
        initialValue: 1,
        min: 1,
        max: 2,
      ),
      isTitleEmphasized: context.knobs.boolean(
        label: 'Emphasized title',
        initialValue: false,
      ),
      titleIcons: [
        if (context.knobs.boolean(label: 'Title icon', initialValue: false))
          const Icon(Icons.push_pin_outlined),
      ],
      trailingLabel: context.knobs.stringOrNull(
        label: 'Trailing label',
        initialValue: null,
      ),
      selected: context.knobs.boolean(label: 'Selected', initialValue: false),
      showDivider: context.knobs.boolean(
        label: 'Show divider',
        initialValue: true,
      ),
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Section', type: LinagoraAvatarListItem)
Widget linagoraAvatarListItemSectionUseCase(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(LinagoraSpacing.base),
    child: _SectionDemo(),
  );
}

class _SectionDemo extends StatefulWidget {
  const _SectionDemo();

  @override
  State<_SectionDemo> createState() => _SectionDemoState();
}

class _SectionDemoState extends State<_SectionDemo> {
  static const _collapsedCount = 3;
  static const _groups = [
    ('Scientist Paris', 3976),
    ('Colors Paris Team', 812),
    ('James Paris', 240),
    ('Plant Paris Builders', 97),
    ('The AI Paris Team', 36),
  ];

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final groups = _expanded ? _groups : _groups.take(_collapsedCount);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinagoraSectionHeader(
          label: 'Results',
          actionLabel: _expanded ? 'Show less' : 'Show more',
          onActionTap: () => setState(() => _expanded = !_expanded),
        ),
        for (final (name, members) in groups)
          LinagoraAvatarListItem(
            avatar: RoundAvatar(
              text: name,
              size: LinagoraAvatarListItem.avatarSize,
            ),
            title: name,
            subtitle: '$members members',
            onTap: () {},
          ),
      ],
    );
  }
}
