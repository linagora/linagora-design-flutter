import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/tabs/linagora_segmented_tabs_style.dart';

/// One option of a [LinagoraSegmentedTabs].
@immutable
class LinagoraSegment<T> {
  final T value;

  /// Null for an icon-only segment.
  final String? label;
  final Widget? icon;

  /// Spoken name of an icon-only segment.
  final String? semanticLabel;

  /// A disabled segment is greyed out and skipped by taps and arrow keys.
  final bool enabled;

  /// Shown as a count badge after the content when above zero.
  final int? badgeCount;

  const LinagoraSegment({
    required this.value,
    required String this.label,
    this.enabled = true,
    this.badgeCount,
  }) : icon = null,
       semanticLabel = null;

  const LinagoraSegment.icon({
    required this.value,
    required Widget this.icon,
    required String this.semanticLabel,
    this.enabled = true,
    this.badgeCount,
  }) : label = null;
}

/// A pill-shaped switch between two or more views of the same screen, e.g.
/// "By me" / "With me".
///
/// The control is one focus stop: arrow keys (mirrored in RTL), Home and End
/// select another enabled segment, as in a tab list. Each segment is announced as a
/// selectable button of a mutually exclusive group.
class LinagoraSegmentedTabs<T> extends StatefulWidget {
  final List<LinagoraSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  /// Shares the available width equally between the segments. Under an
  /// unbounded width (a [Row], app bar actions) it falls back to
  /// [LinagoraSegmentedTabsStyle.segmentWidth].
  final bool expanded;

  /// Sizes each segment to its content plus
  /// [LinagoraSegmentedTabsStyle.segmentPadding]. When neither this nor
  /// [expanded] is set, each segment takes
  /// [LinagoraSegmentedTabsStyle.segmentWidth].
  final bool hugContent;

  final LinagoraSegmentedTabsStyle? style;

  LinagoraSegmentedTabs({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.expanded = false,
    this.hugContent = false,
    this.style,
  }) : assert(segments.length >= 2, 'Needs at least two segments'),
       assert(
         !(expanded && hugContent),
         'expanded and hugContent are exclusive',
       ),
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

  // Alt/Ctrl/Meta+Arrow belong to the platform, e.g. Alt+Left is browser back.
  bool get _isModifierHeld {
    final keyboard = HardwareKeyboard.instance;
    return keyboard.isAltPressed ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed;
  }

  void _select(int index, {bool requestFocus = false}) {
    if (requestFocus) {
      // Pointer-driven: take focus without the blue ring.
      setState(() => _suppressFocusHighlight = true);
      _focusNode.requestFocus();
    }
    final value = widget.segments[index].value;
    if (value != widget.selected) widget.onChanged(value);
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isPressed(event) || _isModifierHeld) return KeyEventResult.ignored;
    if (_suppressFocusHighlight) {
      setState(() => _suppressFocusHighlight = false);
    }
    final target = _keyTarget(event.logicalKey);
    if (target == null) return KeyEventResult.ignored;
    _select(target);
    return KeyEventResult.handled;
  }

  int? _keyTarget(LogicalKeyboardKey key) {
    final enabled = [
      for (final (index, segment) in widget.segments.indexed)
        if (segment.enabled) index,
    ];
    if (enabled.isEmpty) return null;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return switch (key) {
      LogicalKeyboardKey.home => enabled.first,
      LogicalKeyboardKey.end => enabled.last,
      LogicalKeyboardKey.arrowRight => _nextEnabled(enabled, forward: !isRtl),
      LogicalKeyboardKey.arrowLeft => _nextEnabled(enabled, forward: isRtl),
      _ => null,
    };
  }

  /// Stays on the current segment at either end.
  int _nextEnabled(List<int> enabled, {required bool forward}) {
    final current = _selectedIndex;
    final next = forward
        ? enabled.where((index) => index > current).firstOrNull
        : enabled.where((index) => index < current).lastOrNull;
    return next ?? current;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.style ?? LinagoraSegmentedTabsStyle.material();
    final radius = BorderRadius.circular(tokens.height / 2);
    final showFocus = _showsKeyboardFocus;

    final segments = [
      for (final (index, segment) in widget.segments.indexed)
        _LinagoraSegmentButton(
          key: LinagoraSegmentedTabs.segmentKey(segment.value),
          segment: segment,
          selected: index == _selectedIndex,
          focused: showFocus && index == _selectedIndex,
          radius: radius,
          tokens: tokens,
          onTap: segment.enabled
              ? () => _select(index, requestFocus: true)
              : null,
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
          // Focus restored without a key held (e.g. a closed dialog) is not keyboard focus.
          if (focused) {
            _suppressFocusHighlight =
                HardwareKeyboard.instance.logicalKeysPressed.isEmpty;
          }
        });
      },
      child: Container(
        padding: tokens.trackPadding,
        decoration: BoxDecoration(
          color: tokens.trackColor,
          borderRadius: radius,
        ),
        // LayoutBuilder only when expanded, so fixed and hug widths keep
        // intrinsic sizing.
        child: widget.expanded
            ? LayoutBuilder(
                builder: (context, constraints) =>
                    _row(tokens, segments, expand: constraints.hasBoundedWidth),
              )
            : _row(tokens, segments, expand: false),
      ),
    );
  }

  Widget _row(
    LinagoraSegmentedTabsStyle tokens,
    List<Widget> segments, {
    required bool expand,
  }) => Row(
    mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
    children: [
      for (final segment in segments)
        if (expand)
          Expanded(child: segment)
        else if (widget.hugContent)
          segment
        else
          SizedBox(width: tokens.segmentWidth, child: segment),
    ],
  );
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

class _LinagoraSegmentButton extends StatefulWidget {
  final LinagoraSegment<Object?> segment;
  final bool selected;
  final bool focused;
  final BorderRadius radius;
  final LinagoraSegmentedTabsStyle tokens;
  final VoidCallback? onTap;

  const _LinagoraSegmentButton({
    super.key,
    required this.segment,
    required this.selected,
    required this.focused,
    required this.radius,
    required this.tokens,
    required this.onTap,
  });

  @override
  State<_LinagoraSegmentButton> createState() => _LinagoraSegmentButtonState();
}

class _LinagoraSegmentButtonState extends State<_LinagoraSegmentButton> {
  bool _hovered = false;

  TextStyle get _textStyle {
    final tokens = widget.tokens;
    if (!widget.segment.enabled) return tokens.disabledTextStyle;
    if (widget.selected) return tokens.selectedTextStyle;
    return _hovered ? tokens.hoveredTextStyle : tokens.unselectedTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final radius = widget.radius;
    return Semantics(
      button: true,
      enabled: widget.segment.enabled ? null : false,
      selected: widget.selected,
      focused: widget.focused ? true : null,
      label: widget.segment.semanticLabel,
      inMutuallyExclusiveGroup: true,
      child: AnimatedContainer(
        duration: tokens.animationDuration,
        constraints: BoxConstraints(
          minHeight: tokens.height - tokens.trackPadding.vertical,
        ),
        decoration: BoxDecoration(
          color: widget.selected ? tokens.selectedColor : Colors.transparent,
          borderRadius: radius,
          boxShadow: widget.selected ? tokens.selectedShadow : null,
        ),
        foregroundDecoration: widget.focused
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
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onHover: (hovered) => setState(() => _hovered = hovered),
            onTap: widget.onTap,
            child: Padding(
              padding: tokens.segmentPadding,
              // heightFactor lets the segment grow with the text scale.
              child: Center(heightFactor: 1, child: _content(_textStyle)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(TextStyle style) {
    final segment = widget.segment;
    final icon = segment.icon;
    final main = icon != null
        ? IconTheme.merge(
            data: IconThemeData(
              color: style.color,
              size: widget.tokens.iconSize,
            ),
            child: icon,
          )
        : Text(
            segment.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          );
    final count = segment.badgeCount;
    if (count == null || count <= 0) return main;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: main),
        const SizedBox(width: 8),
        _LinagoraSegmentBadge(count: count, tokens: widget.tokens),
      ],
    );
  }
}

class _LinagoraSegmentBadge extends StatelessWidget {
  final int count;
  final LinagoraSegmentedTabsStyle tokens;

  const _LinagoraSegmentBadge({required this.count, required this.tokens});

  @override
  Widget build(BuildContext context) {
    // At least 16x16, widens with longer counts.
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.badgeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Text('$count', maxLines: 1, style: tokens.badgeTextStyle),
        ),
      ),
    );
  }
}
