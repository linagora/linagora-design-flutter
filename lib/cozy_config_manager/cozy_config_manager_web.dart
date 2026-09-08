// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:linagora_design_flutter/cozy_config_manager/cozy_js_interop.dart';
import 'package:linagora_design_flutter/cozy_config_manager/cozy_notification_status.dart';
import 'package:web/web.dart';

class CozyConfigManager {
  static final CozyConfigManager _instance = CozyConfigManager._internal();

  bool _isCozyScriptInjected = false;
  String? _targetOrigin;
  bool _isInitialized = false;

  factory CozyConfigManager() {
    return _instance;
  }

  CozyConfigManager._internal();

  Future<void> injectCozyScript([String cozyBridgeVersion = '0.16.1']) async {
    if (_isCozyScriptInjected) {
      return;
    }
    _isCozyScriptInjected = true;

    // The bundle moved from dist/embedded/bundle.js (<1.x) to dist/bundle.js
    // (1.x+); fall back to the old path so older versions still load.
    final loaded = await _loadScript(
      'https://cdn.jsdelivr.net/npm/cozy-external-bridge@$cozyBridgeVersion/dist/bundle.js',
    );
    if (!loaded) {
      await _loadScript(
        'https://cdn.jsdelivr.net/npm/cozy-external-bridge@$cozyBridgeVersion/dist/embedded/bundle.js',
      );
    }
  }

  Future<bool> _loadScript(String src) async {
    final completer = Completer<bool>();

    final HTMLScriptElement script = HTMLScriptElement();
    script.src = src;
    final onloadListener = script.onLoad.listen((_) => completer.complete(true));
    // Without this the caller awaits forever when the bundle fails to load.
    final onErrorListener = script.onError.listen((_) {
      debugPrint('Failed to load cozy bridge script: ${script.src}');
      completer.complete(false);
    });
    document.head?.append(script);

    final loaded = await completer.future;
    onloadListener.cancel();
    onErrorListener.cancel();
    return loaded;
  }

  Future<bool> get isInsideCozy async {
    _targetOrigin ??= await _getTargetOrigin();
    debugPrint('targetOrigin: $_targetOrigin');
    final isInsideCozy = _targetOrigin != null
        ? (isInsideCozyJs(_targetOrigin!) ?? false)
        : false;
    debugPrint('isInsideCozy: $isInsideCozy');
    return isInsideCozy;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      _targetOrigin ??= await _getTargetOrigin();
      if (_targetOrigin == null) throw Exception('Could not get target origin');
      setupBridgeJs(_targetOrigin!);
      startHistorySyncingJs();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing Cozy bridge: $e');
    }
  }

  Future<String?> _getTargetOrigin() async {
    final targetOrigin = await requestParentOriginJs().toDart;
    return targetOrigin?.toDart;
  }

  Future<CozyNotificationStatus> requestNotificationPermission() async {
    final status = await requestNotificationPermissionJs().toDart;
    return status != null
        ? CozyNotificationStatus.fromJs(status.toDart)
        : CozyNotificationStatus.isUndefined;
  }

  void sendNotification(String title, String body) {
    sendNotificationJs(CozyNotificationData.create(
      title: title.toJS,
      body: body.toJS,
    ));
  }
}
