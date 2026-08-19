import 'package:flutter/widgets.dart';

/// Counts the product UI open across one sidebar row's actions.
///
/// A count, not a flag: a row can have several actions. Each pairs [begin]
/// with [end]; a surplus [end] is ignored, keeping disposal safe. The first
/// action that opens also identifies itself, allowing a trailing action group
/// to leave only that trigger visible while its product UI is on screen.
class LinagoraSidebarActionActivity extends ChangeNotifier {
  int _activeCount = 0;
  Object? _activeAction;

  int get activeCount => _activeCount;

  bool get isActive => _activeCount > 0;

  /// The action that opened the current product UI, when it came from a
  /// [LinagoraSidebarItemActions] group.
  Object? get activeAction => _activeAction;

  void begin([Object? action]) {
    if (_activeCount == 0) _activeAction = action;
    _activeCount++;
    notifyListeners();
  }

  void end() {
    if (_activeCount == 0) return;
    _activeCount--;
    if (_activeCount == 0) _activeAction = null;
    notifyListeners();
  }
}

/// Makes a row's activity and enabled state available to trailing actions.
///
/// [LinagoraSidebarItem] installs it. An action without a scope still washes
/// itself; it just has no row to keep visible.
class LinagoraSidebarItemActionScope
    extends InheritedNotifier<LinagoraSidebarActionActivity> {
  const LinagoraSidebarItemActionScope({
    super.key,
    required LinagoraSidebarActionActivity activity,
    this.enabled = true,
    required super.child,
  }) : super(notifier: activity);

  /// Whether trailing actions in this row may be activated.
  final bool enabled;

  static LinagoraSidebarItemActionScope? maybeScopeOf(
    BuildContext context,
  ) =>
      context
          .dependOnInheritedWidgetOfExactType<
            LinagoraSidebarItemActionScope
          >();

  /// Returns the nearest row activity, if this action belongs to a sidebar
  /// item trailing slot.
  static LinagoraSidebarActionActivity? maybeOf(BuildContext context) =>
      maybeScopeOf(context)?.notifier;

  @override
  bool updateShouldNotify(LinagoraSidebarItemActionScope oldWidget) =>
      enabled != oldWidget.enabled || super.updateShouldNotify(oldWidget);
}

/// Identifies one child of [LinagoraSidebarItemActions].
///
/// It is deliberately separate from [LinagoraSidebarItemActionScope]: a row
/// owns the activity, while an action group owns the stable identity of each
/// trigger within that row.
class LinagoraSidebarActionSlotScope extends InheritedWidget {
  const LinagoraSidebarActionSlotScope({
    super.key,
    required this.action,
    required super.child,
  });

  final Object action;

  static Object? maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<LinagoraSidebarActionSlotScope>()
          ?.action;

  @override
  bool updateShouldNotify(LinagoraSidebarActionSlotScope oldWidget) =>
      !identical(action, oldWidget.action);
}
