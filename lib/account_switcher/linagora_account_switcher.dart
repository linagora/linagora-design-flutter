import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/account_switcher/linagora_account_menu.dart';
import 'package:linagora_design_flutter/account_switcher/linagora_account_menu_shell.dart';
import 'package:linagora_design_flutter/account_switcher/linagora_account_switcher_style.dart';

/// A chip naming the account on screen that opens a [LinagoraAccountMenu]
/// below it, end-aligned.
///
/// Pass [label] for the named chip, or omit it with [semanticLabel] for the
/// avatar-only compact chip. [sections] is the same open-ended list the menu
/// renders (own mailbox, delegated, team, …). The menu closes on selection,
/// Escape, a tap outside, or when the route is covered. Focus returns to the
/// chip, except when a route covered it.
class LinagoraAccountSwitcher<T> extends StatefulWidget {
  static const Key chipKey = ValueKey('linagora_account_switcher_chip');
  static const Key menuKey = ValueKey('linagora_account_switcher_menu');

  /// Visible chip text. Null keeps only the avatar and chevron.
  final String? label;

  /// Screen-reader name of the chip when [label] is null.
  final String? semanticLabel;
  final Widget? avatar;
  final List<LinagoraAccountSection<T>> sections;
  final T? selectedId;
  final ValueChanged<T> onSelected;

  /// Screen-reader name of the opened menu.
  final String menuSemanticLabel;
  final LinagoraAccountSwitcherStyle? style;

  const LinagoraAccountSwitcher({
    super.key,
    this.label,
    this.semanticLabel,
    required this.sections,
    required this.selectedId,
    required this.onSelected,
    required this.menuSemanticLabel,
    this.avatar,
    this.style,
  }) : assert(
          label != null || semanticLabel != null,
          'label or semanticLabel is required',
        );
  @override
  State<LinagoraAccountSwitcher<T>> createState() =>
      _LinagoraAccountSwitcherState<T>();
}

class _LinagoraAccountSwitcherState<T>
    extends State<LinagoraAccountSwitcher<T>> {
  static const double _screenMargin = 8;

  /// Prefer opening above when less than this many logical pixels remain below.
  static const double _minMenuRoom = 96;

  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final FocusNode _chipFocusNode = FocusNode();
  late final FocusScopeNode _menuFocusNode = FocusScopeNode(
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    onKeyEvent: _onMenuKeyEvent,
  );
  bool _isOpen = false;
  bool? _wasRouteCurrent;

  LinagoraAccountSwitcherStyle get _tokens =>
      widget.style ?? LinagoraAccountSwitcherStyle.material();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.isCurrentOf(context);
    final routeCovered = _wasRouteCurrent == true && isCurrent == false;
    if (routeCovered && _isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isOpen) _close(returnFocus: false);
      });
    }
    _wasRouteCurrent = isCurrent;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: !_isOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: OverlayPortal(
        controller: _overlayController,
        overlayLocation: OverlayChildLocation.rootOverlay,
        overlayChildBuilder: _buildOverlay,
        child: CompositedTransformTarget(link: _layerLink, child: _chip()),
      ),
    );
  }

  Widget _chip() {
    final tokens = _tokens;
    final radius = BorderRadius.circular(tokens.chipRadius);
    final shape = RoundedRectangleBorder(
      borderRadius: radius,
      side: BorderSide(color: tokens.chipBorderColor),
    );
    final avatar = widget.avatar;
    final label = widget.label;
    return Semantics(
      button: true,
      expanded: _isOpen,
      label: widget.label == null ? widget.semanticLabel : null,
      child: Material(
        color: tokens.chipColor,
        shape: shape,
        child: InkWell(
          key: LinagoraAccountSwitcher.chipKey,
          focusNode: _chipFocusNode,
          customBorder: shape,
          hoverColor: tokens.chipHoverColor,
          onTap: _isOpen ? _close : _open,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: tokens.chipHeight),
            child: Padding(
              padding: tokens.chipPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (avatar != null) ...[
                    ExcludeSemantics(
                      child: SizedBox.square(
                        dimension: tokens.chipAvatarSize,
                        child: avatar,
                      ),
                    ),
                    if (label != null) SizedBox(width: tokens.chipGap),
                  ],
                  if (label != null) ...[
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.chipTextStyle,
                      ),
                    ),
                    SizedBox(width: tokens.chipGap),
                  ],
                  Icon(
                    _isOpen ? Icons.expand_less : Icons.expand_more,
                    size: tokens.chipIconSize,
                    color: tokens.chipIconColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final tokens = _tokens;
    final direction = Directionality.of(overlayContext);
    final placement = _menuPlacement(
      tokens,
      MediaQuery.sizeOf(overlayContext),
      direction,
    );
    final menu = Semantics(
      container: true,
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: widget.menuSemanticLabel,
      child: FocusScope.withExternalFocusNode(
        focusScopeNode: _menuFocusNode,
        autofocus: true,
        child: FocusTraversalGroup(
          child: LinagoraAccountMenuShell(
            menuMaterialKey: LinagoraAccountSwitcher.menuKey,
            maxHeight: placement.maxHeight,
            style: tokens,
            child: LinagoraAccountMenu<T>(
              sections: widget.sections,
              selectedId: widget.selectedId,
              style: tokens,
              onSelected: (id) {
                _close();
                widget.onSelected(id);
              },
            ),
          ),
        ),
      ),
    );

    // shortcut: OverlayPortal barrier does not block a11y taps on covered
    // page controls (same as LinagoraSidebarPopoverAction); upgrade both to
    // a PopupRoute/ModalBarrier when a true modal menu is required.
    final targetAnchor = placement.openAbove
        ? AlignmentDirectional.topEnd
        : AlignmentDirectional.bottomEnd;
    final followerAnchor = placement.openAbove
        ? AlignmentDirectional.bottomEnd
        : AlignmentDirectional.topEnd;
    final dy = placement.openAbove ? -tokens.menuOffset : tokens.menuOffset;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ExcludeSemantics(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: targetAnchor.resolve(direction),
            followerAnchor: followerAnchor.resolve(direction),
            offset: Offset(placement.dx, dy),
            showWhenUnlinked: false,
            child: menu,
          ),
        ),
      ],
    );
  }

  /// Shifts the menu sideways and caps its height so it stays on screen.
  /// Opens above the chip when there is more room there than below.
  ({double dx, double maxHeight, bool openAbove}) _menuPlacement(
    LinagoraAccountSwitcherStyle tokens,
    Size screen,
    TextDirection direction,
  ) {
    final chip = context.findRenderObject();
    if (chip is! RenderBox || !chip.hasSize) {
      return (dx: 0, maxHeight: tokens.menuMaxHeight, openAbove: false);
    }
    final rect = chip.localToGlobal(Offset.zero) & chip.size;
    final dx = direction == TextDirection.ltr
        ? math.max(0.0, _screenMargin - (rect.right - tokens.menuWidth))
        : math.min(
            0.0,
            screen.width - _screenMargin - (rect.left + tokens.menuWidth),
          );
    final below =
        screen.height - rect.bottom - tokens.menuOffset - _screenMargin;
    final above = rect.top - tokens.menuOffset - _screenMargin;
    final openAbove = below < _minMenuRoom && above > below;
    final room = openAbove ? above : below;
    // Wrap content up to the free space on screen; scroll only beyond that.
    return (
      dx: dx,
      maxHeight: math.max(0.0, room),
      openAbove: openAbove,
    );
  }

  void _open() {
    if (_isOpen) return;
    setState(() => _isOpen = true);
    _overlayController.show();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isOpen) _menuFocusNode.requestFocus();
    });
  }

  void _close({bool returnFocus = true}) {
    if (!_isOpen) return;
    if (_overlayController.isShowing) _overlayController.hide();
    if (mounted) setState(() => _isOpen = false);
    if (!returnFocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || ModalRoute.isCurrentOf(context) == false) return;
      _chipFocusNode.requestFocus();
    });
  }

  KeyEventResult _onMenuKeyEvent(FocusNode node, KeyEvent event) {
    if (_isEscape(event)) {
      _close();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  bool _isEscape(KeyEvent event) {
    return event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape;
  }

  @override
  void dispose() {
    if (_overlayController.isShowing) _overlayController.hide();
    _chipFocusNode.dispose();
    _menuFocusNode.dispose();
    super.dispose();
  }
}
