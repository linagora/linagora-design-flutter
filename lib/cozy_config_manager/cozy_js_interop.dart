import 'dart:js_interop';

@JS('window._cozyBridge.requestParentOrigin')
external JSPromise<JSString?> requestParentOriginJs();

@JS('window._cozyBridge.isInsideCozy')
external bool? isInsideCozyJs(String targetOrigin);

@JS('window._cozyBridge.setupBridge')
external bool? setupBridgeJs(String targetOrigin);

@JS('window._cozyBridge.startHistorySyncing')
external void startHistorySyncingJs();

@JS('window._cozyBridge.requestNotificationPermission')
external JSPromise<JSString?> requestNotificationPermissionJs();

@JS('window._cozyBridge.sendNotification')
external void sendNotificationJs(CozyNotificationData data);

extension type CozyNotificationData(JSObject _) implements JSObject {
  external factory CozyNotificationData.create({
    JSString title,
    JSString body,
  });

  external JSString get title;
  external JSString get body;
}
