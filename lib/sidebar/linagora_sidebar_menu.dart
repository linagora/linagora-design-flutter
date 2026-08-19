import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_scroll_coordinator.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// Layout tokens for the regions composed by [LinagoraSidebarMenu].
class LinagoraSidebarMenuLayout {
  const LinagoraSidebarMenuLayout({
    this.primaryActionPadding = LinagoraSidebarMenu.primaryActionPadding,
    this.primaryActionSpacing = LinagoraSidebarMenu.primaryActionSpacing,
    this.sectionSpacing = LinagoraSidebarMenu.sectionSpacing,
    this.footerPadding = LinagoraSidebarMenu.footerPadding,
    this.footerSpacing = LinagoraSidebarMenu.footerSpacing,
    this.footerItemSpacing = LinagoraSidebarMenu.footerItemSpacing,
    this.scrollContentPadding = LinagoraSidebarMenu.scrollContentPadding,
  }) : assert(
         primaryActionSpacing >= 0 &&
             sectionSpacing >= 0 &&
             footerSpacing >= 0 &&
             footerItemSpacing >= 0,
         'Sidebar menu spacing cannot be negative',
       );

  final EdgeInsetsGeometry primaryActionPadding;
  final double primaryActionSpacing;
  final double sectionSpacing;
  final EdgeInsetsGeometry footerPadding;
  final double footerSpacing;
  final double footerItemSpacing;
  final EdgeInsetsGeometry scrollContentPadding;
}

/// Composes the regions of a complete sidebar menu.
///
/// The application supplies the actual components: a compose/create action,
/// navigation rows, folder or label sections, and optional footer content such
/// as [LinagoraSidebarStorage] and [LinagoraSidebarVersion]. The menu keeps
/// the action and footer in place while the navigation and section content
/// scrolls between them.
///
/// Supplying an empty list or `null` slot removes that region without leaving
/// a visual gap. This lets a product use the same shell for mail, files, or a
/// compact sidebar that only has a subset of the standard menu.
///
/// The scrolling body is one scroll view built from slivers, so a section can
/// hand it a virtualized [LinagoraSidebarSliverTreeList] — see
/// [LinagoraSidebarMenuSection.sliver]. A mailbox with hundreds of folders
/// then builds only the rows near the viewport while the headers and
/// navigation rows above them scroll along.
class LinagoraSidebarMenu extends StatelessWidget {
  /// Horizontal inset for sidebar content. Row components add their own
  /// internal inset, so their labels align with the primary action.
  static const double horizontalPadding = LinagoraSpacing.base * 2;

  /// Vertical inset at the top and bottom of the menu.
  static const double verticalPadding = LinagoraSpacing.base * 2;

  /// Keeps the viewport scrollbar flush with the sidebar edge.
  static const double trailingPadding = 0;

  /// Target inset between the pinned footer and the sidebar frame.
  ///
  /// The menu's outer padding already supplies [horizontalPadding] on the
  /// start and [verticalPadding] at the bottom, while [trailingPadding] keeps
  /// the scrollbar flush to the end edge. [footerPadding] supplies the
  /// remaining space so the footer has the 24dp inset specified by Figma on
  /// all three sides.
  static const double footerInset = LinagoraSpacing.base * 3;

  /// Additional padding needed to give the pinned footer its own bounds.
  static const EdgeInsetsGeometry footerPadding =
      EdgeInsetsDirectional.fromSTEB(
        footerInset - horizontalPadding,
        0,
        footerInset - trailingPadding,
        footerInset - verticalPadding,
      );

  /// Outer sidebar rhythm. Rows add their own internal content inset.
  static const EdgeInsetsGeometry defaultPadding =
      EdgeInsetsDirectional.fromSTEB(
        horizontalPadding,
        verticalPadding,
        trailingPadding,
        verticalPadding,
      );

  /// Keeps the primary action on the same content bounds as rows, clear of
  /// the viewport scrollbar at the outer edge.
  static const EdgeInsetsGeometry primaryActionPadding =
      EdgeInsetsDirectional.only(end: scrollbarSpacing);

  static const double primaryActionSpacing = LinagoraSpacing.base * 3;
  static const double sectionSpacing = LinagoraSpacing.base * 3;
  static const double footerSpacing = LinagoraSpacing.base * 3;
  static const double footerItemSpacing = LinagoraSpacing.base * 1.5;
  static const double scrollbarSpacing = LinagoraSpacing.base * 2;

  /// Keeps a desktop scrollbar clear of row affordances while the scrollbar
  /// itself remains aligned to the sidebar edge.
  static const EdgeInsetsGeometry scrollContentPadding =
      EdgeInsetsDirectional.only(end: scrollbarSpacing);

  const LinagoraSidebarMenu({
    super.key,
    this.primaryAction,
    this.navigationItems = const [],
    this.sections = const [],
    this.footerItems = const [],
    this.bodyOverlay,
    this.padding = defaultPadding,
    this.layout = const LinagoraSidebarMenuLayout(),
    this.controller,
    this.physics,
  });

  /// The compose, create, or new action at the top of the menu.
  final Widget? primaryAction;

  /// Primary destinations, usually [LinagoraSidebarItem]s.
  final List<Widget> navigationItems;

  /// Groups such as folders and labels. Each entry owns its own header and
  /// rows, allowing applications to add, remove, and reorder whole sections.
  final List<LinagoraSidebarMenuSection> sections;

  /// Bottom-aligned content, usually [LinagoraSidebarStorage] and
  /// [LinagoraSidebarVersion].
  final List<Widget> footerItems;

  /// Optional overlay constrained to the scrollable navigation and sections
  /// body. It never covers a pinned primary action or footer.
  final Widget? bodyOverlay;

  final EdgeInsetsGeometry padding;

  /// Layout tokens for spacing and insets between menu regions.
  final LinagoraSidebarMenuLayout layout;

  /// Controls the scrollable navigation and section region.
  final ScrollController? controller;

  /// Applies to the scrolling body. An unbounded menu has nothing to scroll
  /// in, so its body never scrolls regardless of what is passed here.
  final ScrollPhysics? physics;

  bool get _hasBody => navigationItems.isNotEmpty || sections.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return LinagoraSidebarScrollCoordinator(
      controller: controller,
      child: Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.hasBoundedHeight) return _boundedLayout();
            return _unboundedLayout();
          },
        ),
      ),
    );
  }

  Widget _boundedLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (primaryAction != null) _primaryAction(),
        if (primaryAction != null && _hasBody)
          SizedBox(height: layout.primaryActionSpacing),
        if (_hasBody)
          Expanded(child: _body(shrinkWrap: false))
        else
          const Spacer(),
        if (footerItems.isNotEmpty) ...[
          SizedBox(height: layout.footerSpacing),
          _footerItems(),
        ],
      ],
    );
  }

  Widget _unboundedLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (primaryAction != null) _primaryAction(),
        if (primaryAction != null && _hasBody)
          SizedBox(height: layout.primaryActionSpacing),
        if (_hasBody) _body(shrinkWrap: true),
        if (footerItems.isNotEmpty) ...[
          if (_hasBody || primaryAction != null)
            SizedBox(height: layout.footerSpacing),
          _footerItems(),
        ],
      ],
    );
  }

  /// One scroll view for the whole body, so a section's sliver virtualizes
  /// against the same viewport as the rows around it.
  ///
  /// An unbounded parent hands the menu no viewport, so the body sizes itself
  /// to its content and leaves scrolling to that parent. Shrink-wrapping lays
  /// every row out, which is what unbounded means — a product that needs the
  /// virtualization has to give the menu a bounded height.
  Widget _body({required bool shrinkWrap}) {
    final body = CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : physics,
      primary: false,
      slivers: _bodySlivers(),
    );

    if (shrinkWrap || bodyOverlay == null) return body;

    return Stack(
      fit: StackFit.expand,
      children: [body, bodyOverlay!],
    );
  }

  List<Widget> _bodySlivers() {
    return [
      if (navigationItems.isNotEmpty)
        _inset(SliverList.list(children: navigationItems)),
      for (var index = 0; index < sections.length; index++) ...[
        if (index > 0 || navigationItems.isNotEmpty) _gap(layout.sectionSpacing),
        ..._sectionSlivers(sections[index]),
      ],
    ];
  }

  List<Widget> _sectionSlivers(LinagoraSidebarMenuSection section) {
    final header = section.header;
    final sliver = section.sliver;
    final hasContent = section.children.isNotEmpty || sliver != null;

    return [
      if (header != null) _inset(SliverToBoxAdapter(child: header)),
      if (header != null && hasContent) _gap(section.headerSpacing),
      if (section.children.isNotEmpty)
        _inset(SliverList.list(children: section.children)),
      if (sliver != null) _inset(sliver),
    ];
  }

  Widget _inset(Widget sliver) =>
      SliverPadding(padding: layout.scrollContentPadding, sliver: sliver);

  Widget _gap(double height) =>
      SliverToBoxAdapter(child: SizedBox(height: height));

  Widget _primaryAction() =>
      Padding(padding: layout.primaryActionPadding, child: primaryAction);

  Widget _footerItems() => Padding(
    padding: layout.footerPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _separated(footerItems, layout.footerItemSpacing),
    ),
  );

  List<Widget> _separated(List<Widget> children, double spacing) => [
    for (var index = 0; index < children.length; index++) ...[
      if (index > 0) SizedBox(height: spacing),
      children[index],
    ],
  ];
}

/// One region of the scrolling [LinagoraSidebarMenu] body.
///
/// A section is a [header] — usually a [LinagoraSidebarSectionHeader] — above
/// its content. The content is either [children], which measure themselves,
/// or a [sliver] for a folder tree that has to stay virtualized. Both can be
/// supplied, in which case the sliver follows the children.
///
/// A collapsed section keeps its header and drops its content, so passing an
/// empty [children] list and a null [sliver] is the collapsed state rather
/// than an error.
class LinagoraSidebarMenuSection {
  /// Gap between a header and the content beneath it.
  static const double defaultHeaderSpacing = LinagoraSpacing.base;

  const LinagoraSidebarMenuSection({
    this.header,
    this.children = const [],
    this.sliver,
    this.headerSpacing = defaultHeaderSpacing,
  }) : assert(
         header != null || children.length > 0 || sliver != null,
         'A sidebar menu section needs a header, children, or a sliver',
       ),
       assert(
         headerSpacing >= 0,
         'A sidebar menu section header spacing cannot be negative',
       );

  /// Usually a [LinagoraSidebarSectionHeader]. Null for a group of rows that
  /// carries no header.
  final Widget? header;

  /// Rows that measure themselves, usually [LinagoraSidebarItem]s.
  final List<Widget> children;

  /// Virtualized content, usually a [LinagoraSidebarSliverTreeList].
  ///
  /// This is what lets a mailbox with hundreds of folders live in the menu:
  /// the tree shares the menu's scroll view instead of nesting a second one,
  /// which a bounded box would need and which would scroll on its own.
  final Widget? sliver;

  final double headerSpacing;
}
