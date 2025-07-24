import 'package:linagora_design_flutter/cozy_config_manager/cozy_notification_status.dart';

class CozyConfigManager {
  static final CozyConfigManager _instance = CozyConfigManager._internal();
  factory CozyConfigManager() => _instance;
  CozyConfigManager._internal();

  Future<void> injectCozyScript([String cozyBridgeVersion = '']) =>
      throw UnimplementedError();
  Future<bool> get isInsideCozy => throw UnimplementedError();
  Future<void> initialize() => throw UnimplementedError();
  Future<CozyNotificationStatus> requestNotificationPermission() =>
      throw UnimplementedError();
  Future<void> sendNotification(String title, String body) =>
      throw UnimplementedError();
}
