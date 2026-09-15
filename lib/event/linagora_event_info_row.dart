import 'package:flutter/material.dart';

/// How a [LinagoraEventInfoRow] arranges its slots.
enum LinagoraEventInfoRowLayout {
  /// Label beside the value, on one line.
  inline,

  /// Label above the value, with the trailing action below it. This is what
  /// the mobile design uses.
  stacked,

  /// [inline] while the row has room, [stacked] once it is narrower than
  /// `stackedBreakpoint`.
  adaptive,
}

/// One labelled line of an event card — `When`, `Where`, `Who`, `Attending?`.
///
/// Three independent slots: an optional [prefix] label column, the [content]
/// value, and an optional [trailing] action.
///
/// Inline actions such as `See in Map` belong in [content], not [trailing]:
/// they sit in the content run and move with the text. [trailing] is for a
/// separate action, pinned to the far end when [expand] is true and dropped
/// below the content when the row stacks.
class LinagoraEventInfoRow extends StatelessWidget {
  /// Width of the label column, measured from the widest label.
  ///
  /// A localised label can exceed it, so it is a default rather than a
  /// constraint a product must accept.
  static const double defaultPrefixWidth = 67;

  static const double defaultPrefixSpacing = 16;
  static const double defaultTrailingSpacing = 16;

  /// Width below which [LinagoraEventInfoRowLayout.adaptive] stacks.
  static const double defaultStackedBreakpoint = 480;

  /// Gap between the stacked label, value, and trailing action.
  static const double defaultStackedSpacing = 8;

  final Widget? prefix;
  final Widget content;
  final Widget? trailing;

  /// Fixed width for the [prefix] column.
  ///
  /// Null takes the width from an enclosing [LinagoraEventInfoRowGroup], or
  /// lets the prefix hug itself when there is none. Ignored while stacked.
  final double? prefixWidth;

  final double prefixSpacing;
  final double trailingSpacing;

  /// Use [CrossAxisAlignment.start] for multi-line inline content, so the
  /// label stays beside the first line.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether an inline row fills the width it is given, pushing [trailing] to
  /// the far end. False hugs the content. When the available width is
  /// unbounded, the row also hugs its content because there is no finite
  /// space to fill.
  final bool expand;

  final LinagoraEventInfoRowLayout layout;
  final double stackedBreakpoint;
  final double stackedSpacing;

  /// How the stacked slots line up. The `Attending?` row centres them.
  final CrossAxisAlignment stackedAlignment;

  const LinagoraEventInfoRow({
    super.key,
    required this.content,
    this.prefix,
    this.trailing,
    this.prefixWidth,
    this.prefixSpacing = defaultPrefixSpacing,
    this.trailingSpacing = defaultTrailingSpacing,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.expand = false,
    this.layout = LinagoraEventInfoRowLayout.adaptive,
    this.stackedBreakpoint = defaultStackedBreakpoint,
    this.stackedSpacing = defaultStackedSpacing,
    this.stackedAlignment = CrossAxisAlignment.start,
  }) : assert(
         prefixWidth == null ||
             (prefixWidth >= 0 && prefixWidth < double.infinity),
         'Prefix width must be finite and non-negative',
       ),
       assert(
         prefixSpacing >= 0 && prefixSpacing < double.infinity,
         'Prefix spacing must be finite and non-negative',
       ),
       assert(
         trailingSpacing >= 0 && trailingSpacing < double.infinity,
         'Trailing spacing must be finite and non-negative',
       ),
       assert(
         stackedBreakpoint >= 0 && stackedBreakpoint < double.infinity,
         'Stacked breakpoint must be finite and non-negative',
       ),
       assert(
         stackedSpacing >= 0 && stackedSpacing < double.infinity,
         'Stacked spacing must be finite and non-negative',
       ),
       assert(
         crossAxisAlignment != CrossAxisAlignment.baseline,
         'Inline baseline alignment requires a text baseline',
       ),
       assert(
         stackedAlignment != CrossAxisAlignment.baseline,
         'A stacked layout does not support baseline alignment',
       );

  @override
  Widget build(BuildContext context) {
    final column = prefixWidth ?? LinagoraEventInfoPrefixColumn.of(context);

    return switch (layout) {
      LinagoraEventInfoRowLayout.inline => LayoutBuilder(
        builder: (context, constraints) =>
            _buildInline(column, canExpand: constraints.hasBoundedWidth),
      ),
      LinagoraEventInfoRowLayout.stacked => _buildStacked(),
      LinagoraEventInfoRowLayout.adaptive => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return width.isFinite && width < stackedBreakpoint
              ? _buildStacked()
              : _buildInline(column, canExpand: constraints.hasBoundedWidth);
        },
      ),
    };
  }

  Widget _buildInline(double? prefixWidth, {required bool canExpand}) {
    final prefix = this.prefix;
    final trailing = this.trailing;
    final shouldExpand = expand && canExpand;

    return Row(
      mainAxisSize: shouldExpand ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (prefix != null) ...[
          _hug(prefix, width: prefixWidth),
          SizedBox(width: prefixSpacing),
        ],
        if (shouldExpand)
          Expanded(child: _hug(content))
        else
          Flexible(child: content),
        if (trailing != null) ...[SizedBox(width: trailingSpacing), trailing],
      ],
    );
  }

  Widget _buildStacked() {
    final prefix = this.prefix;
    final trailing = this.trailing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: stackedAlignment,
      spacing: stackedSpacing,
      children: [
        if (prefix != null) prefix,
        content,
        if (trailing != null) trailing,
      ],
    );
  }

  /// Pins a slot to the start of its column without letting it stretch to the
  /// row's unbounded cross-axis extent.
  static Widget _hug(Widget child, {double? width}) {
    final aligned = Align(
      alignment: AlignmentDirectional.centerStart,
      heightFactor: 1,
      child: child,
    );
    return width == null ? aligned : SizedBox(width: width, child: aligned);
  }
}

/// A run of values sharing one inline gap, centred against each other.
///
/// This is the shape a row's `content` usually takes: values, then optionally
/// a status icon or an inline link.
///
/// Reflows onto a new line rather than overflowing, so a long value degrades
/// on a narrow window instead of painting past its row.
class LinagoraEventInfoRun extends StatelessWidget {
  static const double defaultSpacing = 8;

  final List<Widget> children;
  final double spacing;

  /// Gap between lines. Defaults to [spacing].
  final double? runSpacing;

  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  const LinagoraEventInfoRun({
    super.key,
    required this.children,
    this.spacing = defaultSpacing,
    this.runSpacing,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.center,
  }) : assert(
         spacing >= 0 && spacing < double.infinity,
         'Run spacing must be finite and non-negative',
       ),
       assert(
         runSpacing == null ||
             (runSpacing >= 0 && runSpacing < double.infinity),
         'Run line spacing must be finite and non-negative',
       );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing ?? spacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

/// The label column width a [LinagoraEventInfoRow] adopts when it sets none.
class LinagoraEventInfoPrefixColumn extends InheritedWidget {
  final double? width;

  const LinagoraEventInfoPrefixColumn({
    super.key,
    required this.width,
    required super.child,
  }) : assert(
         width == null || (width >= 0 && width < double.infinity),
         'Prefix column width must be finite and non-negative',
       );

  static double? of(BuildContext context) {
    final column = context
        .dependOnInheritedWidgetOfExactType<LinagoraEventInfoPrefixColumn>();
    return column?.width;
  }

  @override
  bool updateShouldNotify(LinagoraEventInfoPrefixColumn oldWidget) =>
      width != oldWidget.width;
}

/// Stacks rows and gives them one shared label column, so their values align.
///
/// Any widget can be a row: the column reaches rows nested inside a stateful
/// wrapper or a builder, not just direct children. A row that sets its own
/// `prefixWidth` keeps it.
class LinagoraEventInfoRowGroup extends StatelessWidget {
  static const double defaultSpacing = 16;

  final List<Widget> rows;
  final double spacing;

  /// Label column applied to every row that does not set its own.
  final double? prefixWidth;

  final CrossAxisAlignment crossAxisAlignment;

  const LinagoraEventInfoRowGroup({
    super.key,
    required this.rows,
    this.spacing = defaultSpacing,
    this.prefixWidth = LinagoraEventInfoRow.defaultPrefixWidth,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  }) : assert(
         spacing >= 0 && spacing < double.infinity,
         'Row spacing must be finite and non-negative',
       ),
       assert(
         prefixWidth == null ||
             (prefixWidth >= 0 && prefixWidth < double.infinity),
         'Prefix width must be finite and non-negative',
       ),
       assert(
         crossAxisAlignment != CrossAxisAlignment.baseline,
         'A row group does not support baseline alignment',
       );

  @override
  Widget build(BuildContext context) {
    return LinagoraEventInfoPrefixColumn(
      width: prefixWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        spacing: spacing,
        children: rows,
      ),
    );
  }
}
