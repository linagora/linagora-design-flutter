// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:js_interop';
import 'dart:js_util';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:linagora_design_flutter/cozy_config_manager/cozy_js_interop.dart';
import 'package:linagora_design_flutter/cozy_config_manager/cozy_notification_status.dart';

class CozyConfigManager {
  static final CozyConfigManager _instance = CozyConfigManager._internal();

  bool _isCozyScriptInjected = false;
  String? _targetOrigin;
  bool _isInitialized = false;

  factory CozyConfigManager() {
    return _instance;
  }

  CozyConfigManager._internal();

  Future<void> injectCozyScript() async {
    if (_isCozyScriptInjected) {
      return;
    }

    final jsContent = await rootBundle.loadString(
      'packages/linagora_design_flutter/lib/cozy_config_manager/assets/bundle.js',
    );
    final ScriptElement script = ScriptElement();
    script.text = jsContent;
    document.head?.append(script);
    _isCozyScriptInjected = true;
  }
  
  bool get isInIframe {
    final isInIframe = isInIframeJs();
    debugPrint('isInIframe: $isInIframe');
    return isInIframe;
  }

  bool get isInContainer {
    return _isInitialized;
  }

  Future<void> initialize({required List<String> validUrlSuffixes}) async {
    if (_isInitialized) return;
    try {
      _targetOrigin ??= await _getTargetOrigin();
      if (_targetOrigin == null) throw Exception('Could not get target origin');
      
      if (_validateTargetOrigin(validUrlSuffixes)) {
        setupBridgeJs(_targetOrigin!);
        startHistorySyncingJs();
        _isInitialized = true;
      } else {
        debugPrint('Error initializing Cozy bridge: invalid target origin $_targetOrigin');
      }
    } catch (e) {
      debugPrint('Error initializing Cozy bridge: $e');
    }
  }
  
  bool _validateTargetOrigin(List<String> validUrlSuffixes) {
    return validUrlSuffixes.any((suffix) => _targetOrigin!.endsWith(suffix));
  }

  Future<String?> _getTargetOrigin() async {
    final targetOrigin = await promiseToFuture(requestParentOriginJs());
    return targetOrigin is JSString ? targetOrigin.toDart : null;
  }

  Future<CozyNotificationStatus> requestNotificationPermission() async {
    final status = await promiseToFuture(requestNotificationPermissionJs());
    return status is JSString
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
