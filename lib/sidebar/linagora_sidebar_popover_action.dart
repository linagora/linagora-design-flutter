import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_item.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_item_action_scope.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';

/// Builds the product-owned content of a sidebar popover.
typedef LinagoraSidebarPopoverBuilder =
    Widget Function(BuildContext context, VoidCallback close);

/// Wraps popover content with a product-specific integration widget.
///
/// For example, a web application can provide a `PointerInterceptor` without
/// adding that dependency to the design system.
typedef LinagoraSidebarPopoverWrapper = Widget Function(Widget child);

/// Notifies a product when a sidebar popover becomes visible or hidden.
typedef OnLinagoraSidebarPopoverVisibleChange = void Function(bool isVisible);

/// Direction-aware placement for [LinagoraSidebarPopoverAction].
class LinagoraSidebarPopoverAnchor {
  const LinagoraSidebarPopoverAnchor({
    this.target = AlignmentDirectional.topEnd,
    this.follower = AlignmentDirectional.bottomStart,
    this.offset = const Offset(0, 50),
  });

  /// Anchor on the trigger target.
  final AlignmentDirectional target;

  /// Matching anchor on the popover follower.
  final AlignmentDirectional follower;

  /// Direction-aware callers can keep this logical: Flutter mirrors the
  /// directional alignments while this physical offset is applied after them.
  final Offset offset;
}

/// An anchored sidebar action for product-owned confirm cards and popovers.
///
/// Uses the SDK's root overlay, so no host widget is needed above a
/// scrollable sidebar. The trigger stays in place and active until the product
/// closes it, the barrier or Escape dismisses it, or the action is disposed.
class LinagoraSidebarPopoverAction extends StatefulWidget {
  const LinagoraSidebarPopoverAction({
    super.key,
    required this.child,
    required this.semanticLabel,
    required this.popoverBuilder,
    this.anchor = const LinagoraSidebarPopoverAnchor(),
    this.padding,
    this.barrierDismissible = true,
    this.modalSemanticLabel,
    this.overlayWrapper,
    this.onVisibleChange,
    this.style,
  }) : assert(
         modalSemanticLabel == null || modalSemanticLabel != '',
         'A modal semantic label must not be empty',
       );

  final Widget child;
  final String semanticLabel;
  final LinagoraSidebarPopoverBuilder popoverBuilder;
  final LinagoraSidebarPopoverAnchor anchor;
  final EdgeInsetsGeometry? padding;
  final bool barrierDismissible;

  /// Optional route label announced when this popover should act as a modal
  /// surface for screen readers. Product code should supply its localized
  /// title for confirmation popovers.
  final String? modalSemanticLabel;

  final LinagoraSidebarPopoverWrapper? overlayWrapper;
  final OnLinagoraSidebarPopoverVisibleChange? onVisibleChange;
  final LinagoraSidebarStyle? style;

  @override
  State<LinagoraSidebarPopoverAction> createState() =>
      _LinagoraSidebarPopoverActionState();
}

class _LinagoraSidebarPopoverActionState
    extends State<LinagoraSidebarPopoverAction> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final FocusNode _triggerFocusNode = FocusNode();
  late final FocusScopeNode _popoverFocusNode = FocusScopeNode(
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    onKeyEvent: _onPopoverKeyEvent,
  );

  LinagoraSidebarActionActivity? _activity;
  bool _activityStarted = false;
  bool _isOpen = false;
  bool? _wasRouteCurrent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.isCurrentOf(context);
    if (_wasRouteCurrent == true && isCurrent == false && _isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isOpen) _close();
      });
    }
    _wasRouteCurrent = isCurrent;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: !_isOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _close();
      },
      child: OverlayPortal(
        controller: _overlayController,
        overlayLocation: OverlayChildLocation.rootOverlay,
        overlayChildBuilder: _buildOverlay,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: LinagoraSidebarItemAction(
            semanticLabel: widget.semanticLabel,
            onTap: _open,
            padding: widget.padding ?? LinagoraSidebarItemAction.textPadding,
            active: _isOpen,
            focusNode: _triggerFocusNode,
            style: widget.style,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final direction = Directionality.of(context);
    final popover = FocusScope.withExternalFocusNode(
      focusScopeNode: _popoverFocusNode,
      autofocus: true,
      child: FocusTraversalGroup(
        child: widget.popoverBuilder(context, _close),
      ),
    );
    final wrappedPopover = widget.overlayWrapper?.call(popover) ?? popover;
    final modalSemanticLabel = widget.modalSemanticLabel;
    final accessiblePopover = modalSemanticLabel == null
        ? wrappedPopover
        : Semantics(
            container: true,
            explicitChildNodes: true,
            scopesRoute: true,
            namesRoute: true,
            label: modalSemanticLabel,
            child: wrappedPopover,
          );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ExcludeSemantics(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.barrierDismissible ? _close : null,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: widget.anchor.target.resolve(direction),
            followerAnchor: widget.anchor.follower.resolve(direction),
            offset: widget.anchor.offset,
            showWhenUnlinked: false,
            child: accessiblePopover,
          ),
        ),
      ],
    );
  }

  void _open() {
    if (_isOpen) return;

    _activity = LinagoraSidebarItemActionScope.maybeOf(context);
    _activityStarted = true;
    _activity?.begin(LinagoraSidebarActionSlotScope.maybeOf(context));
    setState(() => _isOpen = true);
    _overlayController.show();
    widget.onVisibleChange?.call(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isOpen) _popoverFocusNode.requestFocus();
    });
  }

  KeyEventResult _onPopoverKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _close() {
    if (!_isOpen) return;

    if (_overlayController.isShowing) _overlayController.hide();
    _endActivity();
    if (mounted) setState(() => _isOpen = false);
    widget.onVisibleChange?.call(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _triggerFocusNode.requestFocus();
    });
  }

  void _endActivity() {
    if (!_activityStarted) return;
    _activityStarted = false;
    _activity?.end();
    _activity = null;
  }

  @override
  void dispose() {
    if (_isOpen) {
      if (_overlayController.isShowing) _overlayController.hide();
      _endActivity();
      widget.onVisibleChange?.call(false);
    }
    _triggerFocusNode.dispose();
    _popoverFocusNode.dispose();
    super.dispose();
  }
}
