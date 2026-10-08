import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// The content of one tab of [LinagoraReactionTabs].
class LinagoraReactionTab {
  /// The whole tab text, such as `All 5` or `👍 3`.
  final String label;

  /// A custom emoji, displayed before [label].
  final Widget? image;

  const LinagoraReactionTab({required this.label, this.image});
}

/// The tabs filtering the list of who reacted to a message.
class LinagoraReactionTabs extends StatelessWidget {
  static const double height = LinagoraSpacing.base * 6;

  static const double _horizontalPadding = LinagoraSpacing.base * 2;
  static const double _tabSpacing = LinagoraSpacing.base * 0.5;

  final List<LinagoraReactionTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const LinagoraReactionTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Row(
          spacing: _tabSpacing,
          children: [
            for (final (index, tab) in tabs.indexed)
              _ReactionTab(
                tab: tab,
                isSelected: index == selectedIndex,
                onTap: () => onSelected(index),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReactionTab extends StatelessWidget {
  static const double _padding = LinagoraSpacing.base;
  static const double _imageSize = LinagoraSpacing.base * 3;
  static const double _indicatorAreaHeight = 14;
  static const double _indicatorHeight = 3;
  static const double _indicatorInset = 2;

  final LinagoraReactionTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReactionTab({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sysColors = LinagoraSysColors.material();
    final image = tab.image;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: LinagoraSpacing.base * 0.5,
                  children: [
                    if (image != null)
                      SizedBox.square(dimension: _imageSize, child: image),
                    Text(
                      tab.label,
                      maxLines: 1,
                      style: LinagoraTextTheme.material().titleMedium?.copyWith(
                        color: sysColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: _indicatorHeight,
                  margin: const EdgeInsets.only(
                    top: _indicatorAreaHeight - _indicatorHeight,
                    left: _indicatorInset,
                    right: _indicatorInset,
                  ),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: sysColors.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(100),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
