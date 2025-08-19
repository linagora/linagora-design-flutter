import 'dart:async';
import 'dart:html';
import 'dart:js_interop';
import 'dart:js_util';

import 'package:flutter/foundation.dart';
import 'package:linagora_design_flutter/cozy_config_manager/cozy_js_interop.dart';

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

    final completer = Completer<void>();

    final ScriptElement script = ScriptElement();
    script.src =
        'https://cdn.jsdelivr.net/npm/cozy-external-bridge@$cozyBridgeVersion/dist/embedded/bundle.js';
    final onloadListener = script.onLoad.listen((_) => completer.complete());
    document.head?.append(script);
    _isCozyScriptInjected = true;

    await completer.future;
    onloadListener.cancel();
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
    final targetOrigin = await promiseToFuture(requestParentOriginJs());
    return targetOrigin is JSString ? targetOrigin.toDart : null;
  }
}
