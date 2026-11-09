import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/tabs/linagora_segmented_tabs_style.dart';

/// One option of a [LinagoraSegmentedTabs].
@immutable
class LinagoraSegment<T> {
  final T value;
  final String label;

  const LinagoraSegment({required this.value, required this.label});
}

/// A pill-shaped switch between two or more views of the same screen, e.g.
/// "By me" / "With me".
///
/// The control is one focus stop: arrow keys (mirrored in RTL), Home and End
/// select another segment, as in a tab list. Each segment is announced as a
/// selectable button of a mutually exclusive group.
class LinagoraSegmentedTabs<T> extends StatefulWidget {
  final List<LinagoraSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  /// Shares the available width equally between the segments.
  /// Otherwise each segment takes [LinagoraSegmentedTabsStyle.segmentWidth].
  final bool expanded;

  final LinagoraSegmentedTabsStyle? style;

  LinagoraSegmentedTabs({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.expanded = false,
    this.style,
  }) : assert(segments.length >= 2, 'Needs at least two segments'),
       assert(() {
         for (var i = 0; i < segments.length; i++) {
           for (var j = 0; j < i; j++) {
             if (segments[i].value == segments[j].value) {
               throw AssertionError('segment values must be unique');
             }
           }
         }
         return true;
       }()),
       assert(
         segments.any((segment) => segment.value == selected),
         'selected must be one of the segment values',
       );

  /// Key of the segment showing [value], for tests and integration tests.
  ///
  /// Identity follows [value]'s own equality, so two values that print the
  /// same do not share a key.
  static Key segmentKey(Object? value) => _LinagoraSegmentKey(value);

  @override
  State<LinagoraSegmentedTabs<T>> createState() =>
      _LinagoraSegmentedTabsState<T>();
}

class _LinagoraSegmentedTabsState<T> extends State<LinagoraSegmentedTabs<T>> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  /// Mouse/touch selection still requests focus (so arrows work), but must not
  /// paint the keyboard focus ring. Desktop/web report pointer input as
  /// [FocusHighlightMode.traditional], so highlight mode alone is not enough.
  bool _suppressFocusHighlight = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addHighlightModeListener(_onHighlightMode);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_onHighlightMode);
    _focusNode.dispose();
    super.dispose();
  }

  void _onHighlightMode(FocusHighlightMode _) {
    if (mounted) setState(() {});
  }

  bool get _showsKeyboardFocus {
    if (!_focused || _suppressFocusHighlight) return false;
    return FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
  }

  int get _selectedIndex =>
      widget.segments.indexWhere((segment) => segment.value == widget.selected);

  bool _isPressed(KeyEvent event) {
    return event is KeyDownEvent || event is KeyRepeatEvent;
  }

  void _select(int index, {bool requestFocus = false}) {
    if (requestFocus) {
      // Pointer-driven: take focus without the blue ring.
      _suppressFocusHighlight = true;
      _focusNode.requestFocus();
    }
    final value = widget.segments[index].value;
    if (value != widget.selected) widget.onChanged(value);
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isPressed(event)) return KeyEventResult.ignored;
    if (_suppressFocusHighlight) {
      setState(() => _suppressFocusHighlight = false);
    }
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final step = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowRight => isRtl ? -1 : 1,
      LogicalKeyboardKey.arrowLeft => isRtl ? 1 : -1,
      _ => 0,
    };
    final last = widget.segments.length - 1;
    final int? target = switch (event.logicalKey) {
      LogicalKeyboardKey.home => 0,
      LogicalKeyboardKey.end => last,
      _ when step != 0 => (_selectedIndex + step).clamp(0, last),
      _ => null,
    };
    if (target == null) return KeyEventResult.ignored;
    _select(target);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.style ?? LinagoraSegmentedTabsStyle.material();
    final radius = BorderRadius.circular(tokens.height / 2);
    final showFocus = _showsKeyboardFocus;

    final segments = [
      for (final (index, segment) in widget.segments.indexed)
        _wrapWidth(
          tokens,
          _LinagoraSegmentButton(
            key: LinagoraSegmentedTabs.segmentKey(segment.value),
            label: segment.label,
            selected: index == _selectedIndex,
            focused: showFocus && index == _selectedIndex,
            radius: radius,
            tokens: tokens,
            onTap: () => _select(index, requestFocus: true),
          ),
        ),
    ];

    return Focus(
      focusNode: _focusNode,
      includeSemantics: false,
      onKeyEvent: _onKeyEvent,
      onFocusChange: (focused) {
        if (!mounted) return;
        setState(() {
          _focused = focused;
          if (!focused) _suppressFocusHighlight = false;
        });
      },
      child: Container(
        height: tokens.height,
        padding: tokens.trackPadding,
        decoration: BoxDecoration(
          color: tokens.trackColor,
          borderRadius: radius,
        ),
        child: Row(
          mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
          children: segments,
        ),
      ),
    );
  }

  Widget _wrapWidth(LinagoraSegmentedTabsStyle tokens, Widget segment) =>
      widget.expanded
      ? Expanded(child: segment)
      : SizedBox(width: tokens.segmentWidth, child: segment);
}

class _LinagoraSegmentKey extends LocalKey {
  const _LinagoraSegmentKey(this.value);

  final Object? value;

  @override
  bool operator ==(Object other) =>
      other is _LinagoraSegmentKey && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

class _LinagoraSegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool focused;
  final BorderRadius radius;
  final LinagoraSegmentedTabsStyle tokens;
  final VoidCallback onTap;

  const _LinagoraSegmentButton({
    super.key,
    required this.label,
    required this.selected,
    required this.focused,
    required this.radius,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      focused: focused ? true : null,
      inMutuallyExclusiveGroup: true,
      child: AnimatedContainer(
        duration: tokens.animationDuration,
        decoration: BoxDecoration(
          color: selected ? tokens.selectedColor : Colors.transparent,
          borderRadius: radius,
          boxShadow: selected ? tokens.selectedShadow : null,
        ),
        foregroundDecoration: focused
            ? BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                  color: tokens.focusColor,
                  width: tokens.focusWidth,
                ),
              )
            : null,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            canRequestFocus: false,
            borderRadius: radius,
            hoverColor: selected ? Colors.transparent : tokens.hoverColor,
            onTap: onTap,
            child: Padding(
              padding: tokens.segmentPadding,
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: selected
                      ? tokens.selectedTextStyle
                      : tokens.unselectedTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
