import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_item.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_item_action_scope.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';

/// Opens product-owned menu UI from a sidebar trailing action.
///
/// Return the [Future] that completes when the product menu closes. Returning
/// null declines to open a menu and immediately restores the idle visual.
///
/// The product keeps ownership of that future, including its errors: a failing
/// future resets the trigger but is not re-raised by the design system.
typedef OnLinagoraSidebarMenuActionPressed =
    Future<Object?>? Function(LinagoraSidebarActionDetails details);

/// A sidebar action that stays active for the lifetime of a product menu.
///
/// The product owns the menu content and calls `showMenu` (or another menu
/// implementation) in [onPressed]. This widget owns the duplicate-tap guard,
/// trigger visual, and the row activity lifecycle.
class LinagoraSidebarMenuAction extends StatefulWidget {
  const LinagoraSidebarMenuAction({
    super.key,
    required this.child,
    required this.semanticLabel,
    required this.onPressed,
    this.padding,
    this.style,
  });

  final Widget child;
  final String semanticLabel;
  final OnLinagoraSidebarMenuActionPressed onPressed;
  final EdgeInsetsGeometry? padding;
  final LinagoraSidebarStyle? style;

  @override
  State<LinagoraSidebarMenuAction> createState() =>
      _LinagoraSidebarMenuActionState();
}

class _LinagoraSidebarMenuActionState extends State<LinagoraSidebarMenuAction> {
  bool _isPending = false;
  LinagoraSidebarActionActivity? _activity;
  bool _activityStarted = false;

  @override
  Widget build(BuildContext context) {
    return LinagoraSidebarItemAction(
      semanticLabel: widget.semanticLabel,
      onPressed: _open,
      padding: widget.padding,
      active: _isPending,
      style: widget.style,
      child: widget.child,
    );
  }

  void _open(LinagoraSidebarActionDetails details) {
    if (_isPending) return;

    final activity = LinagoraSidebarItemActionScope.maybeOf(context);
    _activity = activity;
    _activityStarted = true;
    activity?.begin(LinagoraSidebarActionSlotScope.maybeOf(context));
    setState(() => _isPending = true);

    try {
      final future = widget.onPressed(details);
      if (future == null) {
        _finish();
        return;
      }
      _waitForMenu(future);
    } catch (error, stackTrace) {
      _finish();
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Resets when the product menu settles, however it settles. The error is
  /// absorbed on this branch only: re-raising it from a future nobody awaits
  /// would report the product's failure a second time.
  void _waitForMenu(Future<Object?> future) {
    future
        .then<void>((_) {}, onError: (Object _, StackTrace __) {})
        .whenComplete(_finish);
  }

  void _finish() {
    _endActivity();
    if (!mounted || !_isPending) return;
    setState(() => _isPending = false);
  }

  void _endActivity() {
    if (!_activityStarted) return;
    _activityStarted = false;
    _activity?.end();
    _activity = null;
  }

  @override
  void dispose() {
    _endActivity();
    super.dispose();
  }
}
