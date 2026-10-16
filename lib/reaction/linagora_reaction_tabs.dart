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
///
/// The selected tab is scrolled into view. No tab is selected when
/// [selectedIndex] is out of range.
class LinagoraReactionTabs extends StatefulWidget {
  static const double height = LinagoraSpacing.base * 6;

  static const double _horizontalPadding = LinagoraSpacing.base * 2;
  static const double _tabSpacing = LinagoraSpacing.base * 0.5;
  static const Duration _scrollDuration = Duration(milliseconds: 200);

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
  State<LinagoraReactionTabs> createState() => _LinagoraReactionTabsState();
}

class _LinagoraReactionTabsState extends State<LinagoraReactionTabs> {
  List<GlobalKey> _tabKeys = const [];

  @override
  void initState() {
    super.initState();
    _showSelectedTab(Duration.zero);
  }

  @override
  void didUpdateWidget(LinagoraReactionTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex ||
        widget.tabs.length != oldWidget.tabs.length) {
      _showSelectedTab(LinagoraReactionTabs._scrollDuration);
    }
  }

  void _showSelectedTab(Duration duration) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final index = widget.selectedIndex;
      if (index < 0 || index >= _tabKeys.length) return;
      final tabContext = _tabKeys[index].currentContext;
      if (tabContext == null) return;
      Scrollable.ensureVisible(tabContext, alignment: 0.5, duration: duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tabKeys.length != widget.tabs.length) {
      _tabKeys = [for (final _ in widget.tabs) GlobalKey()];
    }

    return SizedBox(
      height: LinagoraReactionTabs.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: LinagoraReactionTabs._horizontalPadding,
        ),
        child: Row(
          spacing: LinagoraReactionTabs._tabSpacing,
          children: [
            for (final (index, tab) in widget.tabs.indexed)
              _ReactionTab(
                key: _tabKeys[index],
                tab: tab,
                isSelected: index == widget.selectedIndex,
                onTap: () => widget.onSelected(index),
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
    super.key,
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
        child: Semantics(
          button: true,
          selected: isSelected,
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
                        style: LinagoraTextTheme.material().titleMedium
                            ?.copyWith(color: sysColors.onSurfaceVariant),
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
      ),
    );
  }
}
