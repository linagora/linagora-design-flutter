import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraReactionTabs)
Widget linagoraReactionTabsUseCase(BuildContext context) {
  const tabs = [
    LinagoraReactionTab(label: 'All 10'),
    LinagoraReactionTab(label: '👍 3'),
    LinagoraReactionTab(label: '💘 2'),
    LinagoraReactionTab(label: '😴 1'),
    LinagoraReactionTab(label: '🥵 1'),
    LinagoraReactionTab(label: '😱 1'),
    LinagoraReactionTab(label: '🤮 1'),
    LinagoraReactionTab(label: '🎉 1'),
  ];
  final selectedIndex = context.knobs.int.slider(
    label: 'Selected tab',
    initialValue: 0,
    min: 0,
    max: tabs.length - 1,
  );

  return Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 400,
      child: LinagoraReactionTabs(
        tabs: tabs,
        selectedIndex: selectedIndex,
        onSelected: (_) {},
      ),
    ),
  );
}
