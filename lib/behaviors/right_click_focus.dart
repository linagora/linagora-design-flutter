import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Gives [focusNode] focus when its subtree receives a secondary (right) mouse
/// button press, on web only.
class RightClickFocus extends StatelessWidget {
  const RightClickFocus({super.key, required this.child, this.focusNode});

  final Widget child;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final node = focusNode;
    const isWeb = kIsWeb;
    if (node == null || !isWeb) return child;
    return Listener(
      onPointerDown: (event) {
        if (!node.hasFocus &&
            event.kind == PointerDeviceKind.mouse &&
            (event.buttons & kSecondaryMouseButton) != 0) {
          node.requestFocus();
        }
      },
      child: child,
    );
  }
}
