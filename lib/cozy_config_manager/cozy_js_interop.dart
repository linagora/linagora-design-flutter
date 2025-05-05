import 'dart:js_interop';

@JS('window._cozyBridge.requestParentOrigin')
external JSPromise<JSString?> requestParentOriginJs();

@JS('window._cozyBridge.isInsideCozy')
external bool? isInsideCozyJs(String targetOrigin);

@JS('window._cozyBridge.setupBridge')
external bool? setupBridgeJs(String targetOrigin);

@JS('window._cozyBridge.startHistorySyncing')
external void startHistorySyncingJs();
