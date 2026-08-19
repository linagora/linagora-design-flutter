import 'package:flutter/foundation.dart';

const Duration sidebarStorageReloadDelay = Duration(milliseconds: 750);

Future<void> reloadSidebarStoragePreview({
  required void Function(VoidCallback callback) setState,
  required bool Function() isMounted,
  required ValueSetter<bool> setReloading,
  required ValueSetter<String> setStatus,
}) async {
  setState(() {
    setReloading(true);
    setStatus('Refreshing storage…');
  });
  await Future<void>.delayed(sidebarStorageReloadDelay);
  if (!isMounted()) return;
  setState(() {
    setReloading(false);
    setStatus('Storage refreshed');
  });
}
