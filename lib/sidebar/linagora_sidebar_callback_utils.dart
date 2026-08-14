import 'dart:async';

import 'package:flutter/foundation.dart';

/// Runs an application callback without allowing an unhandled asynchronous
/// error to escape a fire-and-forget sidebar interaction.
Future<bool> runLinagoraSidebarCallback(
  FutureOr<void> Function() callback, {
  required String callbackName,
}) async {
  try {
    await callback();
    return true;
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'linagora_design_flutter',
        context: ErrorDescription('while executing $callbackName'),
      ),
    );
    return false;
  }
}
